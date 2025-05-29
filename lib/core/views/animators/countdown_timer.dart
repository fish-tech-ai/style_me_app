import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class CountdownTimer extends StatelessWidget {
  final int? secondsLeft;

  const CountdownTimer(this.secondsLeft, {super.key});

  @override
  Widget build(BuildContext context) {
    if (secondsLeft == null) return const SizedBox.shrink();

    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Text(
          '$secondsLeft',
          key: ValueKey(secondsLeft),
          style: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onPrimary
          ),
        ),
      ),
    );
  }
}

