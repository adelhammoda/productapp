import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/models/receipt.dart';
import 'package:product_app/server/database.dart';

class ReceiptDBApi extends DataBase_API {
  ReceiptDBApi() : super('/receipts');

  Future<Receipt?> createReceipt(Map<String, dynamic> data) =>
      createDocument(data)
          .then((DocumentReference? doc) => doc == null
              ? null
              : Receipt(
                  receiptID: doc.id,
                  customerID: data['customerID'],
                  products: data['products']))
          .catchError((e) => null);

  Future<List<Receipt>?> getAllReceipts() => getDocuments()
      .then((value) => value == null
          ? null
          : value.docs
              .map<Receipt>((QueryDocumentSnapshot e) =>
                  Receipt.fromJSON(e.data() as Map<String, dynamic>, e.id))
              .toList())
      .catchError((onError) => null);

  Future<bool> updateReceipt(Receipt newReceipt) =>
      update(newReceipt.receiptID, newReceipt.toJSON())
          .then((value) => true)
          .catchError((onError) => false);

  Future<Receipt?> getReceipt(String receiptID) => getDocument(receiptID)
      .then((data) => data == null ? null : Receipt.fromJSON(data, receiptID))
      .catchError((onError) => null);

  Future<bool> deleteReceipt(String receiptID) =>
      delete(receiptID).then((value) => true).catchError((onError) => false);


}
