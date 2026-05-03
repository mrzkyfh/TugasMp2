import 'package:shared_preferences/shared_preferences.dart';

const String TOKEN = 'token';
const String USER_ID = 'userID';
const String USERNAME = 'userName';


    class UserInfo {
        Future setToken(String value) async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            return prefs.setString(TOKEN, value);
        }

        Future<String?> getToken() async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            return prefs.getString(TOKEN);
        }

        Future setUserID(String value) async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            return prefs.setString(USER_ID, value);
        }

        Future<String?> getUserID() async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            return prefs.getString(USER_ID)?.toString();
        }

        Future setUserName(String value) async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            return prefs.setString(USERNAME, value);
        }

        Future<String> getUserName() async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            return prefs.getString(USERNAME).toString();
        }

        Future<void> logout() async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
        }

    }
