import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onni_homes_dashboard/services/assessment_data_service.dart';
import 'package:onni_homes_dashboard/models/wellness_data.dart';

void main() {
  group('AssessmentDataService', () {
    late AssessmentDataService service;

    setUp(() {
      service = AssessmentDataService();
    });

    testWidgets('loads environmental assessment data for assessment ID 000001', (WidgetTester tester) async {
      // Build widget to initialize services
      await tester.pumpWidget(Container());

      try {
        final dimensionScore = await service.getEnvironmentalDimensionScore('000001');
        
        // Verify basic structure
        expect(dimensionScore.dimensionId, equals('environmental'));
        expect(dimensionScore.score, greaterThanOrEqualTo(0.0));
        expect(dimensionScore.score, lessThanOrEqualTo(1.0));
        expect(dimensionScore.subSections.isNotEmpty, true);
        
        // Verify we have expected assessment areas
        final areaNames = dimensionScore.subSections.map((s) => s.name).toSet();
        expect(areaNames.contains('BATHROOM'), true);
        expect(areaNames.contains('EXTERIOR'), true);
        
        // Verify issues have proper structure
        final allIssues = dimensionScore.subSections
            .expand((section) => section.issues)
            .toList();
        expect(allIssues.isNotEmpty, true);
        
        // Check that issues have required fields
        for (final issue in allIssues) {
          expect(issue.id.isNotEmpty, true);
          expect(issue.title.isNotEmpty, true);
          expect(issue.description.isNotEmpty, true);
        }
        
        print('✓ Successfully loaded ${dimensionScore.subSections.length} subsections');
        print('✓ Total issues: ${allIssues.length}');
        print('✓ Calculated score: ${dimensionScore.score}');
        
      } catch (e) {
        fail('Failed to load assessment data: $e');
      }
    });

    testWidgets('handles missing assessment ID gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(Container());

      expect(
        () async => await service.getEnvironmentalDimensionScore('999999'),
        throwsException,
      );
    });

    testWidgets('can get available assessment IDs', (WidgetTester tester) async {
      await tester.pumpWidget(Container());

      try {
        final assessmentIds = await service.getAvailableAssessmentIds();
        expect(assessmentIds.contains('000001'), true);
        print('✓ Available assessment IDs: $assessmentIds');
      } catch (e) {
        fail('Failed to get assessment IDs: $e');
      }
    });
  });
}