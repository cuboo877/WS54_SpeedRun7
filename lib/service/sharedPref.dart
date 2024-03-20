import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<String> getLoggedUserID() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("logged id") ?? "";
  }

  static Future<void> setLoggedUserID(String userID) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("logged id");
    pref.setString("logged id", userID);
  }

  static Future<void> removeLoggedUserID(String userID) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("logged id");
  }
}
