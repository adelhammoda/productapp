import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_app/bloc/authentication_bloc.dart';
import 'package:product_app/bloc/authentication_bloc_provider.dart';
import 'package:product_app/bloc/login_bloc.dart';
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
  late LoginBloc _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _provider = AuthenticationBlocProvider.of(context).loginBloc;
      Timer(const Duration(seconds: 3), () async {
        SettingBlocProvider.of(context).getSaveTheme();
        await rootBundle
            .load('assets/rive/520-990-teddy-login-screen.riv')
            .then((tidy) {
          _provider
              .tryAutoSignIn()
              .then((success) =>
                  Navigator.of(context).pushReplacement(CustomPageRoute(
                      child: Switcher(
                    tidy: tidy,
                    successResult: success,
                  ))))
              .catchError((onError) {
            _showError(onError);
          });
        }).catchError((error) {
          _showError(error);
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
  final ByteData tidy;
  late AuthenticationBloc _provider;
  final bool successResult;
  Switcher({Key? key, required this.tidy, required this.successResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _provider = AuthenticationBlocProvider.of(context).authenticationBloc;
    return StreamBuilder<User?>(
      stream: _provider.userAuthentication,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (successResult) {
          return const ZoomDrawerWidget();
        }
        if (snapshot.data != null) {
          return const ZoomDrawerWidget();
        } else {
          return LogIn(tidy: tidy);
        }
      },
    );
  }
}
