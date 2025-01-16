import 'package:flutter/material.dart';

class AppStatus extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final IconData icon;

  const AppStatus(
      {super.key,
      required this.color,
      required this.text,
      required this.icon,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: color,
      width: double.infinity,
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none),
          ),
          Icon(icon, color: textColor)
        ],
      ),
    );
  }
}
