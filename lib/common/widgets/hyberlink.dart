import 'package:flutter/material.dart';

InkWell getHyberLink(String title, Function onTapFunc) {
  return InkWell(
    onTap: () => onTapFunc(),
    child: Text(
      title,
      style: const TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.blue,
      ),
    ),
  );
}
