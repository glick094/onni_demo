import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class DimensionScoreGauge extends StatelessWidget {
  final String dimensionName;
  final String description;
  final double score; // Score from 0.0 to 1.0

  const DimensionScoreGauge({
    super.key,
    required this.dimensionName,
    required this.description,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          // color: Colors.black.withOpacity(0.1),
          color: Colors.black,
          width: 0.7,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     spreadRadius: 1,
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dimensionName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textMediumColor,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Gauge itself
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Stack(
                children: [
                  // Background gradient
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.redColor,
                          AppTheme.orangeColor,
                          AppTheme.yellowColor,
                          AppTheme.greenLightColor,
                          AppTheme.greenColor,
                        ],
                      ),
                    ),
                  ),
                  
                  // Pointer triangle
                  Positioned(
                    left: score * width - 8, // Position based on score
                    top: -6,
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ],
              );
            }
          ),
          
          const SizedBox(height: 20),
          
          // Score labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ScoreLabel(
                color: AppTheme.redColor,
                text: 'HIGH PRIORITY',
                isActive: score < 0.33,
              ),
              _ScoreLabel(
                color: AppTheme.yellowColor,
                text: 'NEEDS ATTENTION',
                isActive: score >= 0.33 && score < 0.66,
              ),
              _ScoreLabel(
                color: AppTheme.greenColor,
                text: 'PASSED',
                isActive: score >= 0.66,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreLabel extends StatelessWidget {
  final Color color;
  final String text;
  final bool isActive;

  const _ScoreLabel({
    required this.color,
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
          child: isActive
              ? const Icon(
                  // Icons.change_history_rounded,
                  Icons.notifications,
                  // Icons.check, //red !, yellow -, green check
                  color: Colors.white,
                  size: 12,
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
            color: isActive ? AppTheme.textDarkColor : AppTheme.textLightColor,
          ),
        ),
      ],
    );
  }
}