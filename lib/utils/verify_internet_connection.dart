import 'package:connectivity/connectivity.dart';

class VerifyInternetConnection {
  static Future<bool> getStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if ((connectivityResult != ConnectivityResult.mobile) &&
        (connectivityResult != ConnectivityResult.wifi)) {
      return false;
    }
    return true;
  }
}
