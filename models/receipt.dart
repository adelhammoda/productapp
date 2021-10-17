import 'package:product_app/models/customer.dart';
import 'package:product_app/models/product.dart';

class Receipt {
  final String? receiptID='';
  final Customer customer;
   double offer;
   List<Product> products;

  Receipt({
    required this.customer,
    required this.offer,
    required this.products,
  });





  String calculateTotalPrice(){
    double price=0;
    for (var product in products) {
      price+=product.price*product.count;
    }
    price=price-(price*offer/100);
    //TODO:add the type of payment.
    return price.toString()+' \$';
  }
}
