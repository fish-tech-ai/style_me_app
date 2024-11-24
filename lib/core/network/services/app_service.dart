
import 'package:chopper/chopper.dart';

part "app_service.chopper.dart";

@ChopperApi()
abstract class AppService extends ChopperService {
  static AppService create(ChopperClient client) =>
      _$AppService(client);
}