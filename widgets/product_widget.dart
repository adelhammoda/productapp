import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';

class ProductWidget extends DataRow {

  final CustomerProduct _product;
//TODO:add price type like dollars or syrians ..etc.
  ProductWidget(this._product)
      : super(cells: [
    DataCell(Text(_product.name)),
    DataCell(Text(_product.count.toString())),
    DataCell(Text(_product.price.toString())),
    DataCell(Text('${_product.price * _product.count}')),
  ]);


  CustomerProduct get product=>_product;

}
