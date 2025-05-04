import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScopedPage extends StatelessWidget {
  final Widget child;
  const ScopedPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: child);
  }
}
