import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/presentation/app_view_model.dart';
import 'package:style_me/core/extensions/context_ext.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppViewModel appViewModel = ref.watch(appViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(context.localizations.appName)),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  appViewModel.saveTheme(Brightness.light);
                },
                child: Text("Change theme to light")),
            ElevatedButton(
                onPressed: () {
                  appViewModel.saveTheme(Brightness.dark);
                },
                child: Text("Change theme to dark"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
