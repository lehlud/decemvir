import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences _preferences;

Future<void> initPrefs() async {
  _preferences = await SharedPreferences.getInstance();
}

abstract class Prefs {
  Prefs._();

  static String? get defaultDB => _preferences.getString('defaultDB');
  static set defaultDB(String? db) {
    if (db == null) {
      _preferences.remove('defaultDB');
    } else {
      _preferences.setString('defaultDB', db);
    }
  }
}
