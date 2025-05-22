import 'package:flutter/material.dart';
import 'package:style_me/core/utils/constants.dart';

class AppStatus extends StatelessWidget {
  final Color color;
  final Widget child;
  final Widget endEdgeWidget;

  AppStatus.simple({
    super.key,
    required this.color,
    required String text,
    required IconData icon,
    Color? textColor,
  })  : child = Text(
          text,
          style: TextStyle(
              fontSize: 14,
              color: textColor,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        endEdgeWidget = Icon(icon, color: textColor);

  AppStatus.text({
    super.key,
    required this.color,
    required String text,
    required this.endEdgeWidget,
    Color? textColor,
  })  : child = Text(
    text,
    style: TextStyle(
        fontSize: 14,
        color: textColor,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none),
    softWrap: true,
    overflow: TextOverflow.visible,
  );

  const AppStatus({
    super.key,
    required this.color,
    required this.child,
    required this.endEdgeWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 44, maxHeight: 180),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: GlobalUiConst.borderRadiusSmall,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: child,
          ),
          endEdgeWidget
        ],
      ),
    );
  }
}
