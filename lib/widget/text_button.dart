import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun7/constant/style_guide.dart';

Widget customTextButton(
    Color backgroundColor, String text, int size, onPressed) {
  return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.all(15),
          backgroundColor: backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: size.toDouble(), color: AppColor.white),
      ));
}
