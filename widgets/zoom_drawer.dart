import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/screens/add_product.dart';
import 'package:product_app/screens/history_page.dart';
import 'package:product_app/screens/casheir_page.dart';
import 'package:product_app/screens/repository_page.dart';
import 'package:product_app/screens/setting_page.dart';
import 'package:product_app/utils/my_icons_icons.dart';
import 'package:responsive_s/responsive_s.dart';

class ZoomDrawerWidget extends StatefulWidget {
  const ZoomDrawerWidget({Key? key}) : super(key: key);

  @override
  State<ZoomDrawerWidget> createState() => _ZoomDrawerWidgetState();
}

class _ZoomDrawerWidgetState extends State<ZoomDrawerWidget> {
  late Widget _homePage;

  @override
  void initState() {
    _homePage = const CashierPage();
    super.initState();
  }

  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    final bool rtl = SettingBlocProvider.of(context).isRTL;
    Responsive _responsive = Responsive(context);

    return ZoomDrawer(
      disableGesture: true,
      mainScreenScale: 0.5,
      clipMainScreen: true,
      duration: const Duration(milliseconds: 500),
      slideWidth: _responsive.responsiveWidth(forUnInitialDevices: 70),
      controller: _drawerController,
      openCurve: Curves.decelerate,
      style: DrawerStyle.Style1,
      backgroundColor: SettingBlocProvider.of(context).theme.accentColor,
      angle: -6,
      borderRadius: 15,
      closeCurve: Curves.easeInCirc,
      showShadow: true,
      isRtl: rtl,
      mainScreen: _homePage,
      menuScreen: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                        color: null,
                      ),
                      margin: EdgeInsets.only(
                          top: _responsive.responsiveHeight(
                              forUnInitialDevices: 5),
                          bottom: _responsive.responsiveHeight(
                              forUnInitialDevices: 5)),
                      currentAccountPicture: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuIbv-7JSgC23hcGq8qDRBpFzdMBEw8urHdQ&usqp=CAU'),
                      ),
                      accountName: Text(
                        //TODO:add user name.
                        'Adel',
                        style: TextStyle(
                          color:
                              SettingBlocProvider.of(context).theme.textColor,
                        ),
                      ),
                      accountEmail: Text(
                        //TODO:add user email.
                        'email.com',
                        style: TextStyle(
                          color:
                              SettingBlocProvider.of(context).theme.textColor,
                        ),
                      ),
                    )),
                buildListTile(MyIcons.cash_register, Colors.green, 'Cashier',
                    const CashierPage()),
                buildListTile(
                    MyIcons.add_box,
                    Colors.red,
                    'Add new Products',
                    const AddProduct(
                      add: true,
                    )),
                buildListTile(MyIcons.history, Colors.brown, 'History',
                    const HistoryPage()),
                buildListTile(
                    MyIcons.cog_outline, null, 'Setting', const SettingPage()),
                buildListTile(MyIcons.th_thumb_empty, Colors.lightBlue,
                    'Repository', const RepositoryPage()),
              ],
            ),
          ),
        ),
        backgroundColor: SettingBlocProvider.of(context).theme.focusColor,
      ),
    );
  }

  ListTileTheme buildListTile(
      IconData icon, Color? color, String title, Widget navigatorPage) {
    bool rtl = SettingBlocProvider.of(context).isRTL;
    return ListTileTheme(
      tileColor: SettingBlocProvider.of(context).theme.secondaryColor,
      selectedColor: SettingBlocProvider.of(context).theme.focusColor,
      child: ListTile(
        leading: rtl
            ? null
            : Icon(
                icon,
                color: color,
              ),
        title: Text(
          title,
          textAlign: rtl ? TextAlign.end : TextAlign.start,
        ),
        trailing: rtl ? Icon(icon) : null,
        onTap: () {
          _drawerController.close!.call();
          setState(() {
            _homePage = navigatorPage;
          });
        },
      ),
    );
  }
}
