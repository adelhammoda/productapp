import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/server/database.dart';

class RepositoryDBApi extends DataBase_API {
  RepositoryDBApi() : super('/repo');

  Future<RepositoryProduct?> createProduct(Map<String, dynamic> data) {
    return createDocument(data)
        .then((DocumentReference? value) =>
            value == null ? null : RepositoryProduct.fromJSON(data, value.id))
        .catchError((error) => null);
  }

  Future<bool> deleteProduct(String productID) async {
    return await delete(productID)
        .then((value) => true)
        .catchError((e) => false);
  }

  Future<bool> updateProduct(
          String productID, RepositoryProduct newProduct) async =>
      update(productID, newProduct.toJSON())
          .then((value) => true)
          .catchError((onError) => false);

  Stream<List<RepositoryProduct>?> getAllProduct() => getDocumentsAsStream()
      .map((value) => value == null
          ? null
          : value.docs
              .map<RepositoryProduct>((e) => RepositoryProduct.fromJSON(
                  e.data() as Map<String, dynamic>, e.id))
              .toList())
      .handleError((onError) => null);

  Stream<List<RepositoryProduct>?> getProductWhere({
    required bool Function(RepositoryProduct product) where,
  }) =>
      getDocumentsAsStream()
          .map((value) => value == null
              ? null
              : value.docs
                  .map<RepositoryProduct>((e) => RepositoryProduct.fromJSON(
                      e.data() as Map<String, dynamic>, e.id))
                  .where(where)
                  .toList())
          .handleError((onError) => null);

  Future<RepositoryProduct?> getProduct(String productID) =>
      getDocument(productID)
          .then((data) =>
              data != null ? RepositoryProduct.fromJSON(data, productID) : null)
          .catchError((onError) => null);
}
