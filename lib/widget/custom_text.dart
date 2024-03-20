import 'dart:ui';

import 'package:flutter/cupertino.dart';

Widget customText(Color textColor, String text, int size, bool isbold) {
  return Text(
    text,
    style: TextStyle(
        color: textColor,
        fontSize: size.toDouble(),
        fontWeight: isbold ? FontWeight.bold : FontWeight.normal),
  );
}
