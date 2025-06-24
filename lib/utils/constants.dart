import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import 'dart:math' as math;
import '../../utils/onni_homes_icons.dart';


class AppConstants {
  // Dimension names with angles to match exact positions in screenshot
  static const List<Map<String, dynamic>> dimensions = [
    // {
    //   'id': 'environmental',
    //   'name': 'ENVIRONMENTAL',
    //   'icon': OnniHomesIcons.house,
    //   'color': AppTheme.environmentalColor,
    // },
    {
      'id': 'social',
      'name': 'SOCIAL',
      'icon': Icons.hub_outlined,
      'color': AppTheme.socialColor,
    },
    {
      'id': 'emotional',
      'name': 'EMOTIONAL',
      'icon': OnniHomesIcons.emotions,
      'color': AppTheme.emotionalColor,
    },
    {
      'id': 'intellectual',
      'name': 'INTELLECTUAL',
      'icon': OnniHomesIcons.brainFreeze,
      'color': AppTheme.intellectualColor,
    },
    {
      'id': 'occupational',
      'name': 'OCCUPATIONAL',
      'icon': OnniHomesIcons.work,
      'color': AppTheme.occupationalColor,
    },
    {
      'id': 'spiritual',
      'name': 'SPIRITUAL',
      'icon': OnniHomesIcons.meditation,
      'color': AppTheme.spiritualColor,
    },
    {
      'id': 'financial',
      'name': 'FINANCIAL',
      'icon': OnniHomesIcons.dollarSign,
      // 'icon': OnniHomesIcons.dollar,
      'color': AppTheme.financialColor,
    },
    {
      'id': 'environmental',
      'name': 'ENVIRONMENTAL',
      'icon': OnniHomesIcons.house,
      'color': AppTheme.physicalColor,
    },
    {
      'id': 'physical',
      'name': 'PHYSICAL',
      'icon': OnniHomesIcons.walking,
      'color': AppTheme.environmentalColor,
    },
  ];

  // Navigation items
  static const List<Map<String, dynamic>> navigationItems = [
    {
      'id': 'dashboard',
      'name': 'Dashboard',
      'icon': OnniHomesIcons.dashboard,
    },
    {
      'id': 'environmental',
      'name': 'Environmental',
      'icon': OnniHomesIcons.house,
    },
    {
      'id': 'physical',
      'name': 'Physical',
      'icon': OnniHomesIcons.walking,
    },
    {
      'id': 'social',
      'name': 'Social',
      // 'icon': OnniHomesIcons.social,
      'icon': Icons.hub_outlined,
      // 'icon': SvgPicture.asset(assetName: 'assets/icons/tabler--social.svg'),
    },
    {
      'id': 'emotional',
      'name': 'Emotional',
      'icon': OnniHomesIcons.emotions,
    },
    {
      'id': 'intellectual',
      'name': 'Intellectual',
      'icon': OnniHomesIcons.brainFreeze,
    },
    {
      'id': 'occupational',
      'name': 'Occupational',
      'icon': OnniHomesIcons.work,
    },
    {
      'id': 'spiritual',
      'name': 'Spiritual',
      'icon': OnniHomesIcons.meditation,
    },
    {
      'id': 'financial',
      'name': 'Financial',
      'icon': OnniHomesIcons.dollarSign,
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
