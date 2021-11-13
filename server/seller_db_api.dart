import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/models/seller.dart';
import 'package:product_app/server/authintication_api.dart';

class SellerDBApi {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String _documentPath = "/seller/${AuthenticationApi.gitUserUid}";
  late final DocumentReference _documentReference;

  SellerDBApi() {
    _documentReference = _fireStore.doc(_documentPath);
  }

  Future<bool> createSeller(Seller seller) => _documentReference
      .set(seller.toJSON())
      .then((value) => true)
      .catchError((e) => false);

  Future<Seller?> getCurrentSeller() {
    return _documentReference.get().then((snapshot) async {
      return snapshot.data() == null
          ? null
          : Seller.fromJSON(snapshot.data() as Map<String, dynamic>);
    }).catchError((e) => null);
  }

  Future<bool> updateCurrentSeller(Seller seller) => _documentReference
      .update(seller.toJSON())
      .then((value) => true)
      .catchError((e) => false);

  Future<bool> deleteCurrentSeller() => _documentReference
      .delete()
      .then((value) => true)
      .catchError((e) => false);
}
