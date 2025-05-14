import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:style_me/features/home/presentation/state/home_state_holder.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeStateHolder> build() async {
    Future.delayed(Duration(seconds: 5));
    return HomeStateHolder();
  }
}
