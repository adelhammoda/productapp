


class Receipt {
  final String receiptID;
  final String customerID;
  double offer;
  List<Map<String,dynamic>> products;

  Receipt({
    required this.receiptID,
    required this.customerID,
    this.offer = 0,
    required this.products,
  });

  Map<String, dynamic> toJSON() =>
      {'costumerID': customerID, 'offer': offer, 'products': products};

  factory Receipt.fromJSON(Map<String, dynamic> data, String receiptID){
    return Receipt(
        receiptID: receiptID, customerID: data['customerID'], products: data['products']);
  }

  bool validateOffer(){
    if(offer>100||offer<0)
      return true;
    return false;
  }
//TODO:implement the logic of this function.
  // String calculateTotalPrice() {
  //
  //   double price = 0;
  //   for (var product in products) {
  //     price += product.individualPrice * product.count;
  //   }
  //   price = price - (price * offer / 100);
  //   //TODO:add the type of payment.
  //   return price.toString() + ' \$';
  // }
}
