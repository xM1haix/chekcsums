import "package:flutter/material.dart";

extension ExtensionOnString on String {
  double width({TextStyle? textStyle}) =>
      (TextPainter(
        text: TextSpan(text: this, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout()).size.width;
}
