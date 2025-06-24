import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SlideableNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<Map<String, dynamic>> items;
  final int startIndex; // The index offset value (typically 1 if dashboard is separate)
  final int visibleItemCount; // How many items to show at once (typically 3)

  const SlideableNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    required this.startIndex,
    this.visibleItemCount = 3,
  });

  @override
  State<SlideableNavBar> createState() => _SlideableNavBarState();
}

class _SlideableNavBarState extends State<SlideableNavBar> {
  late ScrollController _scrollController;
  late int _effectiveSelectedIndex;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _effectiveSelectedIndex = widget.selectedIndex - widget.startIndex;
    _scheduleScrollToSelected();
  }

  @override
  void didUpdateWidget(SlideableNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _effectiveSelectedIndex = widget.selectedIndex - widget.startIndex;
      _scheduleScrollToSelected();
    }
  }

  void _scheduleScrollToSelected() {
    // Schedule scroll after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void _scrollToSelected() {
    if (_effectiveSelectedIndex < 0 || _scrollController.positions.isEmpty) return;

    // Calculate the width of each item (assuming they're equal width)
    final double itemWidth = _scrollController.position.maxScrollExtent / 
        (widget.items.length - widget.visibleItemCount);
    
    // Calculate desired scroll position to center the selected item
    final int visibleFrom = _effectiveSelectedIndex - (widget.visibleItemCount ~/ 2);
    int targetIndex = visibleFrom < 0 ? 0 : visibleFrom;
    
    // If we're near the end, show last set of items
    if (_effectiveSelectedIndex >= widget.items.length - (widget.visibleItemCount ~/ 2)) {
      targetIndex = widget.items.length - widget.visibleItemCount;
    }
    
    if (targetIndex < 0) targetIndex = 0;
    
    final double scrollTarget = targetIndex * itemWidth;
    
    _scrollController.animateTo(
      scrollTarget,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final bool isSelected = widget.selectedIndex == index + widget.startIndex;
        
        return InkWell(
          onTap: () => widget.onItemSelected(index + widget.startIndex),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'],
                  color: isSelected ? AppTheme.primaryColor : Colors.grey,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item['name'],
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 2),
                // Indicator dot for selected
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}