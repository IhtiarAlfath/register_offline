import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkServices {
  Future<bool> isConnected();
}

class NetworkServicesImpl implements NetworkServices {
  final Connectivity connectivity;

  NetworkServicesImpl({required this.connectivity});

  @override
  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
