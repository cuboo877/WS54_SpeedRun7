import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun7/constant/style_guide.dart';

class Utilites {
  static void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: AppColor.black,
      duration: const Duration(milliseconds: 250),
    ));
  }

  static String randomID() {
    Random random = Random();
    String result = "";
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static String randomPassowrd(
      bool l, bool u, bool n, bool s, int length, String custom) {
    StringBuffer buffer = StringBuffer();
    if (l) {
      buffer.write("abcdefghijklmnopqrstuvwxyz");
    }
    if (u) {
      buffer.write("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (n) {
      buffer.write("1234567890");
    }

    if (s) {
      buffer.write("!@#%^&&*()_+}{?}");
    }

    Random random = Random();
    StringBuffer resultBuffer = StringBuffer();
    for (int i = 0; i < length - custom.length; i++) {
      resultBuffer.write(buffer.toString()[random.nextInt(buffer.length)]);
    }
    int index = random.nextInt(resultBuffer.length - 1);
    String result = resultBuffer.toString();
    return "${result.substring(0, index)}$custom${result.substring(index)}";
  }
}
