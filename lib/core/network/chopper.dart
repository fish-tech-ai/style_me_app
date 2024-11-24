import 'package:chopper/chopper.dart';
import 'package:style_me/core/network/services/app_service.dart';

class ChopperManager {
  static ChopperClient createClient() => ChopperClient(
    baseUrl: Uri.parse('http://localhost:8000'),
    services: [
      AppService.create(ChopperClient()),
    ],
    converter: JsonConverter(),
  );
}