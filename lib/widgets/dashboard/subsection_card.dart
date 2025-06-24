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
                    style: const TextStyle(
                      fontSize: 16,
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
}

class IssueCardItem extends StatelessWidget {
  final Issue issue;

  const IssueCardItem({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: Text content
            Expanded(
              flex: 1,
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          issue.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        issue.description,
                        style: TextStyle(
                          fontSize: 9,
                          color: AppTheme.textMediumColor,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Right column: Image
            Expanded(
              flex: 1,
              child: Container(
                // height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: issue.imageUrl != null 
                  ? _buildImageWithTwoColumn()
                  : _buildPlaceholderWithTwoColumn(),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildImageWithTwoColumn() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          issue.imageUrl!,
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

}