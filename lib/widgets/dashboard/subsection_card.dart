import 'package:flutter/material.dart';
import '../../models/wellness_data.dart';
import '../../utils/theme.dart';

class SubSectionCard extends StatelessWidget {
  final SubSection subSection;
  final VoidCallback onToggleExpanded;

  const SubSectionCard({
    super.key,
    required this.subSection,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate responsive font size for subsection header
    final screenWidth = MediaQuery.of(context).size.width;
    final double headerFontSize = _calculateHeaderFontSize(screenWidth);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          // color: Colors.grey.withOpacity(0.3),
          color: Colors.black,
          width: 0.7,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 0,
        //     spreadRadius: 1,
        //   ),
        // ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggleExpanded,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subSection.name,
                    style: TextStyle(
                      fontSize: headerFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Icon(
                    subSection.isExpanded
                        // ? Icons.keyboard_arrow_up
                        ? Icons.minimize_rounded
                        // : Icons.keyboard_arrow_down,
                        : Icons.add_rounded,
                    color: AppTheme.textMediumColor,
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable content
          if (subSection.isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Determine number of columns based on available width
                  int columns = 1;
                  // if (constraints.maxWidth > 800) {
                  //   columns = 3;
                  // } else if (constraints.maxWidth < 500) {
                  //   columns = 1;
                  // }
                  
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2.5, // Wider for two-column layout
                    ),
                    itemCount: subSection.issues.length,
                    itemBuilder: (context, index) {
                      return IssueCardItem(issue: subSection.issues[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Calculate responsive header font size based on screen width
  double _calculateHeaderFontSize(double screenWidth) {
    if (screenWidth > 1600) {
      return 20.0; // Extra large desktop
    } else if (screenWidth > 1400) {
      return 18.0; // Large desktop
    } else if (screenWidth > 1000) {
      return 16.0; // Medium desktop
    } else if (screenWidth > 700) {
      return 15.0; // Small desktop/large tablet
    } else {
      return 14.0; // Mobile/small tablet
    }
  }
}

class IssueCardItem extends StatelessWidget {
  final Issue issue;

  const IssueCardItem({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate responsive font sizes and layout proportions based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 1400;
    final double titleFontSize = _calculateTitleFontSize(screenWidth);
    final double descriptionFontSize = _calculateDescriptionFontSize(screenWidth);
    
    // Adjust layout proportions for large screens
    final int textFlex = isLargeScreen ? 3 : 1; // Give more space to text on large screens
    final int imageFlex = isLargeScreen ? 2 : 1; // Give less space to image on large screens

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.sidebarColor,
        // color: Colors.grey[50],
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: AppTheme.sidebarColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduced from 12 to 8
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: Text content
            Expanded(
              flex: textFlex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge with title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getStatusColor(issue.status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          _getStatusIcon(issue.status),
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 10), // Reduced from 8 to 6
                      Expanded(
                        child: Text(
                          issue.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: titleFontSize,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8), // Reduced from 8 to 4
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        issue.description,
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          color: AppTheme.textMediumColor,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
              
              const SizedBox(width: 8), // Reduced from 12 to 8
              
              // Right column: Image
              Expanded(
                flex: imageFlex,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: issue.imageUrls.isNotEmpty 
                    ? _buildClickableImageWithTwoColumn(context)
                    : _buildPlaceholderWithTwoColumn(),
                ),
              ),
            ],
        ),
      ),
    );
  }


  Widget _buildClickableImageWithTwoColumn(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePopup(context, issue.imageUrls, issue.title),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                issue.imageUrls.first, // Show the first image
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.green[200],
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.orange[500],
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Overlay with zoom icon
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            // Image count indicator (show only if multiple images)
            if (issue.imageUrls.length > 1)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${issue.imageUrls.length} images',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderWithTwoColumn() {
    return Center(
      child: Icon(
        Icons.photo_camera_outlined,
        color: Colors.grey[400],
        size: 24,
      ),
    );
  }

  /// Show image popup with zoom functionality
  void _showImagePopup(BuildContext context, List<String> imageUrls, String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ImagePopupDialog(
          imageUrls: imageUrls,
          title: title,
        );
      },
    );
  }

  Color _getStatusColor(IssueStatus status) {
    switch (status) {
      case IssueStatus.urgent:
        return AppTheme.redColor;
      case IssueStatus.nonUrgent:
        return AppTheme.yellowColor;
      case IssueStatus.passed:
        return AppTheme.greenColor;
    }
  }

  IconData _getStatusIcon(IssueStatus status) {
    switch (status) {
      case IssueStatus.urgent:
        // return Icons.close;
        return Icons.priority_high_rounded;
      case IssueStatus.nonUrgent:
        // return Icons.priority_high;
        // return Icons.minimize_rounded;
        // return Icons.change_history_rounded;
        return Icons.notifications;
      case IssueStatus.passed:
        return Icons.check;
    }
  }

  /// Calculate responsive title font size based on screen width
  double _calculateTitleFontSize(double screenWidth) {
    if (screenWidth > 1600) {
      return 22.0; // Extra large desktop
    } else if (screenWidth > 1400) {
      return 20.0; // Large desktop
    } else if (screenWidth > 1000) {
      return 16.0; // Medium desktop
    } else if (screenWidth > 700) {
      return 15.0; // Small desktop/large tablet
    } else {
      return 14.0; // Mobile/small tablet
    }
  }

  /// Calculate responsive description font size based on screen width
  double _calculateDescriptionFontSize(double screenWidth) {
    if (screenWidth > 1600) {
      return 18.0; // Extra large desktop
    } else if (screenWidth > 1400) {
      return 16.0; // Large desktop
    } else if (screenWidth > 1000) {
      return 14.0; // Medium desktop
    } else if (screenWidth > 700) {
      return 13.0; // Small desktop/large tablet
    } else {
      return 12.0; // Mobile/small tablet
    }
  }

}

/// Image popup dialog with zoom functionality and image carousel
class ImagePopupDialog extends StatefulWidget {
  final List<String> imageUrls;
  final String title;

  const ImagePopupDialog({
    super.key,
    required this.imageUrls,
    required this.title,
  });

  @override
  State<ImagePopupDialog> createState() => _ImagePopupDialogState();
}

class _ImagePopupDialogState extends State<ImagePopupDialog> {
  final TransformationController _transformationController = TransformationController();
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Header with title and close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.imageUrls.length > 1) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Image ${_currentImageIndex + 1} of ${widget.imageUrls.length}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            
            // Zoomable image(s)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: widget.imageUrls.length == 1
                    ? _buildSingleImage(widget.imageUrls.first)
                    : _buildImageCarousel(),
              ),
            ),
            
