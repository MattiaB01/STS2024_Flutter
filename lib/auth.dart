import 'package:local_auth/local_auth.dart';

class Auth {
  static final _auth = LocalAuthentication();

  static Future<bool> can() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> auth() async {
    try {
      if (!await can()) return false;
      return await _auth.authenticate(
          localizedReason: 'Autenticati per proseguire');
    } catch (e) {
      print('errore $e');
      return false;
    }
  }
}
