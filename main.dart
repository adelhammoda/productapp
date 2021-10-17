import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/widgets/zoom_drawer.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const SettingProvider(child: App());
  }
}




class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme =SettingBlocProvider.of(context).theme;
    return MaterialApp(
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

          bodyText1:TextStyle(color:  theme.textColor),
          bodyText2:TextStyle(color:  theme.textColor)
        ),
        splashColor: theme.secondaryColor,
        focusColor: theme.focusColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: theme.cursorColor,
        ),
        iconTheme: IconThemeData(
          color: theme.iconColor,
        )
      ),
      home:const ZoomDrawerWidget(),

    );
  }
}

