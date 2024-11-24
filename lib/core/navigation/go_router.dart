import 'package:go_router/go_router.dart';
import 'package:style_me/features/home/presentation/home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
  ],
);