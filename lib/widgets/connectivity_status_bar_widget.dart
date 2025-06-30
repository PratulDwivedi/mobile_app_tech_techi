import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class ConnectivityStatusBarWidget extends StatefulWidget {
  const ConnectivityStatusBarWidget({super.key});

  @override
  _ConnectivityStatusBarStateWidget createState() =>
      _ConnectivityStatusBarStateWidget();
}

class _ConnectivityStatusBarStateWidget
    extends State<ConnectivityStatusBarWidget> {
  bool _isConnected = true;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> results;
    try {
      results = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status${e.toString()}');
      return;
    }
    if (!mounted) {
      return;
    }
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final isConnected = results.any((r) => r != ConnectivityResult.none);
    setState(() {
      _isConnected = isConnected;
    });
    print('Connectivity changed: $_isConnected');
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected
        ? const SizedBox.shrink()
        : Container(
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.all(4.0),
            child: const Text(
              'No internet connection',
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          );
  }
}
