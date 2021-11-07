import 'package:flutter/cupertino.dart';
import 'package:product_app/bloc/login_bloc.dart';

class LoginProvider extends InheritedWidget {
  final LoginBloc loginBloc;

  LoginProvider({
    Key? key,
    required this.loginBloc,
    required Widget child,
  }) : super(key: key, child: child);

  static LoginProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LoginProvider>()!;

  @override
  bool updateShouldNotify(LoginProvider oldWidget) =>
      loginBloc != oldWidget.loginBloc;
}
