

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/bloc/authentication_provider.dart';
import 'package:product_app/bloc/login_bloc.dart';
import 'package:product_app/bloc/login_provider.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/models/theme.dart';
import 'package:product_app/utils/my_icons_icons.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:rive/rive.dart';

class LogIn extends StatefulWidget {
  final ByteData tidy;

  const LogIn({Key? key, required this.tidy}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  late Responsive _responsive;
  late MyTheme myTheme;

  ///for state machine
  SMIInput<bool>? _check;
  SMIBool? _handsUp;
  SMINumber? _checkNumber;
  SMITrigger? _fail, _success;
  Artboard? _artBoard;

  ///
  /// for text fields
  final FocusNode _emailFocus = FocusNode(),
      _passwordNode = FocusNode(),
      _confirmedPasswordNode = FocusNode();

  ///
  late final Animation<double> _animatedSize;
  late final AnimationController _sizeController;
  late LoginBloc _provider;
  bool isConfirmed = false,
      _dontShowPass = true,
      _hideConfirmField = true,
      _confirmedPassword = false,
      _loading = false;

  ///
  @override
  void didChangeDependencies() {
    _provider = LoginProvider.of(context).loginBloc;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});

    ///for animation
    _sizeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animatedSize = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _sizeController, curve: Curves.easeIn));

    ///for rive animation
    final file = RiveFile.import(widget.tidy);
    final artBoards = file.mainArtboard;
    var controller =
        StateMachineController.fromArtboard(artBoards, 'State Machine 1');
    if (controller != null) {
      artBoards.addController(controller);
      _check = controller.findInput('Check');
      _handsUp = controller.findInput<bool>('hands_up') as SMIBool;
      _checkNumber = controller.findSMI('Look') as SMINumber;
      _fail = controller.findSMI('fail') as SMITrigger;
      _success = controller.findSMI('success') as SMITrigger;
      _artBoard = artBoards;
      _check!.value = false;
    }

    ///some listener
    _animatedSize.addListener(() {
      if (!_sizeController.isAnimating) {
        setState(() {
          if (_sizeController.isCompleted) {
            _confirmedPassword = true;
          } else {
            _confirmedPassword = false;
          }
        });
      }
    });
    _emailFocus.addListener(() {
      _check!.value = _emailFocus.hasFocus;
    });
    _confirmedPasswordNode.addListener(() {
      _handsUp?.value = _confirmedPasswordNode.hasFocus;
    });
    _passwordNode.addListener(() {
      _handsUp?.value = _passwordNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordNode.dispose();
    _confirmedPasswordNode.dispose();
    _artBoard?.remove();
    super.dispose();
  }

  _startAuth() async {
    _passwordNode.hasFocus
        ? _passwordNode.unfocus()
        : _confirmedPasswordNode.hasFocus
            ? _confirmedPasswordNode.unfocus()
            : null;
    if (_confirmedPassword && isConfirmed) {
      setState(() {
        _loading = true;
      });
      await _provider.login(true)?.then((_) {
        //TODO:delete of this codes because its for testing only

      }).catchError((error) {
        setState(() {
          _loading = false;
        });
        _fail?.fire();
        _showAlert(error.code, true);
      });
    }
    if (!_confirmedPassword) {
      setState(() {
        _loading = true;
      });
      await _provider.login(false)?.catchError((error) {
        setState(() {
          _loading = false;
        });
        _fail?.fire();
        _showAlert(error.code, true);
      });
    }
  }

  void _showAlert(String error, bool code) {
    String errorMessage;
    switch (error) {
      case 'email-already-in-use':
        errorMessage = 'This name is already used by another user';
        break;
      case 'user-not-found':
        errorMessage = 'The name you enter is wrong';
        break;
      case 'too-many-requests':
        errorMessage =
            'you sent a lot of requests.pleas try again in another time';
        break;
      case 'wrong-password':
        errorMessage = 'Wrong password';
        break;
      default:
        errorMessage = code ? 'Some thing wrong' : error;
        break;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      elevation: 6,
      backgroundColor: SettingBlocProvider.of(context).theme.secondaryColor,
      content: Text(
        errorMessage,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: SettingBlocProvider.of(context).theme.focusColor,
            fontSize: _responsive.responsiveValue(forUnInitialDevices: 4)),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    myTheme = SettingBlocProvider.of(context).theme;
    _responsive = Responsive(context, removePadding: false);
    return Scaffold(
        floatingActionButton: StreamBuilder<bool>(
            stream: _provider.isEnabled,
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data == false) {
                return Container();
              }
              return FloatingActionButton(
                onPressed: _startAuth,
                child: const Icon(Icons.done),
              );
            }),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipOval(
                child: Stack(
              children: [
                Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    width: _responsive.responsiveWidth(forUnInitialDevices: 60),
                    height:
                        _responsive.responsiveHeight(forUnInitialDevices: 30),
                    child: _artBoard != null
                        ? Rive(
                            artboard: _artBoard!,
                            fit: BoxFit.fill,
                          )
                        : Container()),
                Positioned(
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height:
                        _responsive.responsiveHeight(forUnInitialDevices: 15),
                    width: _responsive.responsiveWidth(forUnInitialDevices: 20),
                    child: Visibility(
                        visible: _loading,
                        child: Lottie.asset('assets/lottie/loader.json',
                            animate: _loading)),
                  ),
                )
              ],
            )),
            SizedBox(
              height: _responsive.responsiveHeight(forUnInitialDevices: 1),
            ),
            StreamBuilder<String?>(
                stream: _provider.email,
                builder: (context, snapshot) {
                  return buildField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'This field is required';
                        } else if (snapshot.hasError) {
                          return snapshot.error as String;
                        }
                      },
                      // icon: MyIcons.mail_alt,
                      label: 'Your name',
                      focusNode: _emailFocus,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (text) {
                        _passwordNode.requestFocus();
                      },
                      onChange: (text) {
                        _checkNumber!.value = text.length.toDouble();
                        _provider.addName.add(text);
                      });
                }),
            const SizedBox(
              height: 4,
            ),
            StreamBuilder<String?>(
                stream: _provider.password,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return buildField(
                      trialling: GestureDetector(
                          onTap: () {
                            setState(() {
                              _dontShowPass = !_dontShowPass;
                            });
                          },
                          child: Icon(
                            !_dontShowPass ? MyIcons.eye : MyIcons.eye_slash,
                            color: Colors.black,
                          )),
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'This field is required';
                        } else if (snapshot.hasError) {
                          return snapshot.error as String;
                        }
                      },
                      obscureText: _dontShowPass,
                      // icon: MyIcons.key,
                      label: 'Password',
                      onChange: (password) {
                        _provider.addPassword.add(password);
                      },
                      focusNode: _passwordNode,
                      textInputAction: _sizeController.isCompleted
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onSubmitted: (text) {
                        _handsUp?.value = false;
                        _sizeController.isCompleted
                            ? _confirmedPasswordNode.requestFocus()
                            : _passwordNode.unfocus();
                      });
                }),
            const SizedBox(
              height: 4,
            ),
            SizeTransition(
              sizeFactor: _animatedSize,
              child: StreamBuilder<String?>(
                  stream: _provider.password,
                  builder: (context, snapshot) {
                    return buildField(
                      enabled: _confirmedPassword,
                      validator: (confirmedPassword) {
                        if (snapshot.data != null) {
                          if (confirmedPassword == null ||
                              confirmedPassword.isEmpty) {
                            isConfirmed = false;
                            _provider.enable.add(false);
                            return 'This field is required';
                          } else if (confirmedPassword
                                  .compareTo(snapshot.data!) !=
                              0) {
                            isConfirmed = false;
                            _provider.enable.add(false);
                            return 'Password is not combined';
                          } else {
                            _provider.enable.add(true);
                            isConfirmed = true;
                          }
                        }
                      },
                      label: 'Confirm password',
                      focusNode: _confirmedPasswordNode,
                      trialling: GestureDetector(
                          onTap: () {
                            setState(() {
                              _hideConfirmField = !_hideConfirmField;
                            });
                          },
                          child: Icon(
                            !_hideConfirmField
                                ? MyIcons.eye
                                : MyIcons.eye_slash,
                            color: myTheme.focusColor,
                          )),
                      obscureText: _hideConfirmField,
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(
                  _responsive.responsiveValue(forUnInitialDevices: 3)),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: _responsive.responsiveWidth(forUnInitialDevices: 60),
                  child: StreamBuilder<bool>(
                      stream: _provider.rememberMe,
                      initialData: false,
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        return CheckboxListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_responsive
                                    .responsiveValue(forUnInitialDevices: 4))),
                            activeColor: myTheme.textColor,
                            checkColor: myTheme.focusColor,
                            selected: snapshot.data ?? false,
                            title: const Text('Remember me'),
                            value: snapshot.data,
                            onChanged: (remember) {
                              _provider.rememberMeSink.add(remember ?? false);
                            });
                      }),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: _responsive.responsiveValue(forUnInitialDevices: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_confirmedPassword
                      ? 'Already have account'
                      : "Don't have account"),
                  TextButton(
                    onPressed: () {
                      if (_confirmedPassword) {
                        _sizeController.reverse();
                        _provider.checkIfCanBeEnabled();
                      } else {
                        _sizeController.forward();
                      }
                      //TODO:add create account logic here.
                    },
                    child: Text(
                      _confirmedPassword ? 'login' : 'Create one',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: myTheme.secondaryColor),
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  Align buildField(
      {required String label,
      bool enabled = true,
      FocusNode? focusNode,
      Function(String text)? onSubmitted,
      Function(String text)? onChange,
      String? Function(String? text)? validator,
      bool obscureText = false,
      TextInputType type = TextInputType.text,
      TextInputAction? textInputAction,
      Widget? trialling,
      IconData? icon}) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: _responsive.responsiveWidth(forUnInitialDevices: 95),
        child: TextFormField(
          enabled: enabled,
          textInputAction: textInputAction,
          autovalidateMode: AutovalidateMode.always,
          validator: validator,
          obscureText: obscureText,
          keyboardType: type,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
              suffix: trialling,
              errorStyle: TextStyle(
                  color: SettingBlocProvider.of(context).theme.secondaryColor),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelStyle: TextStyle(
                  height: 3,
                  color: myTheme.focusColor,
                  fontSize: _responsive.responsiveValue(forUnInitialDevices: 4),
                  fontWeight: FontWeight.w700),
              filled: true,
              fillColor: myTheme.cardColor,
              labelText: label,
              labelStyle: TextStyle(
                  letterSpacing: 3,
                  color: myTheme.focusColor,
                  height: 3,
                  fontSize: _responsive.responsiveValue(forUnInitialDevices: 3),
                  fontWeight: FontWeight.w800),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    _responsive.responsiveValue(forUnInitialDevices: 5)),
              )),
          focusNode: focusNode,
          onFieldSubmitted: onSubmitted,
          onChanged: onChange,
        ),
      ),
    );
  }
}
