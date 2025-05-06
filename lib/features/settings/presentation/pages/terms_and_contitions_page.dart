import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';
import 'package:style_me/core/extensions/widget_ext.dart';
import 'package:style_me/core/lang/localizations_helper.dart';
import 'package:style_me/core/utils/constants.dart';
import 'package:style_me/core/views/app_top_bar.dart';

String _readFile(String path) {
  return File(path).readAsStringSync();
}

class TermsAndConditionsPage extends ConsumerStatefulWidget {
  final bool shouldShowBottomNavBar;

  const TermsAndConditionsPage({super.key, this.shouldShowBottomNavBar = true});

  @override
  ConsumerState<TermsAndConditionsPage> createState() =>
      _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState
    extends ConsumerState<TermsAndConditionsPage> {
  final IsolateManager<String, String> isolateManger =
      IsolateManager.create(_readFile);
  String _markdownData = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(appGlobalViewModelProvider.notifier)
          .setBottomNavBarVisibility(widget.shouldShowBottomNavBar);
    });
    loadMarkdown();
  }

  Future<void> loadMarkdown() async {
    final Directory cacheDir = await getTemporaryDirectory();
    final String filePath = "${cacheDir.path}/${CacheFileNames.termsOfUse}";

    final data = await isolateManger.compute(filePath);
    setState(() {
      _markdownData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTopBar(title: localizations.termsAndConditions),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: MarkdownWidget(data: _markdownData)
                .orLoading(_markdownData.isEmpty),
          ),
        ),
      ],
    ).orWrapWithSafeArea(!widget.shouldShowBottomNavBar);
  }
}
