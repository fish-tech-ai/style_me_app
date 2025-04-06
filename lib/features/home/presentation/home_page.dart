import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:style_me/core/extensions/context_ext.dart';
import 'package:style_me/core/navigation/app_page.dart';
import 'package:style_me/core/views/app_top_bar.dart';
import 'package:style_me/core/views/buttons/floating/floating_add_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageWithFloatingAddButton(
      addClothingClicked: () {
        context.push(AppPage.clothingAdd.path);
      },
      addUserPhotoClicked: () {
        context.push(AppPage.userPhotoAdd.path);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTopBar(
            title: context.localizations.appName,
            hideBackButton: false,
          ),
        ],
      ),
    );
  }
}
