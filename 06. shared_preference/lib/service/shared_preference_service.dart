import 'package:shared_preference/model/setting.dart';
import 'package:shared_preference/utils/page_size_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String keyNotification = "MYNOTIFICATION";
  static const String keyPageNumber = "MYITEM_PAGE_NUMBER";
  static const String keySignature = "MYSIGNATURE";

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _preferences.setBool(keyNotification, setting.notificationEnable);
      await _preferences.setInt(keyPageNumber, setting.pageNumber);
      await _preferences.setString(keySignature, setting.signature);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Setting getSettingValue() {
    return Setting(
      notificationEnable: _preferences.getBool(keyNotification) ?? true,
      pageNumber: _preferences.getInt(keyPageNumber) ?? defaultPageSizeNumbers,
      signature: _preferences.getString(keySignature) ?? "",
    );
  }
}
