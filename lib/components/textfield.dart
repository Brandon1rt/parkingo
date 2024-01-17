import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final Color normalBorderColor;
  final Color focusedBorderColor;
  final TextInputType keyboardType;

  MyTextfield({
    required this.labelText,
    required this.obscureText,
    required this.controller,
    required this.normalBorderColor,
    required this.focusedBorderColor,
    required this.keyboardType,
  });

  @override
  _MyTextfieldState createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: widget.normalBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: widget.focusedBorderColor),
        ),
      ),
      obscureText: widget.obscureText,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
    );
  }
}
