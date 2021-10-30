import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/models/customer.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/models/receipt.dart';
import 'package:product_app/widgets/app_bar.dart';
import 'package:product_app/widgets/product_table.dart';
import 'package:product_app/widgets/product_widget.dart';
import 'package:responsive_s/responsive_s.dart';

class AddReceipt extends StatefulWidget {
  const AddReceipt({Key? key}) : super(key: key);

  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  late Responsive _responsive;
  static List<ProductWidget> _products = [];
  final StreamController<ProductWidget> _streamController = StreamController();
  late final Stream<ProductWidget> _stream;
  String name = '';
  String location = '';

  @override
  void initState() {
    _stream = _streamController.stream;
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _products = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive(context);
    return Scaffold(
      persistentFooterButtons: [
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_responsive
                            .responsiveValue(forUnInitialDevices: 5))),
                    context: context,
                    builder: (context) => _buildSheetContent());
              },
              child: const Text('Add products')),
        )
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(Receipt(
              customer: Customer(
                customerId: '',
                  receipts: [],
                  installment: 0.0,),
              products: _products
                  .map((productWidget) => productWidget.product)
                  .toList(),
              offer: 0.0));
        },
        child: const Icon(Icons.done),
      ),
      appBar: buildAppBar(context, title: 'New Receipt'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (text) {
                  name = text;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  hintText: 'User Name',
                ),
              ),
              TextField(
                onChanged: (text) {
                  location = text;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.add_location_alt),
                  hintText: 'Location',
                ),
              ),
              SizedBox(
                height: _responsive.responsiveHeight(forUnInitialDevices: 3),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<ProductWidget>(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        //TODO:add id to the product.
                        if (_products.isNotEmpty) {
                          if (snapshot.data!.product.productID !=
                              _products.last.product.productID) {
                            _products.add(snapshot.data!);
                          }
                        } else {
                          _products.add(snapshot.data!);
                        }
                      }
                      if (_products.isEmpty) {
                        return const Text(
                            'No products to show.Start add some.');
                      }
                      return ProductTable(products: _products);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///
  ///
  ///
  ///
  ///
  Widget _buildSheetContent() => Column(
        children: [
          Padding(
            padding: EdgeInsets.all(
                _responsive.responsiveValue(forUnInitialDevices: 3)),
            child: SizedBox(
              height: _responsive.responsiveHeight(forUnInitialDevices: 5),
              child: TextField(
                style: TextStyle(
                  color: SettingBlocProvider.of(context).theme.textColor,
                ),
                maxLines: 1,
                decoration: InputDecoration(
                    label: const Text('Search'),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: SettingBlocProvider.of(context)
                                .theme
                                .cardColor),
                        borderRadius: BorderRadius.circular(_responsive
                            .responsiveValue(forUnInitialDevices: 5))),
                    icon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: SettingBlocProvider.of(context)
                                .theme
                                .cardColor),
                        borderRadius: BorderRadius.circular(_responsive
                            .responsiveValue(forUnInitialDevices: 5)))),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  //TODO:add the type from list.
                  List.generate(
                15,
                (index) => TypeWidget(),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) => ProductTile(
                        responsive: _responsive,
                        sink: _streamController.sink,
                      )))
        ],
      );
}

class TypeWidget extends StatelessWidget {
  TypeWidget({Key? key}) : super(key: key);
  late _BackGroundColor _backgroundColor;

  @override
  Widget build(BuildContext context) {
    _backgroundColor = _BackGroundColor(context, Colors.white);
    return Padding(
        padding: const EdgeInsets.all(3.0),
        child: ValueListenableBuilder<Color>(
            valueListenable: _backgroundColor,
            builder: (BuildContext context, Color value, Widget? child) {
              return Chip(
                backgroundColor: _backgroundColor.backGround,
                deleteIcon: const Icon(Icons.close),
                onDeleted: () {
                  _backgroundColor.toggleColor(context);
                },
                //TODO:add type from real type
                label: const Text('type'),
                elevation: 4,
              );
            }));
  }
}

class ProductTile extends StatelessWidget {
  final Sink<ProductWidget> sink;

  const ProductTile({Key? key, required this.responsive, required this.sink})
      : super(key: key);
  final Responsive responsive;

  static Future<String?> _countFunction(
      context, Responsive responsiveVa, double _count) async {
    TextEditingController _controller = TextEditingController();
    double maximumCount = _count;
    _controller.text = _count.toString();
    String? myString;
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          height: responsiveVa.responsiveHeight(forUnInitialDevices: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  validator: (String? text) {
                    if (text == null || text == '') {
                      myString = null;
                      return "This field can't be empty ";
                    }
                    double val = 0;
                    val = double.tryParse(text) ?? -1;
                    if (val == -1 || val < 0) {
                      myString = null;

                      return "Wrong input";
                    } else if (val > maximumCount) {
                      myString = null;

                      return "Can't enter value bigger than $maximumCount";
                    }
                    myString = text;
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: _controller,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(2),
                          minimumSize: Size(
                              responsiveVa.responsiveWidth(
                                  forUnInitialDevices: 3),
                              responsiveVa.responsiveHeight(
                                  forUnInitialDevices: 4))),
                      onPressed: () {
                        double v =
                            double.tryParse(_controller.value.text) ?? -1;
                        if (v == -1 || v >= maximumCount) {
                          return;
                        } else {
                          _controller.text = (++v).toString();
                        }
                      },
                      child: const Icon(Icons.add)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(2),
                          minimumSize: Size(
                              responsiveVa.responsiveWidth(
                                  forUnInitialDevices: 3),
                              responsiveVa.responsiveHeight(
                                  forUnInitialDevices: 4))),
                      onPressed: () {
                        double v =
                            double.tryParse(_controller.value.text) ?? -1;
                        if (v <= 0 || v > maximumCount) {
                          return;
                        } else {
                          _controller.text = (--v).toString();
                        }
                      },
                      child: const Icon(Icons.minimize)),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(myString);
                      },
                      child: const Text('done')),
                  SizedBox(
                    width: responsiveVa.responsiveWidth(forUnInitialDevices: 2),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: const Text('cancel')),
                  SizedBox(
                    width: responsiveVa.responsiveWidth(forUnInitialDevices: 2),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        double count = double.tryParse(
                await _countFunction(context, responsive, 12) ?? "0.0") ??
            0;
        if (count > 0) {
          sink.add(ProductWidget(CustomerProduct(
              productID: '1',
              unit: 'kilo',
              individualPrice: 100,
              type: 'American Typewriter,',
              name: 'Bodo Ornaments',
              count: count.toInt())));
        }
      },
      //TODO:add background image to circle avatar.
      leading: const CircleAvatar(),
      //TODO:add product name from DB.
      title: const Text('product name'),
      trailing: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'count:12',
            style: TextStyle(
                fontSize: responsive.responsiveValue(forUnInitialDevices: 5),
                color: SettingBlocProvider.of(context).theme.secondaryColor),
          ),
          const Text('300 \$')
        ],
      ),
      subtitle: const Text('location'),
    );
  }
}

class _BackGroundColor extends ValueNotifier<Color> {
  late Color backGround;

  _BackGroundColor(context, this.backGround) : super(backGround) {
    backGround = SettingBlocProvider.of(context).theme.cardColor;
  }

  void toggleColor(context) {
    backGround = backGround == SettingBlocProvider.of(context).theme.focusColor
        ? SettingBlocProvider.of(context).theme.cardColor
        : SettingBlocProvider.of(context).theme.focusColor;
    notifyListeners();
  }
}
