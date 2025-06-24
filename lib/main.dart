import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const OnniWellnessApp());
}

class OnniWellnessApp extends StatelessWidget {
  const OnniWellnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onni Wellness',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}

// If you want to run and test this code quickly without setting up the full directory structure, 
// you can use this simplified version that combines all the necessary components:

/*
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const OnniWellnessApp());
}

class OnniWellnessApp extends StatelessWidget {
  const OnniWellnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onni Wellness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A3D62)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

// Sample data model
class WellnessData {
  final String userId;
  final String userName;
  final String userImage;
  final double liveWellScore;
  final Map<String, DimensionScore> dimensionScores;

  WellnessData({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.liveWellScore,
    required this.dimensionScores,
  });

  // Sample data for demo
  static WellnessData sampleData() {
    return WellnessData(
      userId: '1',
      userName: 'Ann Smith',
      userImage: 'https://via.placeholder.com/40',
      liveWellScore: 0.65,
      dimensionScores: {
        'physical': DimensionScore(
          dimensionId: 'physical', 
          score: 0.78, 
          insights: ['Regular exercise', 'Good sleep patterns'],
        ),
        'environmental': DimensionScore(
          dimensionId: 'environmental', 
          score: 0.62, 
          insights: ['Home organization', 'Moderate commute time'],
        ),
        'social': DimensionScore(
          dimensionId: 'social', 
          score: 0.85, 
          insights: ['Strong family connections', 'Active social life'],
        ),
        'emotional': DimensionScore(
          dimensionId: 'emotional', 
          score: 0.72, 
          insights: ['Good stress management', 'Positive outlook'],
        ),
        'occupational': DimensionScore(
          dimensionId: 'occupational', 
          score: 0.55, 
          insights: ['Career satisfaction', 'Work-life balance needs improvement'],
        ),
        'intellectual': DimensionScore(
          dimensionId: 'intellectual', 
          score: 0.68, 
          insights: ['Regular learning', 'Creative hobbies'],
        ),
        'spiritual': DimensionScore(
          dimensionId: 'spiritual', 
          score: 0.60, 
          insights: ['Meditation practice', 'Connection to values'],
        ),
        'financial': DimensionScore(
          dimensionId: 'financial', 
          score: 0.42, 
          insights: ['Budget management', 'Savings goals in progress'],
        ),
      },
    );
  }
}

class DimensionScore {
  final String dimensionId;
  final double score;
  final List<String> insights;

  DimensionScore({
    required this.dimensionId,
    required this.score,
    required this.insights,
  });
}

// Constants
class AppConstants {
  // Dimension names
  static const List<Map<String, dynamic>> dimensions = [
    {
      'id': 'physical',
      'name': 'PHYSICAL',
      'icon': Icons.directions_walk,
      'color': Color(0xFF4A90E2),
    },
    {
      'id': 'environmental',
      'name': 'ENVIRONMENTAL',
      'icon': Icons.home,
      'color': Color(0xFF4A90E2),
    },
    {
      'id': 'social',
      'name': 'SOCIAL',
      'icon': Icons.people,
      'color': Color(0xFF5E8FC7),
    },
    {
      'id': 'emotional',
      'name': 'EMOTIONAL',
      'icon': Icons.emoji_emotions,
      'color': Color(0xFF7DC0CE),
    },
    {
      'id': 'occupational',
      'name': 'OCCUPATIONAL',
      'icon': Icons.work,
      'color': Color(0xFF7DC0CE),
    },
    {
      'id': 'intellectual',
      'name': 'INTELLECTUAL',
      'icon': Icons.psychology,
      'color': Color(0xFF92D2CA),
    },
    {
      'id': 'spiritual',
      'name': 'SPIRITUAL',
      'icon': Icons.self_improvement,
      'color': Color(0xFF92D2CA),
    },
    {
      'id': 'financial',
      'name': 'FINANCIAL',
      'icon': Icons.attach_money,
      'color': Color(0xFF92D2CA),
    },
  ];

  // Navigation items
  static const List<Map<String, dynamic>> navigationItems = [
    {
      'id': 'dashboard',
      'name': 'Dashboard',
      'icon': Icons.dashboard,
    },
    {
      'id': 'physical',
      'name': 'Physical',
      'icon': Icons.directions_walk,
    },
    {
      'id': 'environmental',
      'name': 'Environmental',
      'icon': Icons.home,
    },
    {
      'id': 'social',
      'name': 'Social',
      'icon': Icons.people,
    },
    {
      'id': 'emotional',
      'name': 'Emotional',
      'icon': Icons.emoji_emotions,
    },
    {
      'id': 'intellectual',
      'name': 'Intellectual',
      'icon': Icons.psychology,
    },
    {
      'id': 'occupational',
      'name': 'Occupational',
      'icon': Icons.work,
    },
    {
      'id': 'spiritual',
      'name': 'Spiritual',
      'icon': Icons.self_improvement,
    },
    {
      'id': 'financial',
      'name': 'Financial',
      'icon': Icons.attach_money,
    },
  ];

  // Score labels
  static const List<Map<String, dynamic>> scoreLabels = [
    {
      'id': 'needsSupport',
      'text': 'NEEDS SUPPORT',
      'color': Color(0xFFE74C3C),
      'threshold': 0.33,
    },
    {
      'id': 'managing',
      'text': 'MANAGING',
      'color': Color(0xFFF9E94A),
      'threshold': 0.66,
    },
    {
      'id': 'thriving',
      'text': 'THRIVING',
      'color': Color(0xFF66CC66),
      'threshold': 1.0,
    },
  ];
}

// Theme Colors
class AppTheme {
  // Brand colors
  static const Color primaryColor = Color(0xFF0A3D62);
  static const Color secondaryColor = Color(0xFF4A90E2);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color accentColor = Color(0xFF5E8FC7);
  
  // Status colors
  static const Color redColor = Color(0xFFE74C3C);
  static const Color orangeColor = Color(0xFFFF9436);
  static const Color yellowColor = Color(0xFFF9E94A);
  static const Color greenLightColor = Color(0xFFADE04C);
  static const Color greenColor = Color(0xFF66CC66);
  
  // Text colors
  static const Color textDarkColor = Color(0xFF333333);
  static const Color textMediumColor = Color(0xFF666666);
  static const Color textLightColor = Color(0xFF999999);
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  late WellnessData _wellnessData;

  @override
  void initState() {
    super.initState();
    // Initialize with sample data
    _wellnessData = WellnessData.sampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Side Navigation
          SideNavBar(
            selectedIndex: _selectedNavIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedNavIndex = index;
              });
            },
            userData: _wellnessData,
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Live Well Score Gauge
                    LiveWellGauge(score: _wellnessData.liveWellScore),
                    
                    const SizedBox(height: 40),
                    
                    // Circular Button Layout (centered)
                    Center(
                      child: CircularButtonLayout(
                        wellnessData: _wellnessData,
                        onDimensionSelected: (dimensionId) {
                          // Handle dimension selection
                          final navIndex = _getDimensionNavIndex(dimensionId);
                          if (navIndex != -1) {
                            setState(() {
                              _selectedNavIndex = navIndex;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get navigation index from dimension ID
  int _getDimensionNavIndex(String dimensionId) {
    switch (dimensionId) {
      case 'physical': return 1;
      case 'environmental': return 2;
      case 'social': return 3;
      case 'emotional': return 4;
      case 'intellectual': return 5;
      case 'occupational': return 6;
      case 'spiritual': return 7;
      case 'financial': return 8;
      default: return -1;
    }
  }
}

// SideNavBar Widget
class SideNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final WellnessData userData;

  const SideNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      color: Colors.white,
      child: Column(
        children: [
          // Logo and home text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sailing, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Onni Home',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Navigation items
          Expanded(
            child: ListView.builder(
              itemCount: AppConstants.navigationItems.length,
              itemBuilder: (context, index) {
                final item = AppConstants.navigationItems[index];
                return NavItem(
                  icon: item['icon'],
                  label: item['name'],
                  isSelected: selectedIndex == index,
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
          
          // User profile at bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userData.userImage),
                ),
                const SizedBox(height: 8),
                Text(
                  userData.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Nav Item Widget
class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppTheme.textMediumColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textMediumColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Live Well Gauge Widget
class LiveWellGauge extends StatelessWidget {
  final double score; // Score from 0.0 to 1.0

  const LiveWellGauge({
    Key? key,
    required this.score,
  }) : super(key: key);

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
            children: AppConstants.scoreLabels.map((label) {
              // Determine if this label is active based on score
              final isActive = score < label['threshold'] && 
                  (AppConstants.scoreLabels.indexOf(label) == 0 || 
                   score >= AppConstants.scoreLabels[AppConstants.scoreLabels.indexOf(label) - 1]['threshold']);
              
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
    Key? key,
    required this.color,
    required this.text,
    required this.isActive,
  }) : super(key: key);

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

// Circular Button Layout Widget
class CircularButtonLayout extends StatefulWidget {
  final WellnessData wellnessData;
  final Function(String) onDimensionSelected;

  const CircularButtonLayout({
    Key? key,
    required this.wellnessData,
    required this.onDimensionSelected,
  }) : super(key: key);

  @override
  State<CircularButtonLayout> createState() => _CircularButtonLayoutState();
}

class _CircularButtonLayoutState extends State<CircularButtonLayout> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final size = MediaQuery.of(context).size;
    final chartSize = math.min(size.width - 60, 500.0);
    
    return Container(
      width: chartSize,
      height: chartSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer circular segments
          CustomPaint(
            size: Size(chartSize, chartSize),
            painter: CircularSegmentsPainter(
              hoveredIndex: hoveredIndex,
            ),
          ),
          
          // Center title
          Container(
            width: chartSize * 0.24,
            height: chartSize * 0.24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Onni in 8',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Dimensions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Circle buttons
          ...List.generate(AppConstants.dimensions.length, (index) {
            final dimension = AppConstants.dimensions[index];
            final dimensionId = dimension['id'];
            final dimensionScore = widget.wellnessData.dimensionScores[dimensionId]?.score ?? 0.5;
            
            // Calculate angle for position (shifted by -22.5 degrees to align correctly)
            final double angle = (index * (math.pi / 4)) - (math.pi / 8);
            final bool isHovered = hoveredIndex == index;
            
            // Calculate position based on angle
            final double radius = chartSize * 0.36; // Distance from center
            final double x = radius * math.cos(angle);
            final double y = radius * math.sin(angle);
            
            return Positioned(
              left: (chartSize / 2) + x - (chartSize * 0.08), // Center + position - half button width
              top: (chartSize / 2) + y - (chartSize * 0.08),  // Center + position - half button height
              child: MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: GestureDetector(
                  onTap: () => widget.onDimensionSelected(dimensionId),
                  child: Column(
                    children: [
                      // Button 
                      Container(
                        width: chartSize * 0.16,
                        height: chartSize * 0.16,
                        child: Center(
                          child: Container(
                            width: chartSize * 0.12,
                            height: chartSize * 0.12,
                            decoration: BoxDecoration(
                              color: isHovered ? dimension['color'] : Colors.white,
                              shape: BoxShape.circle,
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
                              color: isHovered ? Colors.white : AppTheme.primaryColor,
                              size: chartSize * 0.06,
                            ),
                          ),
                        ),
                      ),
                    ],
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

// Custom painter for circular segments
class CircularSegmentsPainter extends CustomPainter {
  final int? hoveredIndex;
  
  CircularSegmentsPainter({
    this.hoveredIndex,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.5;
    final innerRadius = size.width * 0.27;
    
    for (int i = 0; i < AppConstants.dimensions.length; i++) {
      final dimension = AppConstants.dimensions[i];
      final isHovered = hoveredIndex == i;
      
      // Calculate start and end angles
      final startAngle = i * (math.pi / 4) - (math.pi / 8);
      final sweepAngle = math.pi / 4;
      
      // Create a path for segment
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + innerRadius * math.cos(startAngle),
        center.dy + innerRadius * math.sin(startAngle),
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
      );
      path.lineTo(
        center.dx + innerRadius * math.cos(startAngle + sweepAngle),
        center.dy + innerRadius * math.sin(startAngle + sweepAngle),
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + sweepAngle,
        -sweepAngle,
        false,
      );
      path.close();
      
      // Draw segment
      final paint = Paint()
        ..color = dimension['color'].withOpacity(isHovered ? 0.9 : 0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CircularSegmentsPainter) {
      return oldDelegate.hoveredIndex != hoveredIndex;
    }
    return true;
  }
}
*/