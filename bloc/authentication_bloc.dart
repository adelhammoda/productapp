import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_app/classes/authentication_validator.dart';
import 'package:product_app/server/authintication_api.dart';

class AuthenticationBloc with Validator {
  final AuthenticationApi _authenticationApi;

  AuthenticationBloc(this._authenticationApi);

  Stream<User?> get userAuthentication => _authenticationApi.gitUserState;
}
