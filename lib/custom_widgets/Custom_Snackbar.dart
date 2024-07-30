import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
 @override
  final Key? key;
 final Widget content;
 final Color? backgroundColor;
 final double? elevation;
 final EdgeInsetsGeometry? margin;
 final EdgeInsetsGeometry? padding;
 final double? width;
 final ShapeBorder? shape;
 final HitTestBehavior? hitTestBehavior;
 final SnackBarBehavior? behavior;
 final SnackBarAction? action;
 final double? actionOverflowThreshold;
 final bool? showCloseIcon;
 final Color? closeIconColor;
 // Duration duration = _snackBarDisplayDuration;
 final Animation<double>? animation;
 final VoidCallback? onVisible;
 final DismissDirection? dismissDirection;
 Clip clipBehavior = Clip.hardEdge;

 CustomSnackbar({
   this.key,
   required this.content,
   this.backgroundColor,
   this.elevation,
   this.margin,
   this.padding,
   this.width,
   this.shape,
   this.hitTestBehavior,
   this.behavior,
   this.action,
   this.actionOverflowThreshold,
   this.showCloseIcon,
   this.closeIconColor,
   // this.duration = _snackBarDisplayDuration,
   this.animation,
   this.onVisible,
   this.dismissDirection,
   this.clipBehavior = Clip.hardEdge,
 });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SnackBar(
        key: key,
        content: content,
        backgroundColor: backgroundColor,
        elevation: elevation,
        margin: margin,
        padding: padding,
        width: width,
        shape: shape,
        hitTestBehavior: hitTestBehavior,
        behavior: behavior,
        action: action,
        actionOverflowThreshold: actionOverflowThreshold,
        showCloseIcon: showCloseIcon,
        closeIconColor: closeIconColor,
        // duration: duration,
        animation: animation,
        onVisible: onVisible,
        dismissDirection: dismissDirection,
        clipBehavior: clipBehavior,
      ),
    );
  }
}
