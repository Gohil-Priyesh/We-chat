import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  @override
  final Key? key;
  bool enabled = true;
  final double? width;
  final double? menuHeight;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? selectedTrailingIcon;
  bool enableFilter = false;
  bool enableSearch = true;
  final TextStyle? textStyle;
  final InputDecorationTheme? inputDecorationTheme;
  final MenuStyle? menuStyle;
  final TextEditingController? controller;
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final FocusNode? focusNode;
  final bool? requestFocusOnTap;
  final EdgeInsets? expandedInsets;
  final SearchCallback<T>? searchCallback;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final List<TextInputFormatter>? inputFormatters;

  CustomDropdownMenu({
    this.key,
    this.enabled = true,
    this.width,
    this.menuHeight,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.selectedTrailingIcon,
    this.enableFilter = false,
    this.enableSearch = true,
    this.textStyle,
    this.inputDecorationTheme,
    this.menuStyle,
    this.controller,
    this.initialSelection,
    this.onSelected,
    this.focusNode,
    this.requestFocusOnTap,
    this.expandedInsets,
    this.searchCallback,
    required this.dropdownMenuEntries,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      key: key,
      enabled: enabled,
      width: width,
      menuHeight: menuHeight,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      selectedTrailingIcon: selectedTrailingIcon,
      enableFilter: enableFilter,
      enableSearch: enableSearch,
      textStyle: textStyle,
      inputDecorationTheme: inputDecorationTheme,
      menuStyle: menuStyle,
      controller: controller,
      initialSelection: initialSelection,
      onSelected: onSelected,
      focusNode: focusNode,
      requestFocusOnTap: requestFocusOnTap,
      expandedInsets: expandedInsets,
      searchCallback: searchCallback,
      dropdownMenuEntries: dropdownMenuEntries,
      inputFormatters: inputFormatters,
    );
  }
}
