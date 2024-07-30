import 'package:flutter/material.dart';

class CustomDropdownBtn<T> extends StatelessWidget {
  @override
  final Key? key;
  final List<DropdownMenuItem<T>>? items;
  final DropdownButtonBuilder? selectedItemBuilder;
  final T? value;
  final Widget? hint;
  final Widget? disabledHint;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onTap;
  int elevation = 8;
  final TextStyle? style;
  final Widget? underline;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  double iconSize = 24.0;
  bool isDense = false;
  bool isExpanded = false;
  double? itemHeight = kMinInteractiveDimension;
  final Color? focusColor;
  final FocusNode? focusNode;
  bool autofocus = false;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  AlignmentGeometry alignment = AlignmentDirectional.centerStart;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  CustomDropdownBtn({
    this.key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    required this.onChanged,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      key: key,
      items: items,
      selectedItemBuilder: selectedItemBuilder,
      value: value,
      hint: hint,
      disabledHint: disabledHint,
      onChanged: onChanged,
      onTap: onTap,
      elevation: elevation,
      style: style,
      underline: underline,
      icon: icon,
      iconDisabledColor: iconDisabledColor,
      iconEnabledColor: iconEnabledColor,
      iconSize: iconSize,
      isDense: isDense,
      isExpanded: isExpanded,
      itemHeight: itemHeight,
      focusColor: focusColor,
      focusNode: focusNode,
      autofocus: autofocus,
      dropdownColor: dropdownColor,
      menuMaxHeight: menuMaxHeight,
      enableFeedback: enableFeedback,
      alignment: alignment,
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}
