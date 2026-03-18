import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1024) {
          // Desktop
          return desktopBody;
        } else if (constraints.maxWidth >= 600) {
          // Tablet
          return tabletBody ?? mobileBody;
        } else {
          // Mobile
          return mobileBody;
        }
      },
    );
  }

  /// Returns true if the current screen width is less than 600 pixels
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Returns true if the current screen width is between 600 and 1024 pixels (inclusive)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width <= 1024;
  }

  /// Returns true if the current screen width is greater than 1024 pixels
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 1024;
  }

  /// Returns the current screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Returns the current screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
