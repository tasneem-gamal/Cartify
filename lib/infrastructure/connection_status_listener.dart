import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusListener {
  Future<void> internetListener(VoidCallback getData) async {
    Connectivity().onConnectivityChanged.listen((res) {
      getData();
    });
  }
}
