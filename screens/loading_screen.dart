import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_app/bloc/auth_bloc.dart';
import 'package:product_app/bloc/authentication_provider.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/classes/custom_page_route.dart';
import 'package:product_app/widgets/zoom_drawer.dart';
import 'package:rive/rive.dart';
import 'login_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late AuthenticationBloc _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _provider = AuthenticationProvider.of(context).authenticationBloc;
      Timer(const Duration(seconds: 3), () async {
        SettingBlocProvider.of(context).getSaveTheme();
        _provider.tryAutoSignIn().then((success) async {
          if (success) {
            _provider.authChanged.add(true);
            CustomPageRoute(child: Switcher(tidy: null));
          }
          else {
            _provider.authChanged.add(false);
           final tidy= await rootBundle
                .load('assets/rive/520-990-teddy-login-screen.riv')
                .catchError((onError) {
              _showError(onError);
            });
            CustomPageRoute(child: Switcher(tidy:tidy ,));
          }
        }).catchError((e)async{
          _provider.authChanged.add(false);
           _showError(e);
          final tidy= await rootBundle
              .load('assets/rive/520-990-teddy-login-screen.riv')
              .catchError((onError) {
            _showError(onError);
          });
           CustomPageRoute(child: Switcher(tidy:tidy ,));
        });
      });
    });
  }

  _showError(error) {
    ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(content: Text(error.toString()), actions: [
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
          ))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          Center(
            child: RiveAnimation.asset(
              'assets/rive/loader.riv',
              alignment: Alignment.center,
              animations: ['Animation 1'],
              fit: BoxFit.fill,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Loading...',
                style: TextStyle(color: Colors.black, fontSize: 25),
              ))
        ],
      ),
    );
  }
}

class Switcher extends StatelessWidget {
  final ByteData? tidy;
  late AuthenticationBloc _provider;

  Switcher({Key? key, required this.tidy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _provider = AuthenticationProvider.of(context).authenticationBloc;
    return StreamBuilder<bool>(
      stream: _provider.authChangedStream,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.data==true)
          return  ZoomDrawerWidget();
        else
          return LogIn(tidy: tidy!);
      },
    );
  }
}
