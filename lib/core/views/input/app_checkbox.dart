import 'package:flutter/material.dart';
import 'package:style_me/core/lang/localizations_helper.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required String title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom rounded checkbox
            SizedBox.fromSize(
              size: Size(20, 20),
              child: Checkbox(value: value, onChanged: onChanged),
            ),
            SizedBox(width: 8),
            Text(
              localizations.setAsDefault,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
