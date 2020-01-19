import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_admin_two/event/events_model.dart';
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
  static List<EventModel> events;
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

  getAllEvents() async {
      await getEventsDBRef()
          .once()
          .then((snapshot) {
        if (snapshot.value.length != 0) {
          events = List();
          //print(snapshot.value);
          snapshot.value.forEach((key, value) {
            EventModel event = EventModel.fromMap(value);
            events.add(event);
          });
        }
      }).catchError((error) {
        logger.i(error);
      });
      return events;
  }

  addEvent(EventModel event,File image) async{
    String url = await uploadImageToStorage(event.uid,image);
    event.url=url;
    event.blurUrl = url;
    await getEventsDBRef().child(event.uid).set(event.toJson());
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

  uploadImageToStorage(String uid,File image) async{
    StorageReference ref = storageRef
        .ref()
        .child(StartupData.dbreference)
        .child("background")
        .child("eventBackground")
        .child("submissions")
        .child(uid);
    final StorageUploadTask uploadTask = ref.putFile(
      image,
      StorageMetadata(
        contentType: "image" + '/' + "jpeg",
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  saveEvent(EventModel model, File image)  async {
    if(image!=null){
      String url = await uploadImageToStorage(model.uid, image);
      model.url = url;
      model.blurUrl = url;
    }
    await getEventsDBRef().child(model.uid).set(model.toJson());
  }

  deleteEvent(String uid) async{
    await getEventsDBRef().child(uid).remove();
  }
}
