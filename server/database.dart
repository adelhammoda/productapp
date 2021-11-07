import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_app/server/authintication_api.dart';

abstract class DataBase {
  Future<DocumentReference> createDocument(Map<String, dynamic> data);

  Future<void> delete(String documentID);

  Future<void> update(String documentID, Map<String, dynamic> data);

  Future<Map<String, dynamic>?> getDocument(String documentID);

  Future<QuerySnapshot?> getDocuments();

  Stream<QuerySnapshot<Object?>?> getDocumentsAsStream();

  Stream<Map<String, dynamic>?> getDocumentAsStream(String documentID);
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

  @override
  Stream<Map<String,dynamic>> getDocumentAsStream(String documentID) {
    return _collectionReference
        .doc(documentID)
        .get()
        .asStream()
        .map<Map<String, dynamic>>(
            (DocumentSnapshot value) => value.data() as Map<String, dynamic>);
  }

  @override
  Stream<QuerySnapshot<Object?>?> getDocumentsAsStream() {
    return  _collectionReference
        .get()
        .asStream();

  }
}
