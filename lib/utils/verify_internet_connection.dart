import 'package:data_connection_checker/data_connection_checker.dart';

class VerifyInternetConnection {
  static Future<bool> getStatus() async {
    var connectivityResult = await DataConnectionChecker().hasConnection;
    return connectivityResult;
  }
}
