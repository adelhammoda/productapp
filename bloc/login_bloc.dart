import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:product_app/classes/authentication_validator.dart';
import 'package:product_app/server/authintication_api.dart';

class LoginBloc with Validator {
  String? _email;
  String? _password;
  bool _remember = false;
  final AuthenticationApi _authenticationApi;
  final FlutterSecureStorage _userAuthStorage = const FlutterSecureStorage();

  LoginBloc(this._authenticationApi) {
    _startLoginListen();
  }

  Stream<bool> get rememberMe => _rememberMe.stream;

  Stream<bool> get isEnabled => _enableButton.stream;

  Stream<String?> get email => _emailController.stream.transform(validateEmail);

  Stream<String?> get password =>
      _passwordController.stream.transform(validatePassword);

  //
  final StreamController<bool> _rememberMe = StreamController.broadcast();
  final StreamController<bool> _enableButton = StreamController.broadcast();
  final StreamController<String> _emailController =
      StreamController.broadcast();
  final StreamController<String> _passwordController =
      StreamController.broadcast();

  Sink<bool> get rememberMeSink => _rememberMe.sink;

  Sink<String> get addName => _emailController.sink;

  Sink<bool> get enable => _enableButton.sink;

  Sink<String> get addPassword => _passwordController.sink;

  Future<UserCredential>? login(bool create) {
    if (_email != null && _password != null) {
      if (_remember) {
        _userAuthStorage.write(key: 'name', value: _email);
        _userAuthStorage.write(key: 'password', value: _password);
      }
      return _login();
    }
    return null;
  }

  Future<UserCredential> _login() {
    return _authenticationApi.login(email: _email!, password: _password!);
  }
//to check if login button can be enabled or not.
  void checkIfCanBeEnabled() {
    if (_email != null && _password != null) {
      enable.add(true);
    }
  }

  void dispose(){
    _rememberMe.close();
    _emailController.close();
    _passwordController.close();
    _enableButton.close();
  }

  //listen to login page .
  void _startLoginListen() {
    email.listen((emailString) {
      _email = emailString;
      if (_password != null) {
        enable.add(true);
        print('true added');
      }
    }).onError((_) {
      enable.add(false);
      return _email = null;
    });
    password.listen((p) {
      _password = p;
      if (_email != null) {
        print('true added');
        enable.add(true);
      }
    }).onError((_) {
      enable.add(false);
      _password = null;
    });
    rememberMe.listen((bool remember) {
      if (remember) {
        _remember = true;
      } else {
        _remember = false;
        _userAuthStorage.deleteAll();
      }
    });
  }
}
