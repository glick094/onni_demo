# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Onni Homes dashboard is a Flutter wellness tracking application that displays user wellness scores across 8 dimensions. The app features a circular button layout displaying wellness dimensions around a central "Onni in 8 Dimensions" hub, with responsive design for both desktop and mobile layouts.

## Commands

### Development Commands
- `flutter run` - Run the app in development mode
- `flutter run -d web` - Run on web platform
- `flutter run -d chrome` - Run specifically in Chrome
- `flutter build web` - Build for web deployment
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app

### Testing and Quality
- `flutter test` - Run all tests
- `flutter analyze` - Run static analysis
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter pub outdated` - Check for outdated packages

### Platform-specific
- `flutter build windows` - Build Windows desktop app
- `flutter build macos` - Build macOS desktop app
- `flutter build linux` - Build Linux desktop app

## Architecture

### Core Architecture
The app follows Flutter's standard widget-based architecture with clear separation of concerns:

- **Models** (`lib/models/`): Data structures for wellness data
- **Screens** (`lib/screens/`): Main application screens
- **Widgets** (`lib/widgets/`): Reusable UI components organized by category
- **Utils** (`lib/utils/`): Constants, themes, and utility functions

### Key Components

#### Responsive Design
The app implements responsive design with two distinct layouts:
- **Desktop Layout**: Side navigation bar with main content area
- **Mobile Layout**: Top app bar with bottom slideable navigation

#### Wellness Data System
- `WellnessData` model contains user info and dimension scores (0.0 to 1.0)
- 8 wellness dimensions: Physical, Environmental, Social, Emotional, Intellectual, Occupational, Spiritual, Financial
- Each dimension has a score, insights, and visual representation

#### Circular Button Layout
- Custom circular arrangement of 8 dimension buttons around central hub
- Uses custom painter for wedge-shaped background segments
- Responsive sizing based on screen dimensions
- Hover effects and interactive selection

#### Navigation System
- Desktop: Fixed side navigation with user profile
- Mobile: Sliding bottom navigation with dashboard always visible
- Navigation items correspond to wellness dimensions plus dashboard

### Theme System
- Centralized theme in `AppTheme` class
- Brand colors: Primary (#1A3957), Secondary (#77BEFD), Background (#FFFFFF)
- Dimension-specific colors for visual categorization
- Status colors for score indicators (red, orange, yellow, green)

### Custom Icons
- Custom font-based icon system (`OnniHomesIcons`)
- Specific icons for each wellness dimension
- Generated from SVG assets using FlutterIcon.com

### Responsive Breakpoints
- Mobile layout triggers at screen width < 600px
- Circular button layout scales based on available space
- Navigation adapts from side bar to bottom navigation

## Key Files

- `lib/main.dart`: App entry point and theme configuration
- `lib/screens/home_screen.dart`: Main responsive layout logic
- `lib/widgets/dashboard/circular_button_layout.dart`: Core circular UI component
- `lib/widgets/dashboard/live_well_gauge.dart`: Score visualization
- `lib/utils/theme.dart`: Color palette and theme definitions
- `lib/utils/constants.dart`: Dimension definitions and navigation items
- `lib/models/wellness_data.dart`: Data model with sample data

## Development Notes

### Working with Dimensions
Each wellness dimension has consistent properties:
- `id`: String identifier
- `name`: Display name (ALL CAPS)
- `icon`: Custom icon from OnniHomesIcons
- `color`: Theme-specific color
- `angle`: Position in circular layout

### Responsive Development
When modifying UI components, consider both desktop and mobile layouts. The `home_screen.dart` uses `MediaQuery` to determine layout type and renders appropriate components.

### Custom Painting
The circular layout uses Flutter's `CustomPainter` for drawing wedge-shaped segments. When modifying the circular layout, ensure the painter logic matches the button positioning.

### Navigation State
Navigation state is managed at the screen level and passed down to components. The selected index corresponds to items in `AppConstants.navigationItems`.

### Data Flow Pattern
The app uses a top-down state management approach:
- State flows from `HomeScreen` down through the widget tree
- Event handling uses callback functions passed down to child components
- `WellnessData` model contains sample data for demonstration
- Navigation state is managed through integer indices that map to dimensions

### Circular Layout Architecture
The core circular UI component uses a three-layer approach:
1. **Base Layer**: Colored wedge segments using `WedgePainter` custom painter
2. **Interactive Layer**: White overlay wedges using `OverlayWedgePainter`
3. **Element Layer**: Positioned buttons and text using absolute positioning

### Testing Status
Current test suite needs updating - the existing test references `MyApp` which should be `OnniWellnessApp`. Tests should be run with `flutter test` after updating the main test file.