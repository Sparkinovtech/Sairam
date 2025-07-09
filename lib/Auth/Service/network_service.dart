import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkServices {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  NetworkServices() {

    _connectivity.checkConnectivity().then((status) {
      _controller.add(_isConnected(status));
    }).catchError((error) {
      _controller.add(false);
    });

    // Real-time listener: also returns ConnectivityResult
    _connectivity.onConnectivityChanged.listen((status) {
      _controller.add(_isConnected(status));
    });
  }

  Stream<bool> get connectionStream => _controller.stream;


  bool _isConnected(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi);
  }

  void dispose() {
    _controller.close();
  }
}