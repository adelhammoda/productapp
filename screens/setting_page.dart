import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:product_app/bloc/authentication_bloc_provider.dart';
import 'package:product_app/bloc/login_bloc.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/models/theme.dart';
import 'package:product_app/utils/themes.dart';
import 'package:product_app/widgets/app_bar.dart';
import 'package:responsive_s/responsive_s.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late final List<Widget> _colors;
  late MyTheme _theme;
  late Responsive _responsive;
  late LoginBloc _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = AuthenticationBlocProvider.of(context).loginBloc;
  }

  @override
  void initState() {
    super.initState();
    _colors = themes
        .map((myTheme) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  SettingBlocProvider.of(context).changeTheme(myTheme.name);
                },
                child: CircleAvatar(
                  backgroundColor: myTheme.appBarColor,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 0.5,
                    child: CircleAvatar(
                      backgroundColor: myTheme.focusColor,
                    ),
                  ),
                ),
              ),
            ))
        .toList();

  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive(context);
    _theme = SettingBlocProvider.of(context).theme;
    return Scaffold(
      appBar: buildAppBar(context,
          title: 'Setting',
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              ZoomDrawer.of(context)?.toggle();
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _responsive.responsiveHeight(forUnInitialDevices: 5),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ExpansionTile(
                title: const Text('Theme'),
                backgroundColor: _theme.backGroundColor,
                collapsedTextColor: _theme.secondaryColor,
                collapsedIconColor: _theme.secondaryColor,
                collapsedBackgroundColor: _theme.cardColor,
                textColor: _theme.textColor,
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                    children: _colors,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: _responsive.responsiveValue(forUnInitialDevices: 4)),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          _responsive.responsiveValue(forUnInitialDevices: 4))),
                  tileColor: _theme.backGroundColor,
                  onTap: () {
                    _provider.singOut();
                  },
                  trailing: Icon(
                    Icons.logout,
                    color: _theme.iconColor,
                  ),
                  title: Text(
                    'Sign out',
                    style: TextStyle(color: _theme.iconColor),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
