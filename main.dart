import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_app/bloc/authentication_bloc.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/screens/loading_screen.dart';

import 'bloc/authentication_bloc_provider.dart';
import 'bloc/login_bloc.dart';
import 'server/authintication_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp();
  runApp(const SettingProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = SettingBlocProvider.of(context).theme;
    return AuthenticationBlocProvider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Product app',
          theme: ThemeData(
              primarySwatch: theme.primaryColor,
              backgroundColor: theme.backGroundColor,
              canvasColor: theme.canvasColor,
              appBarTheme: AppBarTheme(
                //TODO:add font family from google font.
                color: theme.appBarColor,
              ),
              textTheme: TextTheme(
                  bodyText1: TextStyle(color: theme.textColor),
                  bodyText2: TextStyle(color: theme.textColor)),
              splashColor: theme.secondaryColor,
              focusColor: theme.focusColor,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: theme.cursorColor,
              ),
              iconTheme: IconThemeData(
                color: theme.iconColor,
              )),
          // home:const ZoomDrawerWidget(),
          home: const LoadingPage()),
      authenticationBloc: AuthenticationBloc(AuthenticationApi()),
      loginBloc: LoginBloc(AuthenticationApi()),
    );
  }
}
