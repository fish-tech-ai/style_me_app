import 'package:flutter/material.dart';
import 'package:style_me/core/views/buttons/app_back_button.dart';

class AppTopBar extends StatelessWidget {
  final String? title;
  final Function()? onBackButtonClicked;
  final Widget? rightCornerChild;

  const AppTopBar(
      {super.key, this.title, this.onBackButtonClicked, this.rightCornerChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBackButton(onTap: onBackButtonClicked),
          Text(
            title ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          rightCornerChild ?? SizedBox(width: 48)
        ],
      ),
    );
  }
}
