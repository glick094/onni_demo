import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'dart:math' as math;
import '../../utils/theme.dart';

class CircularWedgeButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final double innerRadius;
  final double outerRadius;
  final double wedgePadding; // Padding between wedges
  final bool isSelected;
  final VoidCallback onTap;

  const CircularWedgeButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
    required this.radius,
    this.innerRadius = 10.0,
    this.outerRadius = 200.0,
    // this.wedgePadding = 0.000001, // Default padding in radians
    this.wedgePadding = 0, // Default padding in radians
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Wedge shape with clipping
        ClipPath(
          clipper: WedgeClipper(
            startAngle: startAngle,
            sweepAngle: sweepAngle,
            radius: outerRadius,
            innerRadius: innerRadius,
          ),
          child: Container(
            width: outerRadius * 2,
            height: outerRadius * 2,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.4),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 10,
              ),
            ),
            child: Container(),
          ),
        ),
        // Icon positioned OUTSIDE the clipped area
        _buildIconButton(),
        // Arc text positioned OUTSIDE the clipped area  
        _buildArcText(),
        // InkWell with custom shape for precise hit detection
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: _WedgeShapeBorder(
              startAngle: startAngle,
              sweepAngle: sweepAngle,
              radius: outerRadius,
              innerRadius: innerRadius,
            ),
            child: Container(
              width: outerRadius * 2,
              height: outerRadius * 2,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton() {
    print('Building icon: angle=${startAngle.toStringAsFixed(2)}, hasCallback=${onTap != null}, isSelected=$isSelected');
    
    // Calculate icon position based on ACTUAL clipped wedge center
    final gapWidth = 4.0;
    final outerGap = gapWidth / outerRadius;
    final innerGap = gapWidth / innerRadius;
    
    // Average the gaps to get effective center angle
    final avgGap = (outerGap + innerGap) / 2;
    final adjustedStartAngle = startAngle + avgGap;
    final adjustedSweepAngle = sweepAngle - (avgGap * 2);
    final centerAngle = adjustedStartAngle + (adjustedSweepAngle / 2);
    
    // Position icon closer to the text radius for better visual balance
    final double iconRadius = innerRadius + ((outerRadius - innerRadius) * 0.5);
    
    final double x = outerRadius + (iconRadius * math.cos(centerAngle));
    final double y = outerRadius + (iconRadius * math.sin(centerAngle));

    return Positioned(
      left: x - 32, // Center the icon (64px)
      top: y - 32,
      child: GestureDetector(
        onTap: () {
          print('ICON CLICKED! angle: ${startAngle.toStringAsFixed(2)}, callback: ${onTap.runtimeType}');
          try {
            onTap();
            print('Callback executed successfully');
          } catch (e) {
            print('Error executing callback: $e');
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.yellow.withOpacity(0.7), // Very visible yellow for debugging
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.textDarkColor,
              size: 32,
            ),
          ),
        ),
    );
  }

  Widget _buildArcText() {
    // Calculate center angle based on ACTUAL clipped wedge
    final gapWidth = 4.0;
    final outerGap = gapWidth / outerRadius;
    final innerGap = gapWidth / innerRadius;
    
    // Average the gaps to get effective center angle
    final avgGap = (outerGap + innerGap) / 2;
    final adjustedStartAngle = startAngle + avgGap;
    final adjustedSweepAngle = sweepAngle - (avgGap * 2);
    final centerAngle = adjustedStartAngle + (adjustedSweepAngle / 2);
    
    // Determine if this wedge is on bottom half (angles between π/2 and 3π/2)
    final normalizedAngle = centerAngle % (2 * math.pi);
    final isBottomHalf = normalizedAngle > math.pi / 2 && normalizedAngle < 3 * math.pi / 2;
    
    // Configure text based on position for counterclockwise reading
    double textRadius;
    double textStartAngle;
    Placement textPlacement;
    Direction textDirection;
    
    if (isBottomHalf) {
      // Bottom half: text on inside, counterclockwise direction
      textRadius = innerRadius + ((outerRadius - innerRadius) * 0.725); // Closer to inner
      // textRadius = innerRadius + ((outerRadius - innerRadius) * 0.3); // Closer to inner
      textStartAngle = centerAngle + (text.length * 0.018); // Start from right side
      // textPlacement = Placement.inside;
      textPlacement = Placement.outside;
      textDirection = Direction.counterClockwise;
    } else {
      // Top half: text on outside, counterclockwise direction
      textRadius = innerRadius + ((outerRadius - innerRadius) * 0.725); // Closer to outer
      textStartAngle = centerAngle - (text.length * 0.018); // Start from right side
      textPlacement = Placement.outside;
      textDirection = Direction.clockwise;
    }
    
    return SizedBox(
      width: outerRadius * 2,
      height: outerRadius * 2,
      child: ArcText(
        radius: textRadius,
        text: text,
        textStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.black,
          letterSpacing: 0.5,
        ),
        startAngle: textStartAngle,
        startAngleAlignment: StartAngleAlignment.start,
        placement: textPlacement,
        direction: textDirection,
      ),
    );
  }
}

