import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  final Key? key;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final double? width;
  final Widget? child;
  final String? semanticLabel;
  final Clip? clipBehavior;

  const CustomDrawer({
    this.key,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.width,
    this.child,
    this.semanticLabel,
    this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        //key
         key:key,
        // drawer width
        width: width,
        // should drawer content clip or not
        clipBehavior: clipBehavior,
        //elevation of drawer
        elevation: elevation,
        // shadowColor of the elevation
        shadowColor: shadowColor,
        // drawer shape
        shape: shape,
        // The color used as a surface tint overlay on the drawer's background color //this will eventually get removed
        surfaceTintColor: surfaceTintColor,
        // Sets the color of the Material that holds all of the Drawer's contents.
        backgroundColor: backgroundColor,
        // use when drawer is open and closed
        semanticLabel: semanticLabel,
        //child
        child: child,
      ),
    );
  }
}
