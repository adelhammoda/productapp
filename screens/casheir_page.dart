import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/models/receipt.dart';
import 'package:product_app/models/theme.dart';
import 'package:product_app/screens/orders_page.dart';
import 'package:product_app/server/authintication_api.dart';
import 'package:product_app/utils/my_icons_icons.dart';
import 'package:product_app/widgets/app_bar.dart';
import 'package:product_app/widgets/receipt_widget.dart';
import 'package:responsive_s/responsive_s.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({Key? key}) : super(key: key);

  @override
  _CashierPageState createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage>
    with TickerProviderStateMixin {
  late Responsive _responsive;
  late final AnimationController _searchController;
  bool hide = true;
  bool _visible = false;
  late MyTheme _themeProvider;
  late Animation<Offset> _position;
  late final AnimationController _positionController;
  late final AnimationController _optionController;
  final FocusNode _searchFocus = FocusNode();
  late final Animation<Offset> _deleteAnimation;
  late final Animation<Offset> _printAnimation;
  late final Animation<Offset> _makeOfferAnimation;
  late final Animation<Offset> _sellAnimation;
  final ScrollController _listViewController = ScrollController();
  late List<Receipt> _receiptList;
  int? _pressedButtonIndex;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void dispose() {
    _optionController.removeListener(_opacityListener);
    _listViewController.removeListener(_scrollDirectionListener);
    _optionController.dispose();
    _searchController.dispose();
    _positionController.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _receiptList = List.generate(
      2,
          (index) =>
          Receipt(
            products: List.generate(
              12,
                  (index) =>
                  {'$index':CustomerProduct(name: 'product name',
                      type: 'type',
                      individualPrice: 12,
                      unit: 'kilo',
                      id: '1',
                      orderedCount: 2)},
            ), customerID: '1', receiptID: '',
          ));
      _optionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _deleteAnimation = Tween<Offset>(
      begin: const Offset(0, 0.0),
      end: const Offset(-0.08, -0.065),
    ).animate(
        CurvedAnimation(parent: _optionController, curve: Curves.easeInSine));
    _printAnimation = Tween<Offset>(
      begin: const Offset(0, 0.0),
      end: const Offset(-0.15, -0.01),
    ).animate(
        CurvedAnimation(parent: _optionController, curve: Curves.easeInSine));
    _makeOfferAnimation = Tween<Offset>(
      begin: const Offset(0, 0.0),
      end: const Offset(0.08, -0.065),
    ).animate(
        CurvedAnimation(parent: _optionController, curve: Curves.easeInSine));
    _sellAnimation = Tween<Offset>(
      begin: const Offset(0, 0.0),
      end: const Offset(0.15, -0.01),
    ).animate(
        CurvedAnimation(parent: _optionController, curve: Curves.easeInSine));
    _searchController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    );
    _positionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _position = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0, 4.0),
    ).animate(_positionController);
    _optionController.addListener(_opacityListener);
    _listViewController.addListener(_scrollDirectionListener);
    super.initState();
  }

  void _opacityListener() {
    setState(() {
      _visible = _optionController.value < 0.5 ? false : true;
    });
  }

  void _scrollDirectionListener() {
    _optionController.isAnimating || _optionController.isCompleted
        ? _optionController.reverse()
        : null;
    if (!_positionController.isAnimating) {
      if (_listViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _positionController.forward();
      } else {
        _positionController.reverse();
      }
    }
  }

  _addReceipt() async {
    var a = await FirebaseFirestore.instance.collection('/sellers');
    var b = a.doc(AuthenticationApi.gitUserUid);
    debugPrint('-----------------------${b.path}');
    b.set({
      'uid': AuthenticationApi.gitUserUid,
    }).then((value) async {
      var w = await FirebaseFirestore.instance.collection('${b.path}/repo');
      w.doc('JTQN1YluR6H0xm').get().then((value) => print(value.data()));
    });
    a.get().then((value) => print(value));

    // _optionController.isCompleted ? _optionController.reverse() : null;
    // Receipt? newReceipt = await Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => const AddReceipt()));
    // if (newReceipt != null) {
    //   _receiptList.insert(0, newReceipt);
    //   _listKey.currentState!.insertItem(0);
    // }
  }

  void _showOptionButton(int index) {
    if (!_searchController.isAnimating) {
      if (_optionController.isCompleted) {
        _optionController.reverse();
        _pressedButtonIndex = null;
      } else {
        _pressedButtonIndex = index;
        _optionController.forward();
      }
    }
  }

  void _makeOffer() async {
    if (_pressedButtonIndex != null) {
      String? _offerString;
      double? _offer = await showDialog(
          context: context,
          builder: (context) =>
              Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: (text) {
                        double? res = double.tryParse(text ?? '');
                        if (res == null) {
                          _offerString = '';
                          return 'This input is un correct';
                        } else {
                          _offerString = res.toString();
                        }
                      },
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        _offerString = text;
                      },
                      decoration: InputDecoration(
                          labelText: 'Offer',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: _responsive.responsiveValue(
                                  forUnInitialDevices: 4))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (_offerString != null) {
                                Navigator.of(context)
                                    .pop(double.tryParse(_offerString ?? ''));
                              }
                            },
                            child: const Text("Done")),
                        SizedBox(
                          width: _responsive.responsiveWidth(
                              forUnInitialDevices: 3),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"))
                      ],
                    )
                  ]),
                ),
              ));
      if (_offer == null) {
        return;
      } else {
        _receiptList[_pressedButtonIndex!].offer = _offer;
        setState(() {});
      }
    }
  }

  void _deleteReceipt() {
    if (_pressedButtonIndex != null && _listKey.currentState != null) {
      final temp = _receiptList.removeAt(_pressedButtonIndex!);
      _listKey.currentState!.removeItem(
          _pressedButtonIndex!,
              (context, animation) =>
              SizeTransition(
                sizeFactor: animation,
                child: ReceiptWidget(
                  key: UniqueKey(),
                  receipt: temp,
                ),
              ));
    }
    if (_receiptList.isEmpty) {
      _positionController.reverse();
    }
    _optionController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = SettingBlocProvider
        .of(context)
        .theme;
    _responsive = Responsive(context, removePadding: false);
    return Scaffold(
        floatingActionButton: SlideTransition(
          position: _position,
          child: FloatingActionButton(
            onPressed: _addReceipt,
            child: const Icon(Icons.add),
          ),
        ),
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context,
            title: 'Cashier',
            leading: Center(
              child: InkWell(
                onTap: () {
                  ZoomDrawer.of(context)!.toggle();
                },
                child: const Icon(Icons.menu),
              ),
            ),
            action: [
              Padding(
                padding: EdgeInsets.all(
                    _responsive.responsiveValue(forUnInitialDevices: 3)),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OrderPage()));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                          width: _responsive.responsiveWidth(
                              forUnInitialDevices: 15),
                          child: Image.asset('assets/images/order.png')),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                            radius: _responsive.responsiveValue(
                                forUnInitialDevices: 2),
                            //TODO:add Stream builder as the child of this widget.
                            child: const FittedBox(
                                fit: BoxFit.fill, child: Text('3'))),
                      )
                    ],
                  ),
                ),
              ),
            ]),
        body: Stack(
          children: [
            SizedBox(
                height: _responsive.responsiveHeight(forUnInitialDevices: 100),
                child: _receiptList.isEmpty
                    ? const Center(child: Text('No Receipts . start add one'))
                    : AnimatedList(
                  key: _listKey,
                  controller: _listViewController,
                  padding: EdgeInsets.only(
                    top: _responsive.responsiveHeight(
                        forUnInitialDevices: 18),
                  ),
                  physics: const BouncingScrollPhysics(),
                  //TODO:add item count from real length
                  initialItemCount: _receiptList.length,
                  itemBuilder: (context, index, animation) =>
                      SizeTransition(
                          sizeFactor: animation,
                          child: ReceiptWidget(
                            key: UniqueKey(),
                            onReceiptTaped: () =>
                                _showOptionButton(index),
                            receipt: _receiptList[index],
                          )),
                )),
            buildSearchButton(context),
            buildSlideTransition(
              onPressed: _deleteReceipt,
              tooltipMessage: 'delete',
              positionAnimation: _deleteAnimation,
              child: const Icon(MyIcons.trash),
            ),
            buildSlideTransition(
              tooltipMessage: 'print',
              positionAnimation: _printAnimation,
              child: const Icon(Icons.print),
            ),
            buildSlideTransition(
              onPressed: _makeOffer,
              tooltipMessage: 'offer',
              positionAnimation: _makeOfferAnimation,
              child: const Icon(MyIcons.tag),
            ),
            buildSlideTransition(
              tooltipMessage: 'sell',
              positionAnimation: _sellAnimation,
              child: const Icon(MyIcons.dollar),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                shape: const CircleBorder(),
                color: _themeProvider.cardColor,
                elevation: 10,
                child: SizedBox(
                  width: _responsive.responsiveWidth(forUnInitialDevices: 10),
                  height: _responsive.responsiveHeight(forUnInitialDevices: 5),
                ),
              ),
            ),
          ],
        ));
  }

  AnimatedContainer buildSearchButton(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height:
      _responsive.responsiveHeight(forUnInitialDevices: hide ? 15.3 : 24),
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                setState(() {
                  _optionController.isCompleted
                      ? _optionController.reverse()
                      : null;

                  !hide
                      ? FocusScope.of(context).unfocus()
                      : FocusScope.of(context).requestFocus(_searchFocus);
                  hide = !hide;
                  !hide ? _searchController.repeat() : _searchController.stop();
                });
              },
              child: SizedBox(
                width: _responsive.responsiveWidth(forUnInitialDevices: 11),
                child: Lottie.asset('assets/images/search.json',
                    controller: _searchController),
              )),
          SizedBox(
            width: _responsive.responsiveWidth(forUnInitialDevices: 5),
          ),
          SizedBox(
              width: _responsive.responsiveWidth(forUnInitialDevices: 60),
              height: _responsive.responsiveHeight(forUnInitialDevices: 5),
              child: TextField(
                focusNode: _searchFocus,
                style: TextStyle(color: _themeProvider.textColor),
                //TODO:add search function.
                onChanged: (searchResult) {},
                decoration: InputDecoration(
                    hintText: 'Enter customer name',
                    hintStyle: TextStyle(
                        color: _themeProvider.isLight
                            ? Colors.black
                            : Colors.white),
                    fillColor: _themeProvider.focusColor,
                    filled: true,
                    border: const UnderlineInputBorder(),
                    focusColor: _themeProvider.focusColor,
                    focusedBorder: const OutlineInputBorder()),
              ))
        ],
      ),
    );
  }

  Widget buildSlideTransition({required Animation<Offset> positionAnimation,
    required Widget child,
    required String tooltipMessage,
    void Function()? onPressed}) {
    //TODO: download icon from flutter icons website .
    return Visibility(
      visible: _visible,
      maintainState: true,
      maintainAnimation: true,
      child: SlideTransition(
        position: positionAnimation,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: IgnorePointer(
              ignoring: false,
              child: Tooltip(
                message: tooltipMessage,
                child: ElevatedButton(
                  //TODO:add the on pressed logic here.
                  onPressed: onPressed,
                  child: child,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(const CircleBorder())),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
