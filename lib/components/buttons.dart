import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color color;

  MyButtons(
      {super.key,
      required this.text,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        )),
      ),
    );
  }
}
