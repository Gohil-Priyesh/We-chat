import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomRichText extends StatelessWidget {

 final Key? key;
 final InlineSpan text;
 TextAlign textAlign = TextAlign.start;
 final TextDirection? textDirection;
 bool softWrap = true;
 TextOverflow overflow = TextOverflow.clip;
 TextScaler textScaler = TextScaler.noScaling;
 final int? maxLines;
 final Locale? locale;
 final StrutStyle? strutStyle;
 TextWidthBasis textWidthBasis = TextWidthBasis.parent;
 final TextHeightBehavior? textHeightBehavior;
 final SelectionRegistrar?  selectionRegistrar;
 final Color? selectionColor;

  CustomRichText({
    this.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    double textScaleFactor = 1.0,
    TextScaler textScaler = TextScaler.noScaling,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textHeightBehavior,
    this.textWidthBasis = TextWidthBasis.parent,
    this.selectionRegistrar,
    this.selectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RichText(
        key: key,
        text: text,
        textAlign: textAlign,
        textDirection: textDirection,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        locale: locale,
        strutStyle: strutStyle,
        textHeightBehavior: textHeightBehavior,
        textWidthBasis: textWidthBasis,
        selectionRegistrar: selectionRegistrar,
        selectionColor: selectionColor,
      ),
    );
  }
}
