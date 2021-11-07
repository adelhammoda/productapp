


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
}
