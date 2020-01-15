import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'database_manager.dart';

class FireBaseApi{
  DatabaseManager databaseManager = DatabaseManager();
  final String path;
  DatabaseReference ref;
  DataSnapshot snapshot;

  FireBaseApi( this.path ) {
    final DatabaseReference _db = databaseManager.getBaseDBRef();
    ref = _db.child(path);
  }

  Future<DataSnapshot> getDataSnapshot() {
    return ref.once() ;
  }
  Stream streamDataStream() {
    return ref.onValue ;
  }
  Future<void> removeSnapshot(String id){
    return ref.child(id).remove();
  }
  Future<DocumentReference> setDocument(Map data) {
    return ref.set(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return ref.child(id).update(data);
  }

  DatabaseReference getReference(){
    return ref;
  }


}