class WedgeClipper extends CustomClipper<Path> {
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final double innerRadius;

  WedgeClipper({
    required this.startAngle,
    required this.sweepAngle,
    required this.radius,
    required this.innerRadius,
  });

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();
    
    // Create gaps that are proportional to achieve more parallel appearance
    final gapWidth = 4.0;
    final outerGap = gapWidth / radius;
    final innerGap = gapWidth / innerRadius;
    
    // Start from outer radius with gap
    final outerStartAngle = startAngle + outerGap;
    final outerEndAngle = startAngle + sweepAngle - outerGap;
    
    // Start from inner radius with gap  
    final innerStartAngle = startAngle + innerGap;
    final innerEndAngle = startAngle + sweepAngle - innerGap;
    
    // Outer arc
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      outerStartAngle,
      outerEndAngle - outerStartAngle,
      false,
    );
    
    // Connect to inner arc end
    final innerEndX = center.dx + innerRadius * math.cos(innerEndAngle);
    final innerEndY = center.dy + innerRadius * math.sin(innerEndAngle);
    path.lineTo(innerEndX, innerEndY);
    
    // Inner arc (reverse direction)
    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      innerEndAngle,
      -(innerEndAngle - innerStartAngle),
      false,
    );
    
    // Connect back to outer arc start
    final outerStartX = center.dx + radius * math.cos(outerStartAngle);
    final outerStartY = center.dy + radius * math.sin(outerStartAngle);
    path.lineTo(outerStartX, outerStartY);
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}

