import 'dart:core';


abstract class Product {
  late final String id;
  late final String name;
  late double individualPrice;
  late final String unit;
  late final String type;
}

class RepositoryProduct implements Product {
  @override
  String id;

  @override
  double individualPrice;

  @override
  String name;

  @override
  String type;

  @override
  String unit;

  int count;
  final String imageURL;

  RepositoryProduct({
    required this.imageURL,
    required this.id,
    required this.individualPrice,
    this.count = 0,
    required this.type,
    required this.unit,
    required this.name,
  });

  factory RepositoryProduct.fromJSON(Map<String, dynamic> data,
      String productID) {
    return RepositoryProduct(
        imageURL: data['imageURL'],
        id: productID,
        individualPrice: data['price'],
        type: data['type'],
        unit: data['unit'],
        name: data['name'],
        count: data['count']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'imageURL': imageURL,
      'price': individualPrice,
      'type': type,
      'unit': unit,
      'name': name,
      'count': count
    };
  }
}

class CustomerProduct implements Product {
  @override
  String id;

  @override
  double individualPrice;

  @override
  String name;

  @override
  String type;

  @override
  String unit;

  int orderedCount = 0;

  CustomerProduct({
    required this.id,
    required this.name,
    required this.individualPrice,
    required this.unit,
    required this.type,
    this.orderedCount = 0
  });


  factory CustomerProduct.fromRepo(RepositoryProduct repoProduct, int count){
    return CustomerProduct(
        id: repoProduct.id,
        name: repoProduct.name,
        individualPrice: repoProduct.individualPrice,
        unit: repoProduct.unit,
        type: repoProduct.unit,
        orderedCount: count);
  }


}
