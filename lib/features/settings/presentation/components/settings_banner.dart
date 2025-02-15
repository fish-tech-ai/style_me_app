import 'package:flutter/material.dart';

class SettingsBanner extends StatelessWidget {
  final String email;

  const SettingsBanner({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(email),);
  }
}
