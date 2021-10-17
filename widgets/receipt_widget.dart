import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/classes/name_capitalization.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/models/receipt.dart';
import 'package:product_app/widgets/product_table.dart';
import 'package:product_app/widgets/product_widget.dart';
import 'package:responsive_s/responsive_s.dart';

class ReceiptWidget extends StatefulWidget {
  final Receipt receipt;
  final void Function()? onReceiptTaped;
  final bool visibility;

  const ReceiptWidget({
    this.visibility = true,
    Key? key,
    required this.receipt,
    this.onReceiptTaped,
  }) : super(key: key);

  @override
  _ReceiptWidgetState createState() => _ReceiptWidgetState();
}

class _ReceiptWidgetState extends State<ReceiptWidget>
    with SingleTickerProviderStateMixin {
  late Responsive _responsive;
  final GlobalKey _key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  double? _height;
  late final AnimationController _animationController;
  late  Animation<double> _animation;

  List<ProductWidget> _getProducts() {
    return widget.receipt.products
        .map((customerProd) => ProductWidget(customerProd as CustomerProduct))
        .toList();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation=Tween(
        begin: _height??1.0,
        end: 0.0
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    if (widget.visibility) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _height = _key.currentContext?.size?.height;
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive(context,removePadding:false);
    return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                _responsive.responsiveValue(forUnInitialDevices: 1.5)),
            child: ListTile(
              tileColor: SettingBlocProvider
                  .of(context)
                  .theme
                  .cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    _responsive.responsiveValue(forUnInitialDevices: 5)),
              ),
              onTap: () {
                widget.onReceiptTaped?.call();
                if (widget.visibility) {
                  _animationController.isCompleted?_animationController.reverse():_animationController.forward();
                }
              },
              isThreeLine: true,
              subtitle: Text(
                widget.receipt.customer.location,
                style: TextStyle(
                  fontSize:
                  _responsive.responsiveValue(forUnInitialDevices: 4),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  //TODO:add the country of payment.
                  Text(
                    widget.receipt.calculateTotalPrice(),
                    style: TextStyle(
                      fontSize:
                      _responsive.responsiveValue(forUnInitialDevices: 5),
                      color: SettingBlocProvider
                          .of(context)
                          .theme
                          .textColor,
                    ),
                  ),
                  Text(
                    widget.receipt.offer.toString() + ' %',
                    style: TextStyle(
                         color:widget.receipt.offer>0?Colors.red:null ,
                        fontSize: _responsive.responsiveValue(
                            forUnInitialDevices: 4)),
                  )
                ],
              ),
              title: Text(
                nameCapitalization(widget.receipt.customer.name),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: CircleAvatar(
                radius: _responsive.responsiveValue(forUnInitialDevices: 7),
                onBackgroundImageError: (image, stackTrack) =>
                    Image.asset('assets/images/placeholder.png'),
                backgroundImage:
                NetworkImage(widget.receipt.customer.imageURL ?? ''),
              ),
            ),
          ),
          Padding(
              key: _key,
              padding: EdgeInsets.only(
                  top: _responsive.responsiveValue(forUnInitialDevices: 1),
                  bottom: _responsive.responsiveValue(forUnInitialDevices: 5),
                  left: _responsive.responsiveValue(forUnInitialDevices: 0),
                  right: _responsive.responsiveValue(forUnInitialDevices: 0)),
              child: SizeTransition(
                sizeFactor:_animation,
                // visible: _switchVisible,
                // maintainAnimation: true,
                // maintainState: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ProductTable(

                    products: _getProducts(),
                  ),
                ),
              )),
        ]);
  }
}
