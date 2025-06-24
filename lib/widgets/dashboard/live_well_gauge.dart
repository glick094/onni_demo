import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class LiveWellGauge extends StatelessWidget {
  final double score; // Score from 0.0 to 1.0

  const LiveWellGauge({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIVE WELL SCORE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          // Gauge itself
          LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Background gradient
                Stack(
                  children: [
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
                    Positioned(
                      left: score * width - 16, // Position based on score
                      top: -18,
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
                ),

                // Pointer triangle
                // Positioned(
                //   left: score * width - 5, // Position based on score
                //   top: -20,
                //   width: width, 
                //   child: const Icon(
                //       // Icons.arrow_drop_down,
                //       // Icons.arrow_downward,
                //       Icons.arrow_drop_up,
                //       color: Colors.black,
                //       size: 40,
                //     ),
                // ),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Score labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: AppConstants.scoreLabels.map((label) {
              // Determine if this label is active based on score
              final isActive = score < label['threshold'] &&
                  (AppConstants.scoreLabels.indexOf(label) == 0 ||
                      score >=
                          AppConstants.scoreLabels[
                                  AppConstants.scoreLabels.indexOf(label) - 1]
                              ['threshold']);

              return _ScoreLabel(
                color: label['color'],
                text: label['text'],
                isActive: isActive,
              );
            }).toList(),
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
