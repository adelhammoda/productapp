



import 'package:flutter/material.dart';
import 'package:product_app/widgets/product_widget.dart';

class ProductTable extends StatefulWidget {
  final List<ProductWidget> products;
  const ProductTable({Key? key,required this.products}) : super(key: key);

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  @override
  Widget build(BuildContext context) {
    //TODO:compare your receipt with real receipt.
    return DataTable(

      headingRowColor: MaterialStateProperty.all(Colors.amber),
        columns: const[
      DataColumn(label: Text('name'),),
      DataColumn(label: Text('count')),
      DataColumn(label: Text('individual price')),
      DataColumn(label: Text('price')),

    ], rows: widget.products,);
  }

}
