import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Connection with WidgetsBindingObserver {
  final StreamController<bool> _connectionStreamController =
      StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Stream<bool> get connectionStream => _connectionStreamController.stream;
  bool isConnected = true;
  int _refreshToken = 0;

  Connection() {
    WidgetsBinding.instance.addObserver(this);
    _monitorConnection();
  }

  void _monitorConnection() async {
    await refreshConnection();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((_) => refreshConnection());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshConnection();
    }
  }

  Future<void> refreshConnection() async {
    final refreshToken = ++_refreshToken;
    final connectivityResults = await Connectivity().checkConnectivity();
    final hasNetwork = connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );

    final hasInternet = hasNetwork && await _checkInternetConnection();

    if (refreshToken != _refreshToken) {
      return;
    }

    _updateConnectionStatus(hasInternet);
  }

  Future<bool> _checkInternetConnection() async {
    if (await InternetConnectionChecker.instance.hasConnection) {
      return true;
    }

    await Future.delayed(const Duration(milliseconds: 700));
    return InternetConnectionChecker.instance.hasConnection;
  }

  void _updateConnectionStatus(bool hasInternet) {
    isConnected = hasInternet;
    if (!_connectionStreamController.isClosed) {
      _connectionStreamController.add(hasInternet);
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    _connectionStreamController.close();
  }
}
