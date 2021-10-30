import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/models/customer.dart';
import 'package:product_app/server/database.dart';

class CustomerDBApi extends DataBase_API {
  CustomerDBApi() : super('/costumer');

  Future<bool> updateCostumer(Customer customer) =>
      update(customer.customerId, customer.toJSON())
          .then((value) => true)
          .catchError((_) => false);

  Future<bool> deleteCostumer(String costumerID) =>
      delete(costumerID).then((_) => true).catchError((onError) => false);

//to add normal costumer to the firebase
  Future<Customer?> addCostumer(Map<String, dynamic> data) {
    return createDocument(data)
        .then((DocumentReference? costumerID) => costumerID == null
            ? null
            : Customer(
                receipts: data['receipts'],
                installment: data['installment'],
                customerId: costumerID.toString(),
              ))
        .catchError((onError) => null);
  }

//to git all costumers that users added.
  Future<List<Customer?>?> getAllCostumers() {
    return getDocuments().then((value) => value == null
        ? null
        : value.docs.map((val) {
            if (val.id != 'AnonymousCostumers')
              return Customer.fromJSON(
                  val.data() as Map<String, dynamic>, val.id);
          }).toList());
  }

  Future<Customer?> getCostumer(String id) => getDocument(id)
      .then((Map<String, dynamic>? data) =>
          data == null ? null : Customer.fromJSON(data, id))
      .catchError((onError) => null);

  Future<Map<String, dynamic>?> getCostumerInfo(String costumerID) {
    return FirebaseFirestore.instance
        .collection('costumers')
        .doc('$costumerID')
        .get()
        .then((value) {
      return value.data();
    }).catchError((_) => null);
  }

}
