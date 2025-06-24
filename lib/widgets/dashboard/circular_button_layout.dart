import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_arc_text/flutter_arc_text.dart';
import '../../models/wellness_data.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class CircularButtonLayout extends StatefulWidget {
  final WellnessData wellnessData;
  final Function(String) onDimensionSelected;

  const CircularButtonLayout({
    super.key,
    required this.wellnessData,
    required this.onDimensionSelected,
  });

  @override
  State<CircularButtonLayout> createState() => _CircularButtonLayoutState();
}

class _CircularButtonLayoutState extends State<CircularButtonLayout> {
  int? hoveredIndex;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final isNarrowScreen = screenSize.width < 600;

    // Calculate the available space (accounting for padding and nav bar)
    final availableWidth = isNarrowScreen
        ? screenSize.width * 0.9 // 90% of screen width on mobile
        : screenSize.width - 220; // Account for sidebar on desktop

    final availableHeight = isNarrowScreen
        ? screenSize.height * 0.6 // 60% of screen height on mobile
        : screenSize.height * 0.7; // 70% of screen height on desktop

    // Use the smaller dimension to ensure the circle fits completely
    final chartSize = math.min(availableWidth, availableHeight);

    return SizedBox(
      width: chartSize,
      height: chartSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Colored wedges - always visible with different opacity
          ...List.generate(AppConstants.dimensions.length, (index) {
            final dimension = AppConstants.dimensions[index];
            final dimensionId = dimension['id'];

            // Get the wedge angle from constants (or calculate based on index if not provided)
            final double wedgeAngle = dimension.containsKey('angle')
                ? dimension['angle']
                : (index * (360 / AppConstants.dimensions.length));

            // Convert to radians for the painter - adjust by -90 degrees to start from top
            final double wedgeAngleRadians =
                (wedgeAngle - 90) * (math.pi / 180);
            // Convert to radians for the painter - NO adjustment needed
            // final double wedgeAngleRadians = wedgeAngle * (math.pi / 180);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onDimensionSelected(dimensionId);
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: CustomPaint(
                  size: Size(chartSize, chartSize),
                  painter: WedgePainter(
                    color: dimension['color'],
                    index: index,
                    totalSegments: AppConstants.dimensions.length,
                    isHighlighted:
                        index == hoveredIndex || index == selectedIndex,
                    baseAngle: wedgeAngleRadians,
                  ),
                ),
              ),
            );
          }),

          // White overlay wedges with transparency to reveal color on edges
          ...List.generate(AppConstants.dimensions.length, (index) {
            final dimension = AppConstants.dimensions[index];

            // Get the wedge angle from constants (or calculate based on index if not provided)
            final double wedgeAngle = dimension.containsKey('angle')
                ? dimension['angle']
                : (index * (360 / AppConstants.dimensions.length));

            // Convert to radians for the painter - adjust by -90 degrees to start from top
            final double wedgeAngleRadians =
                (wedgeAngle - 90) * (math.pi / 180);

            return CustomPaint(
              size: Size(chartSize, chartSize),
              painter: OverlayWedgePainter(
                index: index,
                totalSegments: AppConstants.dimensions.length,
                isHighlighted: index == hoveredIndex,
                isSelected: index == selectedIndex,
                baseAngle: wedgeAngleRadians,
              ),
            );
          }),

          // Center circle with title
          Container(
            width: chartSize * 0.25, // Center circle size
            height: chartSize * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     blurRadius: 0,
              //     spreadRadius: 1,
              //   ),
              // ],
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // 'Onni in 8 Dimensions',
                    '',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Arc text labels positioned on the wheel properly
          ...List.generate(AppConstants.dimensions.length, (index) {
            // Get dimension data
            final dimension = AppConstants.dimensions[index];
            final String dimensionName = dimension['name'];
            final bool isSelected = selectedIndex == index;

            // Get the text angle directly from the dimension map, or use the textAngle if specified
            // final double textAngleRadians = dimension.containsKey('textAngle')
            //     ? dimension['textAngle']
            //     : (index * (2 * math.pi / AppConstants.dimensions.length));

            final double textAngleRadians = dimension['textAngle'] ?? 0.0;

            // Convert radians to degrees for easier calculation
            double textAngleDegrees = textAngleRadians * (180 / math.pi);
            
            // Normalize angle to 0-360 range
            // while (textAngleDegrees < 0) {
            //   textAngleDegrees += 360;
            // }
            // while (textAngleDegrees >= 360) {
            //   textAngleDegrees -= 360;
            // }

            // Determine text placement based on position around the circle
            double displayAngle = textAngleDegrees;
            Direction textDirection;
            Placement textPlacement;
            
            // Adjust placement based on specific dimensions and their positions
            if (dimension['id'] == 'social') {
              // Social: place inside, counterclockwise to read correctly
              textPlacement = Placement.inside;
              textDirection = Direction.counterClockwise;
            } else if (dimension['id'] == 'emotional') {
              // Emotional: place inside, counterclockwise
              textPlacement = Placement.inside;
              textDirection = Direction.counterClockwise;
            } else if (dimension['id'] == 'intellectual') {
              // Intellectual: place inside, counterclockwise
              textPlacement = Placement.inside;
              textDirection = Direction.counterClockwise;
            } else if (dimension['id'] == 'occupational') {
              // Occupational: place inside, counterclockwise
              textPlacement = Placement.inside;
              textDirection = Direction.counterClockwise;
            } else if (dimension['id'] == 'spiritual') {
              // Spiritual: place inside, clockwise (this was upside down)
              textPlacement = Placement.inside;
              textDirection = Direction.clockwise;
            } else {
              // Physical, Environmental, Financial: place inside, clockwise
              textPlacement = Placement.inside;
              textDirection = Direction.clockwise;
            }


            // Adjust the radius based on the dimensions to avoid overlaps
            double textRadius;
            if (dimensionName.length > 11) { 
              // For longer names like ENVIRONMENTAL, INTELLECTUAL
              textRadius = chartSize * 0.44; // Push these out a bit more
            } else if (dimensionName.length < 7) { 
              // For shorter names like SOCIAL
              textRadius = chartSize * 0.42; // Pull these in a bit
            } else {
              textRadius = chartSize * 0.43; // Default
            }

            // // Calculate center position for each ArcText widget
            // final double centerX = chartSize / 2;
            // final double centerY = chartSize / 2;

            // // For short text arc length (for centering)
            // final double arcLength = dimensionName.length * 10;
            // final double arcAngle = (arcLength / textRadius) * (180 / math.pi);

            return ArcText(
              radius: textRadius,
              text: dimensionName,
              textStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
              startAngle: displayAngle,
              startAngleAlignment: StartAngleAlignment.center,
              placement: textPlacement,
              direction: textDirection,
            );
            // return Positioned(
            //   left: centerX - textRadius,
            //   top: centerY - textRadius,
            //   child: SizedBox(
            //     width: textRadius * 2,
            //     height: textRadius * 2,
            //     child: ArcText(
            //       radius: textRadius,
            //       text: dimensionName,
            //       textStyle: TextStyle(
            //         color: isSelected ? Colors.white : AppTheme.primaryColor,
            //         fontSize: 14,
            //         fontWeight: FontWeight.bold,
            //         letterSpacing: 0.8,
            //       ),
            //       startAngle: textAngle, // Use the exact angle from constants
            //       startAngleAlignment: StartAngleAlignment.center,
            //       placement: Placement.inside,
            //     ),
            //   ),
            // );
          }),

          // Circle buttons - positioned closer to inner radius
          ...List.generate(AppConstants.dimensions.length, (index) {
            final dimension = AppConstants.dimensions[index];
            final dimensionId = dimension['id'];
            final bool isHovered = hoveredIndex == index;
            final bool isSelected = selectedIndex == index;

            // Get the button angle from the dimension map, same as wedge angle
            final double buttonAngle = dimension.containsKey('angle')
                ? dimension['angle']
                : (index * (360 / AppConstants.dimensions.length));

            // Convert to radians for calculating position - adjust by -90 degrees
            final double buttonAngleRadians =
                (buttonAngle - 90) * (math.pi / 180);

            // Position buttons closer to inner radius
            final double buttonRadius = chartSize * 0.3; // Closer to center

            // Calculate position
            final double x = buttonRadius * math.cos(buttonAngleRadians);
            final double y = buttonRadius * math.sin(buttonAngleRadians);

            // Size of button
            final double buttonSize = chartSize * 0.1;

            return Positioned(
              left: (chartSize / 2) + x - (buttonSize / 2),
              top: (chartSize / 2) + y - (buttonSize / 2),
              child: MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onDimensionSelected(dimensionId);
                  },
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      // color: isSelected ? dimension['color'] :
                      //        isHovered ? dimension['color'].withOpacity(0.7) : Colors.white,
                      color: isSelected
                          ? dimension['color'].withOpacity(0.5)
                          : isHovered
                              ? dimension['color'].withOpacity(0.7)
                              : AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 3,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        dimension['icon'],
                        // color: (isHovered || isSelected) ? Colors.white : AppTheme.primaryColor,
                        color: Colors.white,
                        // color: (isHovered || isSelected) ? AppTheme.primaryColor : Colors.white,
                        size: buttonSize * 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class WedgePainter extends CustomPainter {
  final Color color;
  final int index;
  final int totalSegments;
  final bool isHighlighted;
  final double baseAngle;

  WedgePainter({
    required this.color,
    required this.index,
    required this.totalSegments,
    required this.isHighlighted,
    this.baseAngle = -math.pi / 2, // Default to 12 o'clock position
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.48; // Slightly smaller than full radius
    final innerRadius = size.width * 0.17; // Center circle size

    // Paint for the wedge - always show the colored rim with the same opacity
    final paint = Paint()
      ..color = color.withOpacity(0.7) // Consistent darker opacity for the rim
      ..style = PaintingStyle.fill;

    // Border paint for the wedge - use the same color as the wedge
    final borderPaint = Paint()
      ..color =
          color.withOpacity(0.8) // Slightly darker border in the wedge color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.0025; // Thin border for subtle separation

    // Calculate angles for each wedge
    final fullSectorAngle = 2 * math.pi / totalSegments;

    // Increase spacing between wedges
    final gapWidth = size.width * 0.025; // Wider gap (2.5% of chart size)

    // Calculate actual angles based on radius and gap width
    final gapAngle =
        2 * math.asin(gapWidth / (2 * outerRadius)); // Convert width to angle
    final sectorAngle = fullSectorAngle - gapAngle;

    // Use the provided baseAngle instead of calculating
    final startAngle = baseAngle - (sectorAngle / 2) + (gapAngle / 2);
    final endAngle = startAngle + sectorAngle;

    // Create a wedge shape that matches the reference design
    final path = Path();

    // Calculate the midpoint angle for the wedge
    final midAngle = startAngle + sectorAngle / 2;

    // Calculate points for the outer arc
    final outerStartX = center.dx + outerRadius * math.cos(startAngle);
    final outerStartY = center.dy + outerRadius * math.sin(startAngle);

    // Start drawing the path from the outer start point
    path.moveTo(outerStartX, outerStartY);

    // Draw the outer arc
    path.arcTo(Rect.fromCircle(center: center, radius: outerRadius), startAngle,
        sectorAngle, false);

    // More distance from center circle for inner corners (5% of chart size)
    final cornerOffset = size.width * 0.05;
    final approachInnerRadius = innerRadius + cornerOffset;

    // Calculate the inner corner points (farther from center)
    final innerEndX = center.dx + approachInnerRadius * math.cos(endAngle);
    final innerEndY = center.dy + approachInnerRadius * math.sin(endAngle);

    final innerStartX = center.dx + approachInnerRadius * math.cos(startAngle);
    final innerStartY = center.dy + approachInnerRadius * math.sin(startAngle);

    // Calculate control points for the more rounded inner corners
    // Control point is closer to center to create more dramatic curve
    final controlPointRadius =
        innerRadius * 0.7; // More inside for rounder curve
    final controlX = center.dx + controlPointRadius * math.cos(midAngle);
    final controlY = center.dy + controlPointRadius * math.sin(midAngle);

    // Line to inner corner at end angle
    path.lineTo(innerEndX, innerEndY);

    // Create a more rounded curve between inner corners
    path.quadraticBezierTo(controlX, controlY, innerStartX, innerStartY);

    // Line back to the outer start point
    path.lineTo(outerStartX, outerStartY);

    // Close the path
    path.close();

    // Draw the wedge
    canvas.drawPath(path, paint);

    // Draw the colored border
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is WedgePainter) {
      return oldDelegate.isHighlighted != isHighlighted;
    }
    return true;
  }
}

class OverlayWedgePainter extends CustomPainter {
  final int index;
  final int totalSegments;
  final bool isHighlighted;
  final bool isSelected;
  final double baseAngle;

  OverlayWedgePainter({
    required this.index,
    required this.totalSegments,
    required this.isHighlighted,
    required this.isSelected,
    this.baseAngle = -math.pi / 2, // Default to 12 o'clock position
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius =
        size.width * 0.47; // Slightly smaller than the colored wedge
    final innerRadius = size.width * 0.18; // Center circle size

    // Select the right overlay color based on state:
    // - Selected: No overlay (shows full color from base wedge)
    // - Hovered: Light opacity colored overlay (shows lighter color)
    // - Normal: White overlay (shows only the colored rim)
    final paint = Paint()..style = PaintingStyle.fill;

    if (isSelected) {
      // Don't draw any overlay for selected wedges (fully colored)
      return;
    } else if (isHighlighted) {
      // Use a semi-transparent overlay for hover state (lighter color)
      paint.color = Colors.white.withOpacity(0.3);
    } else {
      // Use solid white for normal state, only showing the rim
      paint.color = Colors.white.withOpacity(0.95);
    }

    // Calculate angles for each wedge
    final fullSectorAngle = 2 * math.pi / totalSegments;

    // Increase spacing between wedges
    final gapWidth = size.width * 0.025; // Wider gap (2.5% of chart size)

    // Calculate actual angles based on radius and gap width
    final gapAngle =
        2 * math.asin(gapWidth / (2 * outerRadius)); // Convert width to angle
    final sectorAngle = fullSectorAngle - gapAngle;

    // Use the provided baseAngle instead of calculating
    final startAngle = baseAngle - (sectorAngle / 2) + (gapAngle / 2);
    final endAngle = startAngle + sectorAngle;

    // Create a white overlay wedge that's slightly smaller than the colored wedge
    // to create the colored border effect
    final path = Path();

    // Calculate the midpoint angle for the wedge
    final midAngle = startAngle + sectorAngle / 2;

    // Calculate offset from edge (to create colored rim effect)
    final rimWidth = size.width * 0.015; // Width of colored rim
    final innerOuterRadius = outerRadius - rimWidth;

    // Start at the inner-outer edge (just inside the colored outer edge)
    path.moveTo(center.dx + innerOuterRadius * math.cos(startAngle),
        center.dy + innerOuterRadius * math.sin(startAngle));

    // Draw the inner-outer arc
    path.arcTo(Rect.fromCircle(center: center, radius: innerOuterRadius),
        startAngle, sectorAngle, false);

    // More distance from center circle for inner corners (5% of chart size)
    final cornerOffset = size.width * 0.05;
    final approachInnerRadius = innerRadius + cornerOffset;

    // Calculate the inner corner points (farther from center)
    final innerEndX = center.dx + approachInnerRadius * math.cos(endAngle);
    final innerEndY = center.dy + approachInnerRadius * math.sin(endAngle);

    final innerStartX = center.dx + approachInnerRadius * math.cos(startAngle);
    final innerStartY = center.dy + approachInnerRadius * math.sin(startAngle);

    // Calculate control points for the rounded inner corners
    final controlPointRadius =
        innerRadius * 0.7; // More inside for rounder curve
    final controlX = center.dx + controlPointRadius * math.cos(midAngle);
    final controlY = center.dy + controlPointRadius * math.sin(midAngle);

    // Line to inner corner at end angle
    path.lineTo(innerEndX, innerEndY);

    // Create a more rounded curve between inner corners
    path.quadraticBezierTo(controlX, controlY, innerStartX, innerStartY);

    // Line back to the outer start point
    path.lineTo(center.dx + innerOuterRadius * math.cos(startAngle),
        center.dy + innerOuterRadius * math.sin(startAngle));

    // Close the path
    path.close();

    // Draw the white overlay
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is OverlayWedgePainter) {
      return oldDelegate.isHighlighted != isHighlighted ||
          oldDelegate.isSelected != isSelected;
    }
    return true;
  }
}
