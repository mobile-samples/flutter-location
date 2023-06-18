import 'package:flutter/material.dart';

autoScrollOnTop(ScrollController controller) {
  controller.animateTo(
    controller.position.minScrollExtent,
    curve: Curves.easeOut,
    duration: const Duration(milliseconds: 500),
  );
}
