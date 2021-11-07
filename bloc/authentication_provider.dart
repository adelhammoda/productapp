import 'package:flutter/material.dart';
import 'package:product_app/bloc/auth_bloc.dart';

class AuthenticationProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  AuthenticationProvider({
    Key? key,
    required this.authenticationBloc,
    required Widget child,
  }) : super(key: key, child: child);

  static AuthenticationProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationProvider>( )!;
  }

  @override
  bool updateShouldNotify(AuthenticationProvider oldWidget) =>
      oldWidget.authenticationBloc.isAuth != authenticationBloc.isAuth;
}
