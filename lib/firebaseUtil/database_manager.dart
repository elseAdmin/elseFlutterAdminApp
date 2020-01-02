import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_admin_two/utils/app_startup_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class DatabaseManager {
  final logger = Logger();
  static Firestore store;
  DatabaseReference baseDatabase, eventDatabase, dealsDatabase;
  FirebaseStorage storageRef;
  Map<String, List> universeVsParticipatedEvents = HashMap();
  static Map activityTimelineMap;

  DatabaseManager() {
    if (storageRef == null) {
      storageRef = FirebaseStorage.instance;
    }
    if (store == null) {
      store = Firestore.instance;
    }
    if (baseDatabase == null) {
      baseDatabase =
          FirebaseDatabase.instance.reference().child(StartupData.dbreference);
    }
  }


  DatabaseReference getEventsDBRef() {
    return baseDatabase.child('eventStaticData');
  }

  DatabaseReference getDealsDBRef() {
    return baseDatabase.child('dealsStaticData');
  }

  DatabaseReference getShopsDBRef() {
    return baseDatabase.child('shopStaticData');
  }

  DatabaseReference getBaseDBRef() {
    return baseDatabase;
  }

  Firestore getStoreReference() {
    return store;
  }

  FirebaseStorage getStorageReference() {
    return storageRef;
  }
}
