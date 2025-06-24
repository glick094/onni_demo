import 'package:flutter/material.dart';
import 'package:onni_homes_dashboard/utils/theme.dart';
import '../models/wellness_data.dart';
import '../widgets/navigation/side_nav_bar.dart';
import '../widgets/navigation/slideable_nav_bar.dart';
import '../widgets/dashboard/live_well_gauge.dart';
import '../widgets/dashboard/wedge_button.dart';
import '../utils/constants.dart';
import 'dimension_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      // For very narrow screens (like phones in portrait), we'll use a standard AppBar
      appBar: isNarrowScreen ? AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: AppTheme.accentColor,
        elevation: 0,
        automaticallyImplyLeading: _selectedNavIndex != 0,
        leading: _selectedNavIndex != 0 ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedNavIndex = 0),
        ) : null,
      ) : null,
      // Use responsive layout
      body: isNarrowScreen 
          ? _buildMobileLayout() 
          : _buildDesktopLayout(),
    );
  }

  // Mobile layout with navigation at the bottom or as a drawer
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Main content takes most of the screen
        Expanded(
          child: _buildMainContent(),
        ),
        
        // Custom slideable bottom navigation
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Dashboard is always visible
              _buildNavItem(0, fixed: true),
              
              // Divider
              Container(
                width: 1,
                height: 30,
                color: Colors.grey.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
              
              // Scrollable section for other nav items
              Expanded(
                child: SlideableNavBar(
                  selectedIndex: _selectedNavIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _selectedNavIndex = index;
                    });
                  },
                  items: AppConstants.navigationItems.sublist(1), // Skip dashboard
                  startIndex: 1, // Because we're showing items starting from index 1
                  visibleItemCount: 3, // Show 3 items at a time
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Desktop layout with side navigation
  Widget _buildDesktopLayout() {
    return Row(
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
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  // Build main content based on selected navigation index
  Widget _buildMainContent() {
    if (_selectedNavIndex == 0) {
      // Dashboard view
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Well Score Gauge
              LiveWellGauge(score: _wellnessData.liveWellScore),
              
              const SizedBox(height: 40),
              
              // Circular Wedge Layout (centered)
              Center(
                child: CircularWedgeLayout(
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
      );
    } else {
      // Dimension view
      final dimensionId = _getDimensionIdFromNavIndex(_selectedNavIndex);
      final dimensionData = _wellnessData.dimensionScores[dimensionId];
      
      if (dimensionData != null) {
        return DimensionScreen(
          dimensionId: dimensionId,
          dimensionData: dimensionData,
        );
      } else {
        // Fallback for dimensions without detailed data
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'This dimension view is coming soon.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textMediumColor,
              ),
            ),
          ),
        );
      }
    }
  }

  String _getAppBarTitle() {
    if (_selectedNavIndex == 0) {
      return 'Onni Home';
    } else {
      final navItem = AppConstants.navigationItems[_selectedNavIndex];
      return navItem['name'];
    }
  }
  
  // Helper method to get navigation index from dimension ID
  int _getDimensionNavIndex(String dimensionId) {
    // Find the dimension in the navigationItems (skip dashboard at index 0)
    for (int i = 1; i < AppConstants.navigationItems.length; i++) {
      if (AppConstants.navigationItems[i]['id'] == dimensionId) {
        return i;
      }
    }
    return -1;
  }

  String _getDimensionIdFromNavIndex(int navIndex) {
    // Return the dimension ID from navigationItems
    if (navIndex > 0 && navIndex < AppConstants.navigationItems.length) {
      return AppConstants.navigationItems[navIndex]['id'];
    }
    return '';
  }
  
  // Build a fixed navigation item (used for Dashboard)
  Widget _buildNavItem(int index, {bool fixed = false}) {
    final item = AppConstants.navigationItems[index];
    final bool isSelected = _selectedNavIndex == index;
    
    return InkWell(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item['icon'],
              color: isSelected ? const Color(0xFF0A3D62) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item['name'],
              style: TextStyle(
                color: isSelected ? const Color(0xFF0A3D62) : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Indicator dot for selected
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF0A3D62) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}