import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/style_me_app.dart';
import 'core/di/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetItManager.setupGetIt();
  await getIt.allReady();
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: StyleMeApp()));
}