class _CircularWedgeVisual extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final double innerRadius;
  final double outerRadius;
  final bool isSelected;
  final VoidCallback onTap;

  const _CircularWedgeVisual({
    required this.text,
    required this.icon,
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
    required this.radius,
    this.innerRadius = 10.0,
    this.outerRadius = 200.0,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Wedge shape with clipping
        ClipPath(
          clipper: WedgeClipper(
            startAngle: startAngle,
            sweepAngle: sweepAngle,
            radius: outerRadius,
            innerRadius: innerRadius,
          ),
          child: Container(
            width: outerRadius * 2,
            height: outerRadius * 2,
            decoration: BoxDecoration(
              // color: isSelected ? color : color.withOpacity(0.4),
              color: isSelected ? color : AppTheme.sidebarColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 80,
              ),
            ),
            child: Container(),
          ),
        ),
        // Arc text positioned OUTSIDE the clipped area  
        _buildArcText(),
        // Icon positioned OUTSIDE the clipped area - ON TOP for clicking
        _buildSimpleIcon(),
      ],
    );
  }

  Widget _buildIcon() {
    // Calculate icon position based on ACTUAL clipped wedge center
    final gapWidth = 4.0;
    final outerGap = gapWidth / outerRadius;
    final innerGap = gapWidth / innerRadius;
    
    // Average the gaps to get effective center angle
    final avgGap = (outerGap + innerGap) / 2;
    final adjustedStartAngle = startAngle + avgGap;
    final adjustedSweepAngle = sweepAngle - (avgGap * 2);
    final centerAngle = adjustedStartAngle + (adjustedSweepAngle / 2);
    
    // Position icon closer to the text radius for better visual balance
    final double iconRadius = innerRadius + ((outerRadius - innerRadius) * 0.5);
    
    final double x = outerRadius + (iconRadius * math.cos(centerAngle));
    final double y = outerRadius + (iconRadius * math.sin(centerAngle));

    return Positioned(
      left: x - 12, // Center the icon (assuming 24px icon)
      top: y - 12,
      child: Icon(
        icon,
        color: isSelected ? Colors.white : AppTheme.textDarkColor,
        size: 24,
      ),
    );
  }

  Widget _buildArcText() {
    // Calculate center angle based on ACTUAL clipped wedge
    final gapWidth = 4.0;
    final outerGap = gapWidth / outerRadius;
    final innerGap = gapWidth / innerRadius;
    
    // Average the gaps to get effective center angle
    final avgGap = (outerGap + innerGap) / 2;
    final adjustedStartAngle = startAngle + avgGap;
    final adjustedSweepAngle = sweepAngle - (avgGap * 2);
    final centerAngle = adjustedStartAngle + (adjustedSweepAngle / 2);
    
    // Determine if this wedge is on bottom half (angles between π/2 and 3π/2)
    final normalizedAngle = centerAngle % (2 * math.pi);
    final isBottomHalf = normalizedAngle > math.pi / 2 && normalizedAngle < 3 * math.pi / 2;
    
    // Configure text based on position for counterclockwise reading
    double textRadius;
    double textStartAngle;
    Placement textPlacement;
    Direction textDirection;
    
    if (isBottomHalf) {
      // Bottom half: text on inside, counterclockwise direction
      textRadius = innerRadius + ((outerRadius - innerRadius) * 0.725); // Closer to inner
      textStartAngle = centerAngle + (text.length * 0.018); // Start from right side
      textPlacement = Placement.outside;
      textDirection = Direction.counterClockwise;
    } else {
      // Top half: text on outside, counterclockwise direction
      textRadius = innerRadius + ((outerRadius - innerRadius) * 0.725); // Closer to outer
      textStartAngle = centerAngle - (text.length * 0.018); // Start from right side
      textPlacement = Placement.outside;
      textDirection = Direction.clockwise;
    }
    
    return SizedBox(
      width: outerRadius * 2,
      height: outerRadius * 2,
      child: ArcText(
        radius: textRadius,
        text: text,
        textStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.black,
          letterSpacing: 0.5,
        ),
        startAngle: textStartAngle,
        startAngleAlignment: StartAngleAlignment.start,
        placement: textPlacement,
        direction: textDirection,
      ),
    );
  }

  Widget _buildIconButton() {
    print('Building icon: angle=${startAngle.toStringAsFixed(2)}, hasCallback=${onTap != null}, isSelected=$isSelected');
    
    // Calculate icon position based on ACTUAL clipped wedge center
    final gapWidth = 4.0;
    final outerGap = gapWidth / outerRadius;
    final innerGap = gapWidth / innerRadius;
    
    // Average the gaps to get effective center angle
    final avgGap = (outerGap + innerGap) / 2;
    final adjustedStartAngle = startAngle + avgGap;
    final adjustedSweepAngle = sweepAngle - (avgGap * 2);
    final centerAngle = adjustedStartAngle + (adjustedSweepAngle / 2);
    
    // Position icon closer to the text radius for better visual balance
    final double iconRadius = innerRadius + ((outerRadius - innerRadius) * 0.5);
    
    final double x = outerRadius + (iconRadius * math.cos(centerAngle));
    final double y = outerRadius + (iconRadius * math.sin(centerAngle));

    return Positioned(
      left: x - 32, // Center the icon (64px)
      top: y - 32,
      child: GestureDetector(
        onTap: () {
          print('ICON CLICKED! angle: ${startAngle.toStringAsFixed(2)}, callback: ${onTap.runtimeType}');
          try {
            onTap();
            print('Callback executed successfully');
          } catch (e) {
            print('Error executing callback: $e');
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.yellow.withOpacity(0.7), // Very visible yellow for debugging
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.textDarkColor,
              size: 32,
            ),
          ),
        ),
    );
  }

  Widget _buildSimpleIcon() {
    // Calculate icon position
    final gapWidth = 4.0;
    final outerGap = gapWidth / outerRadius;
    final innerGap = gapWidth / innerRadius;
    final avgGap = (outerGap + innerGap) / 2;
    final adjustedStartAngle = startAngle + avgGap;
    final adjustedSweepAngle = sweepAngle - (avgGap * 2);
    final centerAngle = adjustedStartAngle + (adjustedSweepAngle / 2);
    final double iconRadius = innerRadius + ((outerRadius - innerRadius) * 0.5);
    final double x = outerRadius + (iconRadius * math.cos(centerAngle));
    final double y = outerRadius + (iconRadius * math.sin(centerAngle));

    return Positioned(
      left: x - 32,
      top: y - 32,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.yellow.withOpacity(0.7),
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : AppTheme.textDarkColor,
          size: 32,
        ),
      ),
    );
  }
}

