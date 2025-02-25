import 'package:chopper/chopper.dart';
import 'package:style_me/features/settings/data/models/report_request.dart';

part "app_service.chopper.dart";

@ChopperApi()
abstract class AppService extends ChopperService {
  @Post(path: '/report/add')
  Future<Response> addReport(@Body() ReportRequest request);

  static AppService create([ChopperClient? client]) => _$AppService(client);
}
