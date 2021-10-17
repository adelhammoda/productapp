import 'package:product_app/utils/themes.dart';
import 'package:product_app/models/theme.dart';



class Setting {
  late MyTheme theme;
  bool isRTL = false;
  String language = 'EN';


  //TODO:add inistance of shared preferences.
  //TODO:add the placeholder for product photo.

  Setting() {
    theme = themes[0];
    //TODO:initial theme form shared preferences
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

