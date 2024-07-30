import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  Key? key;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  CustomDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Divider(
          key: key,
          height: height,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: color,
        ),
      ),
    );
  }
}
