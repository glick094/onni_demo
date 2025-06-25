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
    // Calculate responsive font sizes based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = _calculateTitleFontSize(screenWidth);
    final double descriptionFontSize = _calculateDescriptionFontSize(screenWidth);
    
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
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            description,
            style: TextStyle(
              fontSize: descriptionFontSize,
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
                    top: -18, //-6,
                    // child: const Icon(
                    //   Icons.arrow_drop_down,
                    //   color: Colors.black,
                    //   size: 32,
                    // ),
                    child: const Text(
                      "|",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                      ),
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

  /// Calculate responsive title font size based on screen width
  double _calculateTitleFontSize(double screenWidth) {
    if (screenWidth > 1600) {
      return 24.0; // Extra large desktop
    } else if (screenWidth > 1400) {
      return 22.0; // Large desktop
    } else if (screenWidth > 1000) {
      return 18.0; // Medium desktop
    } else if (screenWidth > 700) {
      return 16.0; // Small desktop/large tablet
    } else {
      return 15.0; // Mobile/small tablet
    }
  }

  /// Calculate responsive description font size based on screen width
  double _calculateDescriptionFontSize(double screenWidth) {
    if (screenWidth > 1600) {
      return 16.0; // Extra large desktop
    } else if (screenWidth > 1400) {
      return 15.0; // Large desktop
    } else if (screenWidth > 1000) {
      return 14.0; // Medium desktop
    } else if (screenWidth > 700) {
      return 13.0; // Small desktop/large tablet
    } else {
      return 12.0; // Mobile/small tablet
    }
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
              ? Icon(
                  _getIconForLabel(text),
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

  /// Get the appropriate icon based on the label text
  IconData _getIconForLabel(String labelText) {
    switch (labelText) {
      case 'HIGH PRIORITY':
        return Icons.priority_high; // Red exclamation (!)
      case 'NEEDS ATTENTION':
        // return Icons.remove; // Yellow minus (-)
        return Icons.notifications; // Yellow bell
      case 'PASSED':
        return Icons.check; // Green check (✓)
      default:
        return Icons.circle; // Fallback
    }
  }
}