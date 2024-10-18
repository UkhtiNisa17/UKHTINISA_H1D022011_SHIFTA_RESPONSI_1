import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  Future<void> setToken(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", value);
  }

  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token");
  }

  Future<void> setUserID(int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("userID", value);
  }

  Future<int?> getUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("userID");
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
