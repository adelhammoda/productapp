import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:product_app/server/authintication_api.dart';

class AuthenticationBloc {
  FlutterSecureStorage _userAuthStorage = FlutterSecureStorage();
  bool? isAuth;
  final AuthenticationApi authenticationApi;
  final StreamController<bool> _authController = StreamController.broadcast();

  Sink<bool> get authChanged => _authController.sink;

  Stream<bool> get authChangedStream => _authController.stream;

  Future<bool> signOut() async {
    return authenticationApi.signOut().then((_) {
      this.isAuth = false;
      return true;
    }).catchError((e) => false);
  }

  AuthenticationBloc(this.authenticationApi) {
    _startListen();
  }

  Future<bool> tryAutoSignIn() async {
    String? _email = await _userAuthStorage.read(key: 'name');
    String? _password = await _userAuthStorage.read(key: 'password');
    print('email from storage is $_email pass: $_password');
    if (_email != null && _password != null) {
      return authenticationApi
          .login(email: _email, password: _password)
          .then((value) => true)
          .catchError((error) => false);
    } else {
      return false;
    }
  }

  void _startListen() {
    authChangedStream.listen((isAuth) {
      this.isAuth = isAuth;
    });
  }
}
