import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/models/receipt.dart';
import 'package:product_app/server/authintication_api.dart';
import 'package:product_app/server/database.dart';
import 'package:product_app/server/repo_db_api.dart';

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

  Future<List<Receipt>?> getReceipts({bool customerOnly = false}) =>
      getDocuments()
          .then((value) => value == null
              ? null
              : value.docs
                  .where((receipt) {
                    if (customerOnly) {
                      String customerId =
                          (receipt.data() as Map<String, dynamic>)['customerID'];
                      String? userId = AuthenticationApi.gitUserUid;
                      if (userId == null) throw 'some data is missing ';
                      return customerId.compareTo(userId) != 0;
                    } else
                      return true;
                  })
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

//TODO:test this function
  //TODO:discuss where this function must  be  :) ..
  Future<List<CustomerProduct>?> getReceiptProducts(Receipt receipt) async {
    RepositoryDBApi repo = RepositoryDBApi();
    List<CustomerProduct>? repoProducts = [];
    List<Map<String, dynamic>> products = receipt.products;
    products.forEach((map) async {
      RepositoryProduct? p = await repo.getProduct(map['productID']);
      if (p == null) {
        repoProducts = null;
        return;
      } else {
        repoProducts!.add(CustomerProduct.fromRepo(p, map['count']));
      }
    });
    return repoProducts;
  }
}
