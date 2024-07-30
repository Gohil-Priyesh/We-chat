import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {

  @override
  final Key? key;
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int>? onTap;
   int currentIndex = 0;
  final double? elevation;
  final BottomNavigationBarType? type;
  final Color? fixedColor;
  final Color? backgroundColor;
   double iconSize = 24.0;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
   double selectedFontSize = 14.0;
   double unselectedFontSize = 12.0;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool? showSelectedLabels;
  final bool? showUnselectedLabels;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final BottomNavigationBarLandscapeLayout? landscapeLayout;
   bool useLegacyColorScheme = true;

  CustomNavbar({
    this.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.elevation,
    this.type,
     this.fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        key: key,
        items: items,
        onTap: onTap,
        currentIndex: currentIndex,
        elevation: elevation,
        type: type,
        fixedColor: fixedColor,
        backgroundColor: backgroundColor,
        iconSize: iconSize,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        selectedIconTheme: selectedIconTheme,
        unselectedIconTheme: unselectedIconTheme,
        selectedFontSize: selectedFontSize,
        unselectedFontSize: unselectedFontSize,
        selectedLabelStyle: selectedLabelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        showSelectedLabels: showSelectedLabels,
        showUnselectedLabels: showSelectedLabels,
        mouseCursor: mouseCursor,
        enableFeedback: enableFeedback,
        landscapeLayout: landscapeLayout,
        useLegacyColorScheme: useLegacyColorScheme,

      ),
    );
  }
}
