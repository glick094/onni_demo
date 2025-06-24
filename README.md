# onni_homes_dashboard

Onni Homes dashboard for user scores.

## Package layout

```bash
lib/
├── main.dart                    # Main entry point
├── models/                      # Data models
│   └── wellness_data.dart       # Wellness data models
├── screens/                     # Main screens
│   └── home_screen.dart         # The main home screen
├── widgets/                     # Reusable widgets 
│   ├── navigation/              # Navigation related widgets
│   │   └── side_nav_bar.dart    # Side navigation bar
│   ├── dashboard/               # Dashboard components
│   │   ├── circular_button_layout.dart  # Circular button layout
│   │   └── live_well_gauge.dart  # Live well score gauge
│   └── common/                  # Common reusable widgets
│       └── nav_item.dart        # Individual navigation item
└── utils/                       # Utilities and helpers
    ├── constants.dart           # App constants
    └── theme.dart               # App theme definitions
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## TODOs

- [x] Set up home page
- [x] Configure the circular buttons
- [ ] Configure the linear gauge for scores
- [x] Set up themes
- [x] Confirm we are using theme colors through out the app
- [x] Add logo and branding
- [x] Add icons
  - [x] Financial and Social are not the right icons, fix issue with svgs?  
- [ ] Add fonts (Source Code Pro)
- [x] Fix side nav bar (buttons don't navigate to a page. consider coloring with dimensions)

- [x] straight across on wedges
- [x] icons for social & financial
- [x] flip text on bottom wedges
- [x] change text color blue

- [x] fix checks red !, yellow -, green check
- [ ] add rooms and images, use descriptions from spreadsheet
- [ ] add Ann image
- [x] remove larger descriptions
- [ ] github
- [x] score arrow position

<!-- urgent, needs attention, passed -->

<!-- assets/icons/clarity--dollar-solid.svg
assets/icons/f7--house-fill.svg
assets/icons/fa-solid--walking.svg
assets/icons/ic--round-emoji-emotions.svg
assets/icons/material-symbols--work.svg
assets/icons/mdi--brain-freeze.svg
assets/icons/mdi--meditation.svg
assets/icons/ri--dashboard-fill.svg
assets/icons/tabler--social.svg -->