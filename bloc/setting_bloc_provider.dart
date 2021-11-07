import 'package:flutter/material.dart';
import 'package:product_app/models/seller.dart';
import 'package:product_app/models/setting.dart';
import 'package:product_app/models/theme.dart';


class SettingProvider extends StatefulWidget {
  final Widget child;

  const SettingProvider({Key? key, required this.child}) : super(key: key);

  @override
  _SettingProviderState createState() => _SettingProviderState();
}

class _SettingProviderState extends State<SettingProvider> {
  final Setting _setting = Setting();

  bool get isRTL => _setting.isRTL;

  MyTheme get theme => _setting.theme;

  void getSaveTheme(){
     _setting.getSavedData();
     setState(() {});
  }
  void changeTheme(String name) {
     _setting.changeTheme(name).then((value) {
       setState(() {});
     });
  }

  void updateSeller(Seller seller){
    _setting.seller=seller;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => SettingBlocProvider(
        child: widget.child,
        setting: _setting,
        state: this,
      );
}

class SettingBlocProvider extends InheritedWidget {
  final Setting setting;
  final _SettingProviderState state;

  const SettingBlocProvider({
    Key? key,
    required Widget child,
    required this.state,
    required this.setting,
  }) : super(child: child, key: key);

  static _SettingProviderState of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<SettingBlocProvider>(
              aspect: SettingBlocProvider))!
          .state;

  @override
  bool updateShouldNotify(SettingBlocProvider oldWidget) =>
  //TODO:compare between tow setting with theme and seller
      oldWidget.setting.compareTo(setting);
}
