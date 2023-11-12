import 'package:flutter/material.dart';

class Karta {
  int sign, num;
  bool highlight, hint;
  GlobalKey key;

  Karta({
    required this.num,
    required this.sign,
    required this.key,
    required this.highlight,
    this.hint = false,
  });
}
