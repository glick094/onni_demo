import 'package:flutter/material.dart';
import '../models/wellness_data.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/dashboard/dimension_score_gauge.dart';
import '../widgets/dashboard/subsection_card.dart';

class DimensionScreen extends StatefulWidget {
  final String dimensionId;
  final DimensionScore dimensionData;

  const DimensionScreen({
    super.key,
    required this.dimensionId,
    required this.dimensionData,
  });

  @override
  State<DimensionScreen> createState() => _DimensionScreenState();
}

class _DimensionScreenState extends State<DimensionScreen> {
  late List<SubSection> subSections;

  @override
  void initState() {
    super.initState();
    subSections = List.from(widget.dimensionData.subSections);
  }

  @override
  Widget build(BuildContext context) {
    // Find dimension info from constants
    final dimension = AppConstants.dimensions.firstWhere(
      (d) => d['id'] == widget.dimensionId,
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Dimension Score Gauge
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: DimensionScoreGauge(
              dimensionName: dimension['name'],
              description: _getDimensionDescription(widget.dimensionId),
              score: widget.dimensionData.score,
            ),
          ),
          
          // Scrollable subsections
          Expanded(
            child: ListView.builder(
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
            ),
          ),
        ],
      ),
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