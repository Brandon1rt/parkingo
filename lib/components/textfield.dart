import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Color normalBorderColor;
  final Color focusedBorderColor;

  MyTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.normalBorderColor,
    required this.focusedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: normalBorderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: focusedBorderColor)),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      ),
      obscureText: obscureText,
    );
  }
}