            // Footer with zoom controls
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.5),
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image navigation (show only if multiple images)
                  if (widget.imageUrls.length > 1) ...[
                    IconButton(
                      onPressed: _currentImageIndex > 0 ? () => _previousImage() : null,
                      icon: const Icon(Icons.arrow_back_ios),
                      tooltip: 'Previous Image',
                    ),
                    const SizedBox(width: 16),
                  ],
                  
                  // Zoom controls
                  IconButton(
                    onPressed: () {
                      final Matrix4 matrix = Matrix4.identity()..scale(0.8);
                      _transformationController.value = matrix;
                    },
                    icon: const Icon(Icons.zoom_out),
                    tooltip: 'Zoom Out',
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      _transformationController.value = Matrix4.identity();
                    },
                    icon: const Icon(Icons.fit_screen),
                    tooltip: 'Reset Zoom',
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      final Matrix4 matrix = Matrix4.identity()..scale(2.0);
                      _transformationController.value = matrix;
                    },
                    icon: const Icon(Icons.zoom_in),
                    tooltip: 'Zoom In',
                  ),
                  
                  // Image navigation continued
                  if (widget.imageUrls.length > 1) ...[
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: _currentImageIndex < widget.imageUrls.length - 1 ? () => _nextImage() : null,
                      icon: const Icon(Icons.arrow_forward_ios),
                      tooltip: 'Next Image',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleImage(String imageUrl) {
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.asset(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      color: Colors.grey[500],
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Image not found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentImageIndex = index;
          // Reset zoom when changing images
          _transformationController.value = Matrix4.identity();
        });
      },
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        return InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: Image.asset(
              widget.imageUrls[index],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey[500],
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Image ${index + 1} not found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _previousImage() {
    if (_currentImageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentImageIndex < widget.imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}