class _WedgeShapeBorder extends ShapeBorder {
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final double innerRadius;

  const _WedgeShapeBorder({
    required this.startAngle,
    required this.sweepAngle,
    required this.radius,
    required this.innerRadius,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final center = rect.center;
    final path = Path();
    
    // Create gaps that are proportional to achieve more parallel appearance
    final gapWidth = 4.0;
    final outerGap = gapWidth / radius;
    final innerGap = gapWidth / innerRadius;
    
    // Start from outer radius with gap
    final outerStartAngle = startAngle + outerGap;
    final outerEndAngle = startAngle + sweepAngle - outerGap;
    
    // Start from inner radius with gap  
    final innerStartAngle = startAngle + innerGap;
    final innerEndAngle = startAngle + sweepAngle - innerGap;
    
    // Outer arc
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      outerStartAngle,
      outerEndAngle - outerStartAngle,
      false,
    );
    
    // Connect to inner arc end
    final innerEndX = center.dx + innerRadius * math.cos(innerEndAngle);
    final innerEndY = center.dy + innerRadius * math.sin(innerEndAngle);
    path.lineTo(innerEndX, innerEndY);
    
    // Inner arc (reverse direction)
    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      innerEndAngle,
      -(innerEndAngle - innerStartAngle),
      false,
    );
    
    // Connect back to outer arc start
    final outerStartX = center.dx + radius * math.cos(outerStartAngle);
    final outerStartY = center.dy + radius * math.sin(outerStartAngle);
    path.lineTo(outerStartX, outerStartY);
    
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // No painting needed for hit testing
  }

  @override
  ShapeBorder scale(double t) {
    return _WedgeShapeBorder(
      startAngle: startAngle,
      sweepAngle: sweepAngle,
      radius: radius * t,
      innerRadius: innerRadius * t,
    );
  }
}

// Test widget to demonstrate the circular layout
class CircularWedgeLayoutTest extends StatefulWidget {
  const CircularWedgeLayoutTest({super.key});

  @override
  State<CircularWedgeLayoutTest> createState() => _CircularWedgeLayoutTestState();
}

class _CircularWedgeLayoutTestState extends State<CircularWedgeLayoutTest> {
  int selectedIndex = -1;
  
