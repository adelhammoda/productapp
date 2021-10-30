import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/models/customer.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/models/receipt.dart';
import 'package:product_app/widgets/receipt_widget.dart';
import 'package:responsive_s/responsive_s.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late Responsive _responsive;
  OverlayEntry? _entry;
  OverlayState? _overlay;
  double _top = 0;
  double _widthOfSearchField = 0;
  final FocusNode _focusNode = FocusNode();
  bool isVisible=true;

  final ScrollController _scrollController=ScrollController();
  @override
  void initState() {
    ZoomDrawer.of(context)!.animationController!.addStatusListener((status) {
      if (!(_entry?.mounted ?? false) && status == AnimationStatus.dismissed) {
        _widthOfSearchField = 0;
        _showOverLay(context);
      } else {
        if ((_entry?.mounted ?? false) && status == AnimationStatus.forward) {
          _hideOverLay();
        }
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _showOverLay(context);
    });
    super.initState();
  }

  void _showOverLay(context) {
    _overlay = Overlay.of(context);
    _top = _responsive.responsiveHeight(forUnInitialDevices: 3);
    _entry = OverlayEntry(
        builder: (context) => AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              top: _top,
              left: _responsive.responsiveWidth(forUnInitialDevices: 100) -
                  _responsive.responsiveWidth(forUnInitialDevices: 60),
              width: _responsive.responsiveWidth(forUnInitialDevices: 60),
              child: Material(
                // elevation: 4,
                // shape: const CircleBorder(),
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                          margin: EdgeInsets.only(
                              right: _responsive.responsiveWidth(
                                  forUnInitialDevices: 6)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            focusNode: _focusNode,
                            onSubmitted: (text) {
                              _focusNode.unfocus();
                            },
                            style: TextStyle(
                              letterSpacing: 3,
                              color: SettingBlocProvider.of(context)
                                  .theme
                                  .textColor,
                            ),
                            decoration: InputDecoration.collapsed(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: SettingBlocProvider.of(context).theme.textColor
                                ),
                                filled: true,
                                fillColor: SettingBlocProvider.of(context)
                                    .theme
                                    .focusColor,
                                focusColor: Colors.red,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        _responsive.responsiveValue(
                                            forUnInitialDevices: 4)))),
                          ),
                          width: _widthOfSearchField,
                          duration: const Duration(milliseconds: 400)),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shadowColor: null,
                            splashFactory: null,
                            elevation: 0,
                            primary: SettingBlocProvider.of(context)
                                .theme
                                .appBarColor,
                            padding: EdgeInsets.all(_responsive.responsiveValue(
                                forUnInitialDevices: 2)),
                            shape: const CircleBorder(),
                            alignment: Alignment.center),
                        // splashColor: null,
                        // splashRadius: null,
                        // alignment: Alignment.center,
                        onPressed: () {
                          _focusNode.hasFocus
                              ? _focusNode.unfocus()
                              : _focusNode.requestFocus();
                          _toggleTop();
                          _overlay?.setState(() {});
                        },
                        child: const Icon(Icons.search)),
                  ],
                ),
              ),
            ));
    _overlay!.insert(_entry!);
  }

  void _hideOverLay() {
    _entry?.remove();
    _entry = null;
  }

  void _toggleTop() {
    _top = _top == _responsive.responsiveHeight(forUnInitialDevices: 3)
        ? _responsive.responsiveHeight(forUnInitialDevices: 5)
        : _responsive.responsiveHeight(forUnInitialDevices: 3);
    _widthOfSearchField = _widthOfSearchField == 300 ? 0 : 300;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text('History'),
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
          icon: const Icon(
            Icons.menu,
          ),
        ),
      ),
      //TODO:add date of receipt.
      body: ListView.builder(
        key: UniqueKey(),
        shrinkWrap: true,
        // controller: _scrollController,
          //TODO:Add length from list.
          itemCount: 2,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          itemBuilder: (context, index) => Column(
                children: [

                  DefaultTextStyle(
                    style: TextStyle(
                        fontSize:
                            _responsive.responsiveValue(forUnInitialDevices: 4),),
                    child: Padding(
                      padding:  EdgeInsets.all(_responsive.responsiveValue(forUnInitialDevices: 4)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:const [
                          Text(
                            '20/2/2020',
                          ),
                          Text(' 20:12 pm')
                        ],
                      ),
                    ),
                  ),
                  ReceiptWidget(
                    key: UniqueKey(),
                    visibility:true ,
                    receipt: Receipt(
                        offer: 0,
                        products: List.generate(
                            12,
                            (index) => CustomerProduct(
                              productID: '',
                                unit: '',
                                name: 'product',
                                individualPrice: 12,
                                type: 'type',
                                count: 2)),
                        customer: Customer(
                            installment: 12,customerId: '',receipts: [])),
                      onReceiptTaped:null,
                  ),
                ],
              )),
    );
  }
}
