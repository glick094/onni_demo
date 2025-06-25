import 'package:flutter/services.dart' show rootBundle;
import '../models/wellness_data.dart';

class AssessmentDataService {
  static final AssessmentDataService _instance = AssessmentDataService._internal();
  factory AssessmentDataService() => _instance;
  AssessmentDataService._internal();

  // Cache parsed data to avoid re-parsing
  Map<String, List<AssessmentRecord>>? _cachedRecords;
  
  /// Load and parse the TSV file
  Future<List<AssessmentRecord>> _loadTsvData() async {
    if (_cachedRecords != null && _cachedRecords!.isNotEmpty) {
      return _cachedRecords!.values.expand((records) => records).toList();
    }

    try {
      final String tsvData = await rootBundle.loadString('assets/data/ann_environmental_assessment.tsv');
      final List<String> lines = tsvData.split('\n');
      
      // Skip header line and empty lines
      final List<AssessmentRecord> records = [];
      
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;
        
        final columns = line.split('\t');
        if (columns.length >= 8) {
          records.add(AssessmentRecord.fromTsvRow(columns));
        }
      }

      // Cache the data by assessment ID
      _cachedRecords = {};
      for (final record in records) {
        _cachedRecords!.putIfAbsent(record.assessmentId, () => []).add(record);
      }

      return records;
    } catch (e) {
      throw Exception('Failed to load assessment data: $e');
    }
  }

  /// Get environmental dimension data for a specific assessment ID
  Future<DimensionScore> getEnvironmentalDimensionScore(String assessmentId) async {
    final allRecords = await _loadTsvData();
    
    // Filter records for this assessment ID and environmental areas
    final environmentalRecords = allRecords
        .where((record) => record.assessmentId == assessmentId)
        .toList();

    if (environmentalRecords.isEmpty) {
      throw Exception('No environmental assessment data found for assessment ID: $assessmentId');
    }

    // Group records by assessment area (Bathroom, Kitchen, etc.)
    final Map<String, List<AssessmentRecord>> groupedByArea = {};
    for (final record in environmentalRecords) {
      groupedByArea.putIfAbsent(record.assessmentArea, () => []).add(record);
    }

    // Convert to SubSection and Issue objects
    final List<SubSection> subSections = [];
    
    for (final area in groupedByArea.keys) {
      final areaRecords = groupedByArea[area]!;
      
      // Group by modification type to collect all images for each modification
      final Map<String, List<AssessmentRecord>> modificationGroups = {};
      for (final record in areaRecords) {
        modificationGroups.putIfAbsent(record.modification, () => []).add(record);
      }
      
      final List<Issue> issues = modificationGroups.entries
          .map((entry) => _createIssueFromRecords(entry.value))
          .toList();

      if (issues.isNotEmpty) {
        subSections.add(SubSection(
          id: area.toLowerCase().replaceAll(' ', '_').replaceAll('/', '_'),
          name: area.toUpperCase(),
          issues: issues,
          isExpanded: true,
        ));
      }
    }

    // Calculate overall score based on issues
    final double score = _calculateDimensionScore(subSections);

    return DimensionScore(
      dimensionId: 'environmental',
      score: score,
      insights: _generateInsights(subSections),
      subSections: subSections,
    );
  }

  /// Calculate dimension score based on issue statuses
  double _calculateDimensionScore(List<SubSection> subSections) {
    if (subSections.isEmpty) return 0.5;

    int totalIssues = 0;
    int passedIssues = 0;
    int urgentIssues = 0;

    for (final subSection in subSections) {
      for (final issue in subSection.issues) {
        totalIssues++;
        if (issue.status == IssueStatus.passed) {
          passedIssues++;
        } else if (issue.status == IssueStatus.urgent) {
          urgentIssues++;
        }
      }
    }

    if (totalIssues == 0) return 0.5;

    // Score calculation: passed issues contribute positively, urgent issues negatively
    final double passedRatio = passedIssues / totalIssues;
    final double urgentRatio = urgentIssues / totalIssues;
    
    // Base score from passed items, reduced by urgent items
    final double score = (passedRatio * 0.8) + ((1 - urgentRatio) * 0.2);
    
    return score.clamp(0.0, 1.0);
  }

  /// Create an Issue from multiple AssessmentRecord objects with the same modification
  Issue _createIssueFromRecords(List<AssessmentRecord> records) {
    if (records.isEmpty) {
      throw ArgumentError('Cannot create issue from empty records list');
    }

    // Use the first record for basic info (they should all have the same modification info)
    final firstRecord = records.first;
    
    // Collect all image URLs from all records
    final List<String> imageUrls = [];
    for (final record in records) {
      if (record.image.isNotEmpty) {
        // final imageUrl = 'images/ann_assessment/${_getAreaFolder(record.assessmentArea)}/${record.image}';
        // final imageUrl = 'assets/images/ann_assessment/${_getAreaFolder(record.assessmentArea)}/${record.image}';
        final imageUrl = 'assets/images/${record.image}';
        imageUrls.add(imageUrl);
      }
    }

    return Issue(
      id: firstRecord.modificationId,
      title: firstRecord.modification,
      description: firstRecord.description,
      status: _parseStatus(firstRecord.status),
      imageUrls: imageUrls,
    );
  }

  /// Generate insights based on assessment results
  List<String> _generateInsights(List<SubSection> subSections) {
    final List<String> insights = [];
    
    int urgentCount = 0;
    int passedCount = 0;
    
    for (final subSection in subSections) {
      for (final issue in subSection.issues) {
        if (issue.status == IssueStatus.urgent) urgentCount++;
        if (issue.status == IssueStatus.passed) passedCount++;
      }
    }

    if (urgentCount > 0) {
      insights.add('$urgentCount urgent safety improvements needed');
    }
    if (passedCount > 0) {
      insights.add('$passedCount safety features already in place');
    }
    
    // Add area-specific insights
    final areaNames = subSections.map((s) => s.name.toLowerCase()).toSet();
    if (areaNames.contains('bathroom')) {
      insights.add('Bathroom safety assessment completed');
    }
    if (areaNames.contains('exterior')) {
      insights.add('Exterior accessibility reviewed');
    }

    return insights;
  }

  /// Get all available assessment IDs
  Future<List<String>> getAvailableAssessmentIds() async {
    final allRecords = await _loadTsvData();
    return allRecords.map((r) => r.assessmentId).toSet().toList();
  }

  /// Parse status string to IssueStatus enum
  IssueStatus _parseStatus(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'urgent':
        return IssueStatus.urgent;
      case 'not urgent':
        return IssueStatus.nonUrgent;
      case 'passed':
        return IssueStatus.passed;
      default:
        return IssueStatus.nonUrgent;
    }
  }

  /// Map assessment areas to folder names in assets
  String _getAreaFolder(String assessmentArea) {
    switch (assessmentArea.toLowerCase()) {
      case 'bathroom':
        return 'Bathroom';
      case 'bedroom':
        return 'Bedroom';
      case 'entry / foyer':
      case 'entry':
        return 'Entry';
      case 'exterior':
        return 'Exterior';
      case 'garage safety checklist':
      case 'garage':
        return 'Garage';
      case 'kitchen':
        return 'Kitchen';
      case 'smart home technology':
      case 'security upgrades':
        return 'Security-Smarthome';
      default:
        return 'Bathroom'; // Default fallback
    }
  }
}

/// Represents a single row from the TSV file
class AssessmentRecord {
  final String photoId;
  final String assessmentId;
  final String modificationId;
  final String assessmentArea;
  final String modification;
  final String description;
  final String status;
  final String image;

  AssessmentRecord({
    required this.photoId,
    required this.assessmentId,
    required this.modificationId,
    required this.assessmentArea,
    required this.modification,
    required this.description,
    required this.status,
    required this.image,
  });

  factory AssessmentRecord.fromTsvRow(List<String> columns) {
    return AssessmentRecord(
      photoId: columns[0].trim(),
      assessmentId: columns[1].trim(),
      modificationId: columns[2].trim(),
      assessmentArea: columns[3].trim(),
      modification: columns[4].trim(),
      description: columns[5].trim(),
      status: columns[6].trim(),
      image: columns[7].trim(),
    );
  }

}
