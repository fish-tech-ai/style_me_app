import 'package:flutter/material.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';

class SearchTextField extends StatefulWidget {
  final String text;
  final Function()? onSearchClicked;
  final Function(String) onTextChanged;

  const SearchTextField({
    super.key,
    required this.text,
    this.onSearchClicked,
    required this.onTextChanged,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
    focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant SearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text && widget.text.isEmpty) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.done,
        onChanged: widget.onTextChanged,
        onTap: () {
          widget.onSearchClicked?.call();
        },
        focusNode: focusNode,
        decoration: InputDecoration(
            suffixIcon: buildIconButton(),
            labelText: localizations.search,
            prefixIcon: Icon(
              Icons.search,
              color: context.colorScheme.primary,
            )),
      ),
    );
  }

  Widget buildIconButton() {
    return Container(
      height: 54,
      width: 54,
      decoration: BoxDecoration(
          borderRadius: GlobalUiConst.borderRadiusNormal,
          color: context.colorScheme.primary),
      child: IconButton(
        onPressed: () {
          focusNode.unfocus();
          widget.onTextChanged(controller.text);
        },
        icon: Icon(
          Icons.keyboard_arrow_right_rounded,
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
