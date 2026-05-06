import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:register_offline/core/utils/app_theme.dart';

class ConnectivityWidget extends StatefulWidget {
  final Widget child;

  const ConnectivityWidget({super.key, required this.child});

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isConnected = true;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final connected = result != ConnectivityResult.none;
      if (_initialized && connected != _isConnected) {
        setState(() => _isConnected = connected);
        _showConnectivitySnackbar(connected);
      }
      _initialized = true;
      _isConnected = connected;
    });
  }

  void _showConnectivitySnackbar(bool isConnected) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              isConnected ? 'Koneksi internet tersambung' : 'Tidak ada koneksi internet',
            ),
          ],
        ),
        backgroundColor:
            isConnected ? AppTheme.successGreen : AppTheme.errorRed,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
