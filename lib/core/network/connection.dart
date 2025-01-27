import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Connection {
  final StreamController<bool> _connectionStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionStreamController.stream;
  bool isConnected = true;

  Connection() {
    _monitorConnection();
  }

  void _monitorConnection() async {
    isConnected = await _checkInternetConnection();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      final bool hasInternet = await _checkInternetConnection();
      isConnected = hasInternet;
      _connectionStreamController.add(hasInternet);
    });
  }

  Future<bool> _checkInternetConnection() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }

  void dispose() {
    _connectionStreamController.close();
  }
}
