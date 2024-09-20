// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'network_status.dart';
//
// class NetworkViewModel extends ChangeNotifier {
//   NetworkStatus _networkStatus = NetworkStatus.online;
//   final Connectivity _connectivity = Connectivity();
//
//   NetworkViewModel() {
//     _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.none) {
//         _networkStatus = NetworkStatus.offline;
//       } else {
//         _networkStatus = NetworkStatus.online;
//       }
//       notifyListeners();
//     });
//   }
//
//   NetworkStatus get networkStatus => _networkStatus;
// }
