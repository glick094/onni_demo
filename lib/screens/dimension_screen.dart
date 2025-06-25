import 'package:flutter/material.dart';
import '../models/wellness_data.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/dashboard/dimension_score_gauge.dart';
import '../widgets/dashboard/subsection_card.dart';
import '../services/assessment_data_service.dart';

class DimensionScreen extends StatefulWidget {
  final String dimensionId;
  final DimensionScore? dimensionData;
  final String? assessmentId;

  const DimensionScreen({
    super.key,
    required this.dimensionId,
    this.dimensionData,
    this.assessmentId,
  });

  @override
  State<DimensionScreen> createState() => _DimensionScreenState();
}

class _DimensionScreenState extends State<DimensionScreen> {
  final AssessmentDataService _dataService = AssessmentDataService();

  @override
  Widget build(BuildContext context) {
    // Find dimension info from constants
    final dimension = AppConstants.dimensions.firstWhere(
      (d) => d['id'] == widget.dimensionId,
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _buildContent(dimension),
    );
  }

  Widget _buildContent(Map<String, dynamic> dimension) {
    // For environmental dimension with assessment ID, load from TSV
    if (widget.dimensionId == 'environmental' && widget.assessmentId != null) {
      return FutureBuilder<DimensionScore>(
        future: _dataService.getEnvironmentalDimensionScore(widget.assessmentId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppTheme.redColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading assessment data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDarkColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMediumColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          
          if (snapshot.hasData) {
            return _buildDimensionContent(dimension, snapshot.data!);
          }
          
          return const Center(child: Text('No data available'));
        },
      );
    }
    
    // For other dimensions or when no assessment ID, use provided data
    if (widget.dimensionData != null) {
      return _buildDimensionContent(dimension, widget.dimensionData!);
    }
    
    // Fallback for dimensions without detailed data
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          'This dimension view is coming soon.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textMediumColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionContent(Map<String, dynamic> dimension, DimensionScore dimensionData) {
    return Column(
      children: [
        // Dimension Score Gauge
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: DimensionScoreGauge(
            dimensionName: dimension['name'],
            description: _getDimensionDescription(widget.dimensionId),
            score: dimensionData.score,
          ),
        ),
        
        // Scrollable subsections
        Expanded(
          child: SubSectionList(
            subSections: dimensionData.subSections,
          ),
        ),
      ],
    );
  }

  String _getDimensionDescription(String dimensionId) {
    switch (dimensionId) {
      case 'environmental':
        return 'A safe and accessible home environment supports Ann\'s independence, reduces risk of falls or injury, and helps her feel secure at home as she ages.';
      case 'physical':
        return 'Physical wellness encompasses exercise, nutrition, sleep, and overall health maintenance for optimal well-being.';
      case 'social':
        return 'Social wellness involves building and maintaining meaningful relationships and connections with others.';
      case 'emotional':
        return 'Emotional wellness focuses on understanding and managing emotions, stress, and mental health.';
      case 'intellectual':
        return 'Intellectual wellness involves engaging in creative and stimulating activities that foster learning and growth.';
      case 'occupational':
        return 'Occupational wellness relates to finding fulfillment and satisfaction in work and career pursuits.';
      case 'spiritual':
        return 'Spiritual wellness involves finding meaning, purpose, and connection to something greater than oneself.';
      case 'financial':
        return 'Financial wellness encompasses managing money effectively and working toward financial security and goals.';
      default:
        return 'This dimension contributes to overall wellness and quality of life.';
    }
  }
}

/// Stateful widget to handle subsection expansion state
class SubSectionList extends StatefulWidget {
  final List<SubSection> subSections;

  const SubSectionList({
    super.key,
    required this.subSections,
  });

  @override
  State<SubSectionList> createState() => _SubSectionListState();
}

class _SubSectionListState extends State<SubSectionList> {
  late List<SubSection> subSections;

  @override
  void initState() {
    super.initState();
    subSections = List.from(widget.subSections);
  }

  @override
  void didUpdateWidget(SubSectionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subSections != widget.subSections) {
      subSections = List.from(widget.subSections);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: subSections.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SubSectionCard(
            subSection: subSections[index],
            onToggleExpanded: () {
              setState(() {
                subSections[index] = SubSection(
                  id: subSections[index].id,
                  name: subSections[index].name,
                  issues: subSections[index].issues,
                  isExpanded: !subSections[index].isExpanded,
                );
              });
            },
          ),
        );
      },
    );
  }
}