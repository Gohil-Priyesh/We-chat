import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  @override
  final Key? key;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  bool autofocus = false;
  final Clip? clipBehavior;
  final Widget? child;
  IconAlignment iconAlignment = IconAlignment.start;

 CustomBtn({
this.key,
required this.onPressed,
this.onLongPress,
this.onHover,
this.onFocusChange,
this.style,
this.focusNode,
this.autofocus = false,
this.clipBehavior,
required this.child,
this.iconAlignment = IconAlignment.start,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: (){},
        child: Text('btn'),
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        iconAlignment: iconAlignment,
        key: key,
      ),
    );
  }
}
