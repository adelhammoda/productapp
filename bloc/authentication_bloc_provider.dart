import 'package:flutter/material.dart';
import 'package:product_app/bloc/authentication_bloc.dart';
import 'package:product_app/bloc/login_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc ;
  final LoginBloc loginBloc;

  const AuthenticationBlocProvider( {
    Key? key,
    required Widget child,
    required this.authenticationBloc,
    required this.loginBloc,
  }) : super(
    key: key,
    child: child
  );

  static AuthenticationBlocProvider of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>()!;
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) =>
      oldWidget.authenticationBloc != authenticationBloc;
}
