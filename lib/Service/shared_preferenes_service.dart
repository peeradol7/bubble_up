import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenesService {
  final SharedPreferences _prefs;

  SharedPreferenesService(this._prefs);

  static Future<SharedPreferenesService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferenesService(prefs);
  }
}
