import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnectivity;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connectChecker;

  NetworkInfoImpl({required this.connectChecker});
  
  @override
  Future<bool> get isConnectivity =>connectChecker.hasInternetAccess;

  
}
