import 'package:simple_connection_checker/simple_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoData extends NetworkInfo {
  @override
  Future<bool> get isConnected =>
      SimpleConnectionChecker.isConnectedToInternet();
}
