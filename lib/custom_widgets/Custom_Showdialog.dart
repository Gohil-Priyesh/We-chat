import 'package:flutter/material.dart';

class CustomShowdialog extends StatelessWidget {
  @override
  Key? key;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  Duration insetAnimationDuration = const Duration(milliseconds: 100);
  Curve insetAnimationCurve = Curves.decelerate;
  final EdgeInsets? insetPadding;
  Clip clipBehavior = Clip.none;
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final Widget? child;

  CustomShowdialog({
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.insetPadding,
    this.clipBehavior = Clip.none,
    this.shape,
    this.alignment,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Dialog(
        key: key,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        insetAnimationDuration: insetAnimationDuration,
        insetAnimationCurve: insetAnimationCurve,
        insetPadding: insetPadding,
        clipBehavior: clipBehavior,
        shape: shape,
        alignment: alignment,
        child: child,
      ),
    ));
  }
}
