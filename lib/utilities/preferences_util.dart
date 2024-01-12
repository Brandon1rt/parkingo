// preferences_util.dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setBoolValue(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('showOnboarding', value);
}

Future<bool?> getBoolValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('showOnboarding');
}
