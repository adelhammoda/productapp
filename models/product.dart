import 'dart:math';

abstract class Product {
  late final String id;
  late final String name;
  late final String type;
  late final double price;
  late int count = 0;
}

class CustomerProduct implements Product {
  @override
  int count;
  @override
  double price;
  @override
  String name;
  @override
  String type;

  int dozen = 0;

  CustomerProduct(
      {required this.name,
      required this.type,
      this.count = 0,
      required this.price}){
    id=Random.secure().nextInt(1000).toString();
  }

  //TODO:add dozen function.
  void dozenCount() {
    dozen = (count / 12).round();
  }

  @override
  late String id;
}

class RepositoryProduct implements Product {
  final String? productId = '';
  @override
  String name;

  @override
  double price;

  @override
  String type;

  @override
  late int count;

  final String imageURl;

  RepositoryProduct(
      {required this.imageURl,
      required int countInRepo,
      required this.name,
      required this.type,
      required this.price}) {
    count = countInRepo;
    id=Random.secure().nextInt(1000).toString();
  }

  @override
  late String id;

}
