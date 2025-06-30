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
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status${e.toString()}');
      return;
    }
    if (!mounted) {
      return;
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
    print('Connectivity changed: \\${_isConnected.toString()}');
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
