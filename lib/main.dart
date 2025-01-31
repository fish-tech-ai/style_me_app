import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/style_me_app.dart';
import 'package:style_me/core/utils/token_authenticator.dart';
import 'core/di/get_it.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetItManager.setupGetIt();
  await getIt.allReady();
  await dotenv.load(fileName: ".env");
  final isAuthenticated = await getIt<TokenAuthenticator>().authenticateUser();
  FlutterNativeSplash.remove();
  runApp(ProviderScope(child: StyleMeApp(isAuthenticated)));
}