  // Define radius values for the test
  final double innerRadius = 60.0;
  final double outerRadius = 200.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Circular Wedge Test')),
      body: Center(
        child: SizedBox(
          width: outerRadius * 2,
          height: outerRadius * 2,
          child: Stack(
            children: [
              // Background circle (removed grey border)
              SizedBox(
                width: outerRadius * 2,
                height: outerRadius * 2,
              ),
              
              // Wedge visuals (without gesture detection) 
              // Reorder wedges to match the coordinate system where wedge 0 is at the top
              ...List.generate(8, (visualIndex) {
                // Map visual position to coordinate wedge index
                // We want: top=0, top-right=1, right=2, bottom-right=3, bottom=4, bottom-left=5, left=6, top-left=7
                final wedgeOrder = [4, 5, 6, 7, 0, 1, 2, 3]; // Rearrange to match coordinate system
                final int coordinateIndex = wedgeOrder[visualIndex];
                final double startAngle = (coordinateIndex * 2 * math.pi / 8) - (math.pi / 2);
                final double sweepAngle = 2 * math.pi / 8;
                
                // For debugging: let's temporarily show both wedge index and dimension
                // This will help us understand the mapping
                String getDebugText(int coordinateIndex, int visualIndex) {
                  // Show both the coordinate index and visual position
                  final isThisSelected = selectedIndex == coordinateIndex;
                  final selected = isThisSelected ? " SEL" : "";
                  // Debug print to see which wedges think they're selected
                  if (isThisSelected) {
                    print('Coordinate wedge $coordinateIndex thinks it is selected (selectedIndex=$selectedIndex)');
                  }
                  return 'V$visualIndex:C$coordinateIndex$selected';
                }
                
                return Positioned(
                  left: 0,
                  top: 0,
                  child: _CircularWedgeVisual(
                    text: getDebugText(coordinateIndex, visualIndex),
                    icon: Icons.circle_notifications,
                    color: Colors.primaries[visualIndex % Colors.primaries.length],
                    startAngle: startAngle,
                    sweepAngle: sweepAngle,
                    radius: outerRadius,
                    innerRadius: innerRadius,
                    outerRadius: outerRadius,
                    isSelected: selectedIndex == coordinateIndex,
                    onTap: () {
                      setState(() {
                        selectedIndex = selectedIndex == coordinateIndex ? -1 : coordinateIndex;
                      });
                    },
                  ),
                );
              }),
              
              // Single gesture detector for all icon areas
              GestureDetector(
                onTapDown: (details) {
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final localOffset = renderBox.globalToLocal(details.globalPosition);
                  
                  // Check if tap is on any of the 8 icon areas
                  for (int i = 0; i < 8; i++) {
                    final wedgeOrder = [4, 5, 6, 7, 0, 1, 2, 3];
                    final int coordinateIndex = wedgeOrder[i];
                    final double startAngle = (coordinateIndex * 2 * math.pi / 8) - (math.pi / 2);
                    final double sweepAngle = 2 * math.pi / 8;
                    
                    // Calculate icon position for this wedge
                    final gapWidth = 4.0;
                    final outerGap = gapWidth / outerRadius;
                    final innerGap = gapWidth / innerRadius;
                    final avgGap = (outerGap + innerGap) / 2;
                    final adjustedStartAngle = startAngle + avgGap;
                    final adjustedSweepAngle = sweepAngle - (avgGap * 2);
                    final centerAngle = adjustedStartAngle + (adjustedSweepAngle / 2);
                    final double iconRadius = innerRadius + ((outerRadius - innerRadius) * 0.5);
                    final double iconX = outerRadius + (iconRadius * math.cos(centerAngle));
                    final double iconY = outerRadius + (iconRadius * math.sin(centerAngle));
                    
                    // Check if tap is within this icon's area (64x64 around the icon center)
                    if (localOffset.dx >= iconX - 32 && localOffset.dx <= iconX + 32 &&
                        localOffset.dy >= iconY - 32 && localOffset.dy <= iconY + 32) {
                      print('ICON AREA CLICKED! coordinateIndex: $coordinateIndex');
                      setState(() {
                        selectedIndex = selectedIndex == coordinateIndex ? -1 : coordinateIndex;
                      });
                      return; // Exit after first match
                    }
                  }
                },
                child: Container(
                  width: outerRadius * 2,
                  height: outerRadius * 2,
                  color: Colors.transparent,
                ),
              ),

              // // Center hub
              // Positioned(
              //   left: outerRadius - (innerRadius / 2),
              //   top: outerRadius - (innerRadius / 2),
              //   child: Container(
              //     width: innerRadius,
              //     height: innerRadius,
              //     decoration: const BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: AppTheme.primaryColor,
              //     ),
              //     child: const Center(
              //       child: Text(
              //         'ONNI\nin 8',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 14,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}