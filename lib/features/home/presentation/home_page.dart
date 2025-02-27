import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/views/app_top_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTopBar(title: context.localizations.appName),
        Center(
          child: Column(
            children: [
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 18, bottom: 0),
          alignment: Alignment.bottomRight,
          child: Container(
            color: context.colorScheme.primary,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
