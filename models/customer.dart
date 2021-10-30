import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String customerId;
  double installment;
  List<DocumentReference> receipts;

  Customer(
      {required this.customerId,
      required this.installment,
      required this.receipts});

  factory Customer.fromJSON(Map<String, dynamic> data, String costumerID) {
    return Customer(
        customerId: costumerID,
        installment: data['installment'],
        receipts: data['receipts']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'installment': installment,
      'receipts': receipts,
    };
  }
}

