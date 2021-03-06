import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:product_app/bloc/setting_bloc_provider.dart';
import 'package:product_app/models/product.dart';
import 'package:responsive_s/responsive_s.dart';

class RepositoryPage extends StatefulWidget {
  const RepositoryPage({Key? key}) : super(key: key);

  @override
  _RepositoryPageState createState() => _RepositoryPageState();
}

class _RepositoryPageState extends State<RepositoryPage>
    with SingleTickerProviderStateMixin {
  late Responsive _responsive;
  late Animation<double> _scroll;
  Timer? _forMoveToAnotherPage;
  late final AnimationController _scrollc;
  int _pageNumber = 0;
  double _degree = 0.0;
  final List<List<RepositoryProduct>> _listProducts = [
    [
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOHY3jxurAR-T99Bb-nZml8yWAPinhlP6UkA&usqp=CAU',
          count: 3,
          name: 'wine',
          type: 'drinks',
          individualPrice: 30,
          id: '',
          unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSt-s1zgy79AwadQ9NablfP5xZM8PTA29ApBA&usqp=CAU',
          count: 4,
          name: 'clop',
          type: 'electronics',
          individualPrice: 100, unit: '', id: '', ),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR49H97ZtmwJwBxZ2FjAuq0y2m84SFLTspdgA&usqp=CAU',
          count: 15,
          name: 'wristwatch',
          type: 'electronics',
          individualPrice: 57.20, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyGWiLqhA3UmX5ZcvEHjOyc0maWgzWhFIfbg&usqp=CAU',
          count: 150,
          name: 'shampoo',
          type: 'cleaning',
          individualPrice: 11.22,id: '',unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI6t5HV6PawgD6Sc017ccjZLm39JY19mFQFA&usqp=CAU',
          count: 5,
          name: 'charger',
          type: 'electronics',
          individualPrice: 32.78,
      unit: '',
      id: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUb1ADuhsC2l8Yf7mGtI49i5lfvSZm2BeIww&usqp=CAU',
          count: 10,
          name: 'Sun Classes',
          type: 'wears',
          individualPrice: 65.33, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEQWP5oJP7nRytBIbbxpmrHetm8pukOYuTgw&usqp=CAU',
          count: 1000,
          name: 'Shampoo',
          type: 'cleaning',
          individualPrice: 15.13, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBh3t9RH7X20oO6uhZPzAwVRxcKpnJEEMK2w&usqp=CAU',
          count: 10122,
          name: 'Spoon',
          type: 'cleaning',
          individualPrice: 15.13, id: '', unit: ''),
    ],
    [
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoemUxDZ8Y3SZ-wg6jBIqK7lX3LRqZbCaPzg&usqp=CAU',
          count: 3,
          name: 'Shoes',
          type: 'Clothes',
          individualPrice: 40, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtw-AIXKWvZW0KziSqb5FePpimzDgsnXW57g&usqp=CAU',
          count: 2,
          name: 'Camera',
          type: 'electronics',
          individualPrice: 100, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanCFp_9pTfwIUe0RdbwdiJNbAY1D21Wo98Q&usqp=CAU',
          count: 10,
          name: 'Leather bag',
          type: 'Woman wear',
          individualPrice: 55.3, id: '', unit: ''),
    ],
    [
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpdZjoJAVZkFD_CxJnJ1bEeEtNZsw9WQQhDg&usqp=CAU',
          count: 1,
          name: 'Phone',
          type: 'electronics',
          individualPrice: 357.20, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSv0DwgNYlj4xvYJtaTOBUxtJ8LLNLyVfvKBw&usqp=CAU',
          count: 150,
          name: 'BackBag',
          type: 'Wear',
          individualPrice: 17.22, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwxupSYkEmuwMdvMuwGLTx_U74QI961unrSQ&usqp=CAU',
          count: 15,
          name: 'Football',
          type: 'Game',
          individualPrice: 32.78, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_T66ivOhI09Ym9lgm8MD5F2LUTWTbsE5cWA&usqp=CAU',
          count: 10,
          name: 'Headphone',
          type: 'Electronic',
          individualPrice: 62.13, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqyBqGq5u6TBGBBITV3w6mg-oVpjH0njBDCQ&usqp=CAU',
          count: 10,
          name: 'Mouse',
          type: 'Electronic',
          individualPrice: 25.25, id: '', unit: ''),
      RepositoryProduct(
          imageURL:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb5baL-9dld5POsD5VF8g-zxxR-GigU5Lmng&usqp=CAU',
          count: 10122,
          name: 'wristwatch',
          type: 'Wear',
          individualPrice: 44.13, id: '', unit: ''),
    ]
  ];
  bool _lock = false;
  double sign = 1;

  @override
  void initState() {
    _scrollc = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scroll = Tween(begin: 0.0, end: 180.0)
        .animate(CurvedAnimation(parent: _scrollc, curve: Curves.easeOutBack));
    // _scrollc.addListener(_listen);
    super.initState();
    _scrollc.addStatusListener((status) {
      print(status);
      if (status == AnimationStatus.forward) {
        _forMoveToAnotherPage = Timer(const Duration(milliseconds: 300), () {
          _increment();
        });
      }
      if (status == AnimationStatus.dismissed) {
        _forMoveToAnotherPage = Timer(const Duration(milliseconds: 300), () {
          _decrement();
        });
      }
    });
  }

  void _listen() {
    _degree = _scroll.value;
    // if (_scroll.value > 90) {
    //   sign < 0 ? _increment() : _decrement();
    // }
  }

  void _onSwipeEnd(DragEndDetails dragEnd) {
    // if (!_scrollc.isAnimating) {

    double start = 0;
    if (_pageNumber == 0 && sign == 1) {
      _lock = false;
      start = 190;
    } else if (_pageNumber == _listProducts.length - 1 && sign == -1) {
      _lock = false;
      start = 185;
    }
    _scroll = Tween(begin: start, end: 180.0)
        .animate(CurvedAnimation(parent: _scrollc, curve: Curves.easeOutBack));
    _scrollc.reset();
    sign > 0 ? _scrollc.forward() : _scrollc.reverse();
    // }
  }

  void _increment() {
    if (_pageNumber < _listProducts.length - 1) {
      _pageNumber++;
    }
    // _lock = false;
  }

  void _decrement() {
    if (_pageNumber > 0) {
      _pageNumber--;
    }
    // _lock = false;
  }

  @override
  void dispose() {
    // _scrollc.removeListener(_listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _responsive = Responsive(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //TODO:add new product here.
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                //TODO:show the search app bar on pressed and add the search logic.
              },
              icon: const Icon(Icons.search))
        ],
        title: const Text('Repository'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: _responsive.responsiveWidth(forUnInitialDevices: 5),
            horizontal: 8),
        child: GestureDetector(
          // onVerticalDragStart: (dragStart) {
          //           //
          //           //   // if (!_scrollc.isAnimating) {
          //           //   // if (_pageNumber == 0 && sign == 1) {
          //           //   //   _lock = false;
          //           //   // } else if ((_pageNumber == _listProducts.length - 1) &&
          //           //   //     sign == -1) {
          //           //   //   _lock = false;
          //           //   // } else {
          //           //     _lock = true;
          //           //     // }
          //           //   // }
          //           //   // debugPrint('sign in start drag/// $sign');
          //           // },
          onVerticalDragUpdate: (DragUpdateDetails dragDawn) {
            sign = dragDawn.delta.dy > 0 ? 1 : -1;
          },
          onVerticalDragEnd: _onSwipeEnd,
          child: AnimatedBuilder(
            animation: _scroll,
            builder: (context, _) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_degree / 180 * sign * pi),
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationX(_degree <= 270 && _degree >= 90 ? pi : 0),
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: _responsive.responsiveHeight(
                            forUnInitialDevices: 5),
                        mainAxisExtent: _responsive.responsiveWidth(
                            forUnInitialDevices: 70),
                        mainAxisSpacing: _responsive.responsiveWidth(
                            forUnInitialDevices: 6)),
                    scrollDirection: Axis.horizontal,
                    itemCount: _listProducts[_pageNumber].length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(
                          index, _listProducts[_pageNumber]);
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

