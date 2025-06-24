import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'dart:math' as math;
import '../../utils/svg_utils.dart';
import '../../utils/constants.dart';
import '../../models/wellness_data.dart';
import '../../utils/theme.dart';

class CircularWedgeLayout extends StatefulWidget {
  final WellnessData wellnessData;
  final Function(String) onDimensionSelected;

  const CircularWedgeLayout({
    super.key,
    required this.wellnessData,
    required this.onDimensionSelected,
  });

  @override
  State<CircularWedgeLayout> createState() => _CircularWedgeLayoutState();
}

class _CircularWedgeLayoutState extends State<CircularWedgeLayout> {
  String? selectedDimensionId;
  
  // Define radius values for the layout
  final double innerRadius = 60.0;
  final double outerRadius = 200.0;

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
    
    // Scale the radii based on chart size
    final scaleFactor = chartSize / (outerRadius * 2);
    final scaledInnerRadius = innerRadius * scaleFactor;
    final scaledOuterRadius = outerRadius * scaleFactor;

    return SizedBox(
      width: chartSize,
      height: chartSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Calculate angles once and use for all layers
          ...(() {
            // Pre-calculate all angles to ensure consistency
            final int totalWedges = AppConstants.dimensions.length;
            final double sweepAngle = 2 * math.pi / totalWedges;
            
            final List<Widget> allLayers = [];
            
            // Generate all wedges, text, and icons using the same angle calculations
            for (int index = 0; index < AppConstants.dimensions.length; index++) {
              final dimension = AppConstants.dimensions[index];
              final dimensionId = dimension['id'];
              final bool isSelected = selectedDimensionId == dimensionId;
              
              // SINGLE angle calculation used by all three elements - start from right (0°)
              final double centerAngle = (index * sweepAngle) % (2 * math.pi); // Start from 0° (right), go counterclockwise
              final double startAngle = centerAngle - (sweepAngle / 2);
              final double angleDegrees = centerAngle * (180 / math.pi);
              
              // Layer 1: Wedge shape
              allLayers.add(
                Positioned(
                  left: 0,
                  top: 0,
                  child: ClipPath(
                    clipper: WedgeClipper(
                      startAngle: startAngle,
                      sweepAngle: sweepAngle,
                      radius: scaledOuterRadius,
                      innerRadius: scaledInnerRadius,
                    ),
                    child: Container(
                      width: scaledOuterRadius * 2,
                      height: scaledOuterRadius * 2,
                      decoration: BoxDecoration(
                        color: isSelected ? dimension['color'] : AppTheme.sidebarColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: dimension['color'],
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            
            // Layer 2: All text labels (after all wedges)
            for (int index = 0; index < AppConstants.dimensions.length; index++) {
              final dimension = AppConstants.dimensions[index];
              final dimensionId = dimension['id'];
              final bool isSelected = selectedDimensionId == dimensionId;
              
              // Use the SAME angle calculation - start from right (0°)
              final double centerAngle = (index * sweepAngle) % (2 * math.pi) - (3* math.pi / 2);
              final double angleDegrees = centerAngle * (180 / math.pi);
              
              // Calculate text positioning to center it in the wedge
              final double textRadius = scaledInnerRadius + ((scaledOuterRadius - scaledInnerRadius) * 0.7);
              final String text = dimension['name'];
              final double fontSize = math.max(10, scaledOuterRadius * 0.045);
              
              // Estimate text arc length and adjust start angle to center text
              final double approxCharWidth = fontSize * 0.7; // Approximate character width
              final double textArcLength = text.length * approxCharWidth;
              final double textAngleSpan = textArcLength / textRadius; // Arc length to angle
              // final double textStartAngle = centerAngle - (textAngleSpan / 2); // Center the text
              final double textStartAngle = centerAngle; // Center the text
              
              // Text direction logic
              Direction textDirection = Direction.clockwise;
              // print("text: $text, angleDegrees: $angleDegrees, textStartAngle: $textStartAngle"); // Print angleDegrees);
              if (angleDegrees < -90 && angleDegrees > -270) {
                textDirection = Direction.counterClockwise;
              }
              
              allLayers.add(
                SizedBox(
                  width: scaledOuterRadius * 2,
                  height: scaledOuterRadius * 2,
                  child: ArcText(
                    radius: textRadius,
                    text: text,
                    textStyle: TextStyle(
                      fontSize: fontSize * 1.4,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black,
                      letterSpacing: 0.6,
                    ),
                    startAngle: textStartAngle, // Use calculated centered start angle
                    startAngleAlignment: StartAngleAlignment.center,
                    placement: Placement.outside,
                    direction: textDirection,
                  ),
                ),
              );
            }
            
            // Layer 3: All icon buttons (on top)
            for (int index = 0; index < AppConstants.dimensions.length; index++) {
              final dimension = AppConstants.dimensions[index];
              final dimensionId = dimension['id'];
              final bool isSelected = selectedDimensionId == dimensionId;
              
              // Use the SAME angle calculation - start from right (0°)
              final double centerAngle = (index * sweepAngle) % (2 * math.pi);
              
              // Position icon
              final double iconRadius = scaledInnerRadius + ((scaledOuterRadius - scaledInnerRadius) * 0.4);
              final double x = scaledOuterRadius + (iconRadius * math.cos(centerAngle));
              final double y = scaledOuterRadius + (iconRadius * math.sin(centerAngle));

              allLayers.add(
                Positioned(
                  left: x - 30,
                  top: y - 30,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDimensionId = dimensionId;
                      });
                      widget.onDimensionSelected(dimensionId);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        // color: dimension['color'],
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        dimension['icon'],
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              );
            }
            
            return allLayers;
          })(),
          
          // // Center circle with title
          // Container(
          //   width: scaledInnerRadius,
          //   height: scaledInnerRadius,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     shape: BoxShape.circle,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.1),
          //         blurRadius: 5,
          //         spreadRadius: 1,
          //       ),
          //     ],
          //   ),
          //   child: Center(
          //     child: Text(
          //       'Onni in\n${AppConstants.dimensions.length} Dimensions',
          //       style: TextStyle(
          //         fontSize: scaledInnerRadius * 0.12,
          //         fontWeight: FontWeight.bold,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class CircularWedgeButton extends StatelessWidget {
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
  final double? textAngle; // Add textAngle parameter

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
    required this.onTap,
    this.isSelected = false,
    this.textAngle, // Add textAngle parameter
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
              color: isSelected ? color : AppTheme.sidebarColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 20,
              ),
            ),
            child: Container(),
          ),
        ),
        // Icon positioned outside the clipped area
        _buildIconButton(),
        // Arc text positioned outside the clipped area  
        _buildArcText(),
        // InkWell with custom shape for precise hit detection
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: WedgeShapeBorder(
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
    // Calculate icon position based on actual clipped wedge center
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
      left: x - 20, // Center the icon
      top: y - 20,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildArcText() {
    // Use the provided textAngle if available, otherwise calculate center angle
    double centerAngle;
    
    if (textAngle != null) {
      // Use the textAngle from constants (convert from degrees to radians)
      centerAngle = (textAngle! - 90) * (math.pi / 180);
    } else {
      // Fallback to calculated center angle based on wedge
      final gapWidth = 4.0;
      final outerGap = gapWidth / outerRadius;
      final innerGap = gapWidth / innerRadius;
      final avgGap = (outerGap + innerGap) / 2;
      final adjustedStartAngle = startAngle + avgGap;
      final adjustedSweepAngle = sweepAngle - (avgGap * 2);
      centerAngle = adjustedStartAngle + (adjustedSweepAngle / 2);
    }
    
    // Determine text positioning based on angle
    // Convert centerAngle to 0-2π range for consistent positioning
    final normalizedAngle = centerAngle % (2 * math.pi);
    final angleDegrees = normalizedAngle * (180 / math.pi);
    
    // Position text consistently around the circle
    double textRadius = innerRadius + ((outerRadius - innerRadius) * 0.7);
    double textStartAngle = centerAngle;
    Placement textPlacement = Placement.outside;
    Direction textDirection = Direction.clockwise;
    
    // Adjust direction based on position to ensure text reads correctly
    if (angleDegrees > 90 && angleDegrees < 270) {
      // Bottom half - use counterclockwise for better readability
      textDirection = Direction.counterClockwise;
      textStartAngle = centerAngle + (text.length * 0.02); // Slight offset for better centering
    } else {
      // Top half - use clockwise
      textDirection = Direction.clockwise;
      textStartAngle = centerAngle - (text.length * 0.02); // Slight offset for better centering
    }
    
    return SizedBox(
      width: outerRadius * 2,
      height: outerRadius * 2,
      child: ArcText(
        radius: textRadius,
        text: text,
        textStyle: TextStyle(
          fontSize: math.max(10, outerRadius * 0.045),
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.black,
          letterSpacing: 0.8,
        ),
        startAngle: textStartAngle,
        startAngleAlignment: StartAngleAlignment.center, // Center the text on the angle
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

class WedgeShapeBorder extends ShapeBorder {
  final double startAngle;
  final double sweepAngle;
  final double radius;
  final double innerRadius;

  const WedgeShapeBorder({
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
    return WedgeShapeBorder(
      startAngle: startAngle,
      sweepAngle: sweepAngle,
      radius: radius * t,
      innerRadius: innerRadius * t,
    );
  }
}

class WedgeButton extends StatefulWidget {
  final int index;
  final int totalWedges;
  final String label;
  final IconData icon;
  final Color color;
  final double score;
  final VoidCallback onTap;
  final bool isActive;

  const WedgeButton({
    super.key,
    required this.index,
    required this.totalWedges,
    required this.label,
    required this.icon,
    required this.color,
    required this.score,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<WedgeButton> createState() => _WedgeButtonState();
}

class _WedgeButtonState extends State<WedgeButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Get the specific angle for this dimension from constants
    final dimension = AppConstants.dimensions[widget.index];
    final double wedgeAngleDegrees = dimension['angle']?.toDouble() ?? (widget.index * (360 / widget.totalWedges));
    
    // Calculate angle for the wedge
    final double anglePerWedge = 2 * math.pi / widget.totalWedges;
    final double startAngle = (wedgeAngleDegrees - 90) * (math.pi / 180) - (anglePerWedge / 2); // Convert to radians and adjust for top start
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            // Wedge path
            CustomPaint(
              painter: WedgePainter(
                color: widget.color.withOpacity(_isHovered || widget.isActive ? 0.8 : 0.3),
                startAngle: startAngle,
                sweepAngle: anglePerWedge,
              ),
              child: Container(), // Empty container to fill the paint
            ),
          ],
        ),
      ),
    );
  }
}

class WedgePainter extends CustomPainter {
  final Color color;
  final double startAngle;
  final double sweepAngle;
  
  WedgePainter({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final Path path = SvgUtils.createWedgePath(
      size: size,
      startAngle: startAngle,
      sweepAngle: sweepAngle,
    );
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is WedgePainter) {
      return oldDelegate.color != color ||
             oldDelegate.startAngle != startAngle ||
             oldDelegate.sweepAngle != sweepAngle;
    }
    return true;
  }
}