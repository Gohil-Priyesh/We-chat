import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// if we do not implement the preferredSizeWidget then it will not let our custom app to be place at appbar:
class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {

  final double height;
  @override
  final Key? key;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final ScrollNotificationPredicate notificationPredicate;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;

   CustomAppbar({
    this.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.height = kToolbarHeight,
  });

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.title,
      backgroundColor: widget.backgroundColor ?? Colors.white,
      leading: widget.leading ?? IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back)),
      surfaceTintColor: widget.surfaceTintColor,
      elevation: widget.elevation ?? 3,
      shadowColor: widget.shadowColor ?? Colors.black54,
      shape: widget.shape,
      toolbarHeight: widget.toolbarHeight,
      toolbarOpacity: widget.toolbarOpacity,
      titleTextStyle: widget.titleTextStyle,
      centerTitle: widget.centerTitle ?? true,
      toolbarTextStyle: widget.toolbarTextStyle,
      foregroundColor: widget.foregroundColor,
      clipBehavior: widget.clipBehavior,
      actions: widget.actions,
      bottom: widget.bottom,
      bottomOpacity: widget.bottomOpacity,
      flexibleSpace: widget.flexibleSpace,
      excludeHeaderSemantics: widget.excludeHeaderSemantics,
      titleSpacing: widget.titleSpacing,
      primary: widget.primary,
      systemOverlayStyle: widget.systemOverlayStyle,
      forceMaterialTransparency: widget.forceMaterialTransparency,
      key: widget.key,
      actionsIconTheme: widget.actionsIconTheme,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      iconTheme: widget.iconTheme,
      leadingWidth: widget.leadingWidth,
      scrolledUnderElevation: widget.scrolledUnderElevation,
     // notificationPredicate: ,
    );
  }
}
