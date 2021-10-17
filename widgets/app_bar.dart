import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

PreferredSizeWidget buildAppBar(BuildContext context,
    {required String title, List<Widget>? action, Widget? leading}) {
  Responsive _responsive = Responsive(context);
  return AppBar(
      leading: leading,
      title: Text(
        title,
        textAlign: TextAlign.end,
        style: TextStyle(
            fontSize: _responsive.responsiveValue(forUnInitialDevices: 8)),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                  _responsive.responsiveValue(forUnInitialDevices: 25)),
              bottomRight: Radius.circular(
                  _responsive.responsiveValue(forUnInitialDevices: 25)))),
      elevation: 10,
      bottom: PreferredSize(
        child: Container(),
        preferredSize: Size.fromHeight(
            _responsive.responsiveHeight(forUnInitialDevices: 8)),
      ),
      actions: action);
}
