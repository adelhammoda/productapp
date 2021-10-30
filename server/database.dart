import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/server/authintication_api.dart';

abstract class DataBase {
  Future<DocumentReference> createDocument(Map<String, dynamic> data);
  Future<void> delete(String documentID);
  Future<void> update(String documentID, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getDocument(String documentID);
  Future<QuerySnapshot?> getDocuments();
}

class DataBase_API implements DataBase {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String _collectionPath = "/seller/${AuthenticationApi().gitUserUid}";
  late final CollectionReference _collectionReference;
  DataBase_API(String path) {
    _collectionReference = _fireStore.collection(_collectionPath + path);
  }

  @override
  Future<DocumentReference> createDocument(Map<String, dynamic> data) {
    return _collectionReference.add(data);
  }

  @override
  Future<void> update(String documentID, Map<String, dynamic> data) {
    return _collectionReference.doc(documentID).update(data);
  }

  @override
  Future<void> delete(String documentID) {
    return _collectionReference.doc(documentID).delete();
  }

  @override
  Future<Map<String, dynamic>?> getDocument(String documentID) {
    return _collectionReference
        .doc(documentID)
        .get()
        .then<Map<String, dynamic>>(
            (DocumentSnapshot value) => value.data() as Map<String, dynamic>);
  }

  @override
  Future<QuerySnapshot?> getDocuments() {
    return _collectionReference.get();
  }
}
