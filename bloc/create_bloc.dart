import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/classes/authentication_validator.dart';
import 'package:product_app/models/seller.dart';
import 'package:product_app/server/authintication_api.dart';
import 'package:product_app/server/seller_db_api.dart';

class CreateBloc with Validator {
  String? _email;
  String? _password;
  bool? _isEmailVerification;
  bool _isConfirmed = false;
  final AuthenticationApi _authenticationApi;
  final SellerDBApi _sellerDBApi;

  CreateBloc(this._authenticationApi, this._sellerDBApi) {
    _startListen();
  }

  Future<bool?> createNewSeller(Seller seller) {
    if(AuthenticationApi.gitUserUid==null)
      return Future<bool?>(()=>null);
    return _sellerDBApi.createSeller(seller);
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _enableButton.close();
  }

  _startListen() {
    emailStream.listen((email) {
      if (email != null) {
        this._email = email;
      }
      _checkIfCanEnable();
    }).onError((error) => _email = null);
    passwordSteam.listen((password) {
      if (password != null) {
        this._password = password;
      }
      _checkIfCanEnable();
    }).onError((error) => _password = null);
  }

//to validate confirm password field.
  String? isConfirmedPassword(String? password, String? confirmPassword) {
    String? result;
    if (password == null || confirmPassword == null) {
      _isConfirmed = false;
      result = "you must fill this field like you filled password field";
    } else {
      if (password.compareTo(confirmPassword) != 0) {
        _isConfirmed = false;
        result = "the Password is not confirmed";
      } else {
        _isConfirmed = true;

        result = null;
      }
    }
    _checkIfCanEnable();
    return result;
  }

//to check if create button can be enabled or not.
  void _checkIfCanEnable() {
    if (_email != null && _password != null && _isConfirmed)
      enableSink.add(true);
    else
      enableSink.add(false);
  }

  final StreamController<String> _emailController =
      StreamController.broadcast();
  final StreamController<String> _passwordController =
      StreamController.broadcast();

  final StreamController<bool> _enableButton = StreamController();

  Stream<String?> get emailStream =>
      _emailController.stream.transform(validateEmail);

  Stream<bool> get enableStream => _enableButton.stream;

  Stream<String?> get passwordSteam =>
      _passwordController.stream.transform(validatePassword);

  Sink<bool> get enableSink => _enableButton.sink;

  Sink<String> get emailSink => _emailController.sink;

  Sink<String> get passwordSink => _passwordController.sink;

  Future<bool>? sendCodeToEmail() {
    if (_email != null && _password != null && _isConfirmed)
      return _authenticationApi.sendEmailOTP(_email!);
    return null;
  }

  bool validCode(String code) {
    bool result =
        _authenticationApi.verifyEmailOTP(email: _email!, userOtp: code);
    _isEmailVerification = result;
    return result;
  }

//to create new account.
  Future<UserCredential?>? createAccount() async {
    if (_email != null &&
        _password != null &&
        _isConfirmed &&
        _isEmailVerification == true) {
      return _authenticationApi.createUserWithEmailAndPassword(
          email: _email!, password: _password!);
    } else
      return null;
  }
}
