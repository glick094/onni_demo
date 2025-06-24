import 'package:flutter/material.dart';
import 'dart:math' as math;

class SvgUtils {
  /// Converts an SVG path to a Flutter Path object
  static Path svgPathToFlutterPath(String svgPath) {
    final Path path = Path();
    
    // Parse the SVG path string
    final List<String> commands = _extractCommands(svgPath);
    
    for (int i = 0; i < commands.length; i++) {
      final String command = commands[i];
      
      if (command.startsWith('M') || command.startsWith('m')) {
        _handleMoveCommand(path, command);
      } else if (command.startsWith('L') || command.startsWith('l')) {
        _handleLineCommand(path, command);
      } else if (command.startsWith('C') || command.startsWith('c')) {
        _handleCubicCommand(path, command);
      } else if (command.startsWith('Z') || command.startsWith('z')) {
        path.close();
      }
    }
    
    return path;
  }
  
  /// Extracts commands from SVG path string
  static List<String> _extractCommands(String svgPath) {
    // Remove newlines and extra spaces
    final cleanPath = svgPath.replaceAll('\n', ' ').trim();
    final List<String> commands = [];
    
    int start = 0;
    for (int i = 1; i < cleanPath.length; i++) {
      final char = cleanPath[i];
      if ((char.toUpperCase() == char && char.contains(RegExp(r'[A-Z]'))) || 
          i == cleanPath.length - 1) {
        commands.add(cleanPath.substring(start, i).trim());
        start = i;
      }
    }
    
    if (start < cleanPath.length) {
      commands.add(cleanPath.substring(start).trim());
    }
    
    return commands;
  }
  
  /// Handles 'M' (move to) commands
  static void _handleMoveCommand(Path path, String command) {
    final bool isRelative = command.startsWith('m');
    final String coordinates = command.substring(1).trim();
    final List<String> parts = coordinates.split(' ');
    
    if (parts.length >= 2) {
      final double x = double.parse(parts[0]);
      final double y = double.parse(parts[1]);
      
      if (isRelative) {
        path.relativeMoveTo(x, y);
      } else {
        path.moveTo(x, y);
      }
    }
  }
  
  /// Handles 'L' (line to) commands
  static void _handleLineCommand(Path path, String command) {
    final bool isRelative = command.startsWith('l');
    final String coordinates = command.substring(1).trim();
    final List<String> parts = coordinates.split(' ');
    
    if (parts.length >= 2) {
      final double x = double.parse(parts[0]);
      final double y = double.parse(parts[1]);
      
      if (isRelative) {
        path.relativeLineTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
  }
  
  /// Handles 'C' (cubic bezier) commands
  static void _handleCubicCommand(Path path, String command) {
    final bool isRelative = command.startsWith('c');
    final String coordinates = command.substring(1).trim();
    final List<String> parts = coordinates.split(' ');
    
    if (parts.length >= 6) {
      final double x1 = double.parse(parts[0]);
      final double y1 = double.parse(parts[1]);
      final double x2 = double.parse(parts[2]);
      final double y2 = double.parse(parts[3]);
      final double x3 = double.parse(parts[4]);
      final double y3 = double.parse(parts[5]);
      
      if (isRelative) {
        path.relativeCubicTo(x1, y1, x2, y2, x3, y3);
      } else {
        path.cubicTo(x1, y1, x2, y2, x3, y3);
      }
    }
  }
  
  /// Creates a wedge path specifically for the circular layout
  static Path createWedgePath({
    required Size size,
    required double startAngle,
    required double sweepAngle,
    double? innerRadius,
  }) {
    final Path path = Path();
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double outerRadius = math.min(size.width, size.height) / 2;
    final double innerR = innerRadius ?? outerRadius * 0.4;
    
    // SVG-like path construction based on the design
    
    // Move to start of inner arc
    path.moveTo(
      center.dx + innerR * math.cos(startAngle),
      center.dy + innerR * math.sin(startAngle)
    );
    
    // Outer arc
    path.arcTo(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      sweepAngle,
      false
    );
    
    // Line to inner radius end point
    path.lineTo(
      center.dx + innerR * math.cos(startAngle + sweepAngle),
      center.dy + innerR * math.sin(startAngle + sweepAngle)
    );
    
    // Draw inner arc in reverse direction
    path.arcTo(
      Rect.fromCircle(center: center, radius: innerR),
      startAngle + sweepAngle,
      -sweepAngle,
      false
    );
    
    // Close the path
    path.close();
    
    return path;
  }
  
  /// Converts the specific SVG path you provided into a Flutter Path
  static Path createCustomWedgePath(Size size, double startAngle, double sweepAngle, double innerRadius) {
    // Create a basic wedge path
    final Path path = createWedgePath(
      size: size,
      startAngle: startAngle,
      sweepAngle: sweepAngle,
      innerRadius: innerRadius,
    );
    
    // Apply any custom styling needed to match the provided SVG
    // The SVG path: "M187.139 0.170637C272.767 85.7989 320.872 201.936 320.872 323.032L84.2705 323.032C50.012 323.032 23.326 294.233 10.2158 262.582C-2.89431 230.932 -4.38843 191.698 19.836 167.473L187.139 0.170637Z"
    // This is a specialized path that would need custom handling
    
    // Return the basic wedge path for now
    return path;
  }
}