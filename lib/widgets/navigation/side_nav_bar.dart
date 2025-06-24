import 'package:flutter/material.dart';
import 'package:onni_homes_dashboard/utils/theme.dart';
import '../../models/wellness_data.dart';
import '../../utils/constants.dart';
import '../common/nav_item.dart';

class SideNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final WellnessData userData;

  const SideNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width to determine if we should show the full sidebar or a dropdown
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrowScreen = screenWidth < 600; // Threshold for mobile view
  precacheImage(AssetImage("assets/logo/Logo-04.png"), context);

    if (isNarrowScreen) {
      return _buildMobileNavigation(context);
    } else {
      return _buildDesktopNavigation(context);
    }
  }

  // Mobile navigation with dropdown/hamburger menu
  Widget _buildMobileNavigation(BuildContext context) {
    return Container(
      width: 70, // Narrower width for mobile view
      // color: Colors.white,
      color: AppTheme.accentColor,
      child: Column(
        children: [
          // Logo with no text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Icon(Icons.sailing, color: const Color(0xFF0A3D62), size: 28),
          ),
          
          // Hamburger menu button
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showMobileNavigationDrawer(context);
            },
          ),
          
          // Small icons for common navigation items
          Expanded(
            child: ListView.builder(
              itemCount: AppConstants.navigationItems.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = AppConstants.navigationItems[index];
                return IconButton(
                  icon: Icon(
                    item['icon'],
                    color: selectedIndex == index ? const Color(0xFF0A3D62) : AppTheme.sidebarColor,
                  ),
                  onPressed: () => onItemSelected(index),
                );
              },
            ),
          ),
          
          // User avatar only
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userData.userImage),
            ),
          ),
        ],
      ),
    );
  }
  
  // Show dropdown menu for mobile
  void _showMobileNavigationDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userData.userImage),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      userData.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ...AppConstants.navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['name']),
                  selected: selectedIndex == index,
                  selectedTileColor: Colors.blue.withOpacity(0.1),
                  onTap: () {
                    onItemSelected(index);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Desktop navigation with full sidebar
  Widget _buildDesktopNavigation(BuildContext context) {
    return Container(
      width: 200, // Wider to accommodate text in a single line
      color: Colors.white,
      child: Column(
        children: [
          // Logo and home text
          ClipRect(
            child: Align(
              alignment: Alignment.center,
              widthFactor: 1.0,
              heightFactor: 0.4,
              child: Image.asset(
                'assets/logo/Logo-04.png',
                width: 185,
                // width: constrainedLogoWidth, // Responsive size that fits well in the sidebar
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
          
          // Navigation items
          Expanded(
            child: ListView.builder(
              itemCount: AppConstants.navigationItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black12, width: 1),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  // backgroundImage: NetworkImage(userData.userImage),
                  backgroundImage: AssetImage('assets/images/ann.png'),
                ),
                const SizedBox(width: 12),
                Text(
                  userData.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}