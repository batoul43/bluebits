import 'package:secure_shared_preferences/secure_shared_pref.dart';

class CachHelper {
  static void setvalue(String value, String key) async {
    var pref = await SecureSharedPref.getInstance();
    pref.putString(key, value, isEncrypted: true);
  }

  static Future<dynamic> getvalue(String key) async {
    var pref = await SecureSharedPref.getInstance();

    return pref.getString(key, isEncrypted: true);
  }
}
