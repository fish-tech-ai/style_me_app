import 'package:flutter/material.dart';
import 'dart:async';

import 'package:style_me/core/extensions/number_ext.dart';
import 'package:style_me/core/views/buttons/app_outlined_button.dart';

class CountdownOutlinedButton extends StatefulWidget {
  final String text;
  final Function() onClick;
  final int seconds;

  const CountdownOutlinedButton(
      {super.key,
      required this.text,
      required this.onClick,
      this.seconds = 5 * 60});

  @override
  State<CountdownOutlinedButton> createState() =>
      _CountdownOutlinedButtonState();
}

class _CountdownOutlinedButtonState extends State<CountdownOutlinedButton> {
  int _remainingTime = 0;
  Timer? _timer;

  void _startCountdown() {
    widget.onClick();
    setState(() {
      _remainingTime = widget.seconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppOutlinedButton(
      onClick: _remainingTime > 0 ? null : _startCountdown,
      text: _remainingTime > 0
          ? "${widget.text} • ${_remainingTime.secondsToString()}"
          : widget.text,
    );
  }
}
