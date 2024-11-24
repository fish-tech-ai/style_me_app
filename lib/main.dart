import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/style_me_app.dart';
import 'core/dependency_injection/get_it.dart';

void main() async {
  GetItManager.setupGetIt();
  await getIt.allReady();

  runApp(const ProviderScope(child: StyleMeApp()));
}
