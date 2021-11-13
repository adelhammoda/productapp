import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/models/customer.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/models/receipt.dart';
import 'package:product_app/utils/my_icons_icons.dart';
import 'package:product_app/widgets/app_bar.dart';
import 'package:product_app/widgets/receipt_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  final PageController _controller = PageController(initialPage: 0);
  bool _showClearAll = true;
  OverlayState? lay;

  //to change the current page when navigation bar button is tapped.
  void _onNavigationBarTaped(int value) {
    _controller.animateToPage(value,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    setState(() {
      if (value == 1) {
        _showClearAll = false;
      } else {
        _showClearAll = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = SettingBlocProvider.of(context).theme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          buildPageView([]),
          buildPageView(List.generate(
              6,
              (index) => Receipt(
                  offer: 100,
                  customerID: '',
                  receiptID: '',
                  products: List.generate(
                      5,
                          (index) =>
                      {
                        '1':  CustomerProduct(
                            id: '1',
                            unit: '',
                            name: 'product name',
                            type: 'sapon',
                            individualPrice: 11000,orderedCount: 2)
                      })))),
          buildPageView(List.generate(
              1,
              (index) => Receipt(
                  offer: 100,
                  customerID: '',
                  receiptID: '',
                  products: List.generate(
                      5,
                      (index) =>
                      {
                          '1':  CustomerProduct(
                                id: '1',
                                unit: '',
                                name: 'product name',
                                type: 'sapon',
                                individualPrice: 11000,orderedCount: 2)
                          })))),
        ],
        // controller: ,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: _theme.canvasColor,
        onTap: _onNavigationBarTaped,
        items: [
          buildButtons(const Icon(Icons.done, color: Colors.green), 'Done',
              color: Colors.green),
          buildButtons(
            const Icon(MyIcons.hourglass, color: Colors.amber),
            'waiting',
            color: Colors.amber,
          ),
          buildButtons(
              const Icon(MyIcons.block, color: Colors.redAccent), 'Denied',
              color: Colors.redAccent),
        ],
      ),
      appBar: buildAppBar(context,
          title: 'Orders',
          action: [
            Visibility(
                visible: _showClearAll,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    //TODO:add the clear all logic here.
                  },
                  child: const Icon(Icons.clear_all),
                ))
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close))),
    );
  }

  Padding buildPageView(
    List<Receipt> receipt,
  ) {
    Offset _offset = const Offset(0, 0);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: receipt.isEmpty || receipt == []
          ? const Center(
              child: Text('No thing to show!.try add something'),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Listener(
                  onPointerDown: (PointerDownEvent event) {
                    _offset = event.position;
                  },
                  child: ReceiptWidget(
                      onReceiptTaped: () {
                        showMenu(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            context: context,
                            position: RelativeRect.fromLTRB(
                                _offset.dx, _offset.dy, _offset.dx, _offset.dy),
                            items: [
                              PopupMenuItem(
                                child:
                                    buildPopupMenuItem('Denied', Icons.close),
                                onTap: () {
                                  //TODO:add move to denied logic here.
                                },
                              ),
                              PopupMenuItem(
                                child: buildPopupMenuItem('Move to Cashier',
                                    Icons.move_to_inbox_sharp),
                                onTap: () {
                                  //TODO:add move to cashier here.
                                },
                              ),
                            ]);
                      },
                      receipt: Receipt(
                        offer: receipt[index].offer,
                        customerID: '1',
                        receiptID: '',
                        products: receipt[index].products,
                      )),
                );
              },
              itemCount: receipt.length,
            ),
    );
  }

  Row buildPopupMenuItem(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(text), Icon(icon)],
    );
  }

  Widget buildButtons(Widget icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            text,
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