//for  product card
  Column _buildProductCard(
      int index, List<RepositoryProduct> _repositoryProduct) {
    return Column(
      children: [
        SizedBox(
          height: _responsive.responsiveHeight(forUnInitialDevices: 30),
          child: Stack(
            alignment: Alignment.bottomLeft,
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.all(5),
                ),
              ),
              ClipPath(
                clipper: MyCustomClipper(_responsive),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GestureDetector(
                          onTap: () {
                            //TODO:open current product in new page.
                          },
                          //TODO:change the tag of this hero.
                          child: Hero(
                              transitionOnUserGestures: true,
                              tag: _repositoryProduct[index].imageURL,
                              child: Placeholder()))),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _repositoryProduct[index].name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: _responsive.responsiveValue(
                                forUnInitialDevices: 5)),
                      ),
                      Text(
                        _repositoryProduct[index].type,
                        style: TextStyle(
                            fontSize: _responsive.responsiveValue(
                                forUnInitialDevices: 4)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(
                    style: TextStyle(
                        //TODO:check if the amount is in danger range then return red color instead.
                        color: SettingBlocProvider.of(context).theme.textColor,
                        fontSize: _responsive.responsiveValue(
                            forUnInitialDevices: 6)),
                    children: [
                  TextSpan(text: '${_repositoryProduct[index].count} '),
                  const TextSpan(
                    text: ' letter',
                  )
                ])),
            Text(
              '${_repositoryProduct[index].individualPrice} \$',
              style: TextStyle(
                  fontSize:
                      _responsive.responsiveValue(forUnInitialDevices: 5)),
            )
          ],
        )
      ],
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final Responsive _responsive;

  const MyCustomClipper(this._responsive);

  @override
  Path getClip(Size size) {
    final height =
        size.height - _responsive.responsiveHeight(forUnInitialDevices: 8.6);
    Path _path = Path();

    List<Offset> points = [
      const Offset(0, 0),
      Offset(0, height),
      Offset(size.width * 65 / 100, height),
      Offset(size.width * 73 / 100, size.height - 30),
      Offset(size.width * 73 / 100, size.height),
      Offset(size.width, size.height),
      Offset(size.width, 0),
    ];
    _path.addPolygon(points, true);

    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
