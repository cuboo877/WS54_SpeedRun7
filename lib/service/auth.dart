import 'package:ws54_flutter_speedrun7/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun7/service/sql_service.dart';

class Auth {
  static Future<bool> loginAuth(String account, String password) async {
    try {
      UserData result =
          await UserDAO.getUesrDataByAccountAndPassword(account, password);
      await SharedPref.setLoggedUserID(result.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasAccountBeenRegistered(String account) async {
    try {
      UserData result = await UserDAO.getUesrDataByAccount(account);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> registerAuth(UserData userData) async {
    await UserDAO.addUserData(userData);
    await SharedPref.setLoggedUserID(userData.id);
  }
}
