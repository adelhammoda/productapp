import 'package:product_app/utils/themes.dart';
import 'package:product_app/models/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  MyTheme theme = themes[0];
  bool isRTL = false;
  String language = 'EN';
  late final SharedPreferences _storage;

  //TODO:add the placeholder for product photo.

  Setting() {
    getStorage();
  }

  getStorage() async {
    _storage = await SharedPreferences.getInstance();
  }

  void getSavedData() {
    String _themeName = _storage.getString('theme') ?? '3';
    theme = themes.firstWhere((element) => element.name == _themeName);
  }

  Future changeTheme(String name) async {
    return _storage.setString('theme', name).then((value) {
      theme = themes.firstWhere((theme) => theme.name == name);
    });
  }

//used from provider
  bool compareTo(Setting anotherSetting) {
    if (theme.isEqualTo(anotherSetting.theme)) {
      return true;
    } else {
      return false;
    }
  }

//to take all parameters
  void copyWith() {}
}
