import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style_me/core/app/presentation/app_global_state_holder.dart';
import 'package:style_me/core/app/presentation/app_global_view_model.dart';

extension WidgetRefExt on WidgetRef {
  AppGlobalViewModel get globalViewModel =>
      read(appGlobalViewModelProvider.notifier);

  AppGlobalStateHolder get globalState => read(appGlobalViewModelProvider);
}
