import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_admin_two/event/events_model.dart';
import 'package:else_admin_two/event/online_submission_model.dart';
import 'package:else_admin_two/feedback/feedback_model.dart';
import 'package:else_admin_two/requests/models/request_model.dart';
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
  static List<OnlineEventSubmissionModel> submissions;
  static Function(List<OnlineEventSubmissionModel>) submissionsFound;

  static List<OnlineEventSubmissionModel> approvedSubmissions;
  static Function(List<OnlineEventSubmissionModel>) approvedSubmissionsFound;

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

  getCounts(Function(Map) callback) async {
    Map<String, int> counts = HashMap();
    await store
        .collection(StartupData.dbreference)
        .document('feedback')
        .get()
        .then((snapshot) {
      counts.putIfAbsent('feedback', () => snapshot.data['count']);
    });
    await store
        .collection(StartupData.dbreference)
        .document('requests')
        .get()
        .then((snapshot) {
      counts.putIfAbsent('request', () => snapshot.data['count']);
    });
    return callback(counts);
  }

  getFewRequests(Function(List<Request>) callback) async {
    List<Request> requests = List();
    await store
        .collection(StartupData.dbreference)
        .document('requests')
        .collection('allRequests')
        .orderBy('timestamp', descending: true)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((request) {
        requests.add(Request.fromMap(request.data, request.documentID));
      });
    });
    return callback(requests);
  }

  getAllEvents(Function(List) callback) async {
    await getEventsDBRef().once().then((snapshot) {
      if (snapshot.value.length != 0) {
        events = List();
        snapshot.value.forEach((key, value) {
          EventModel event = EventModel.fromMap(value);
          events.add(event);
        });
      }
    }).catchError((error) {
      logger.i(error);
    });
    for (int i = 0; i < events.length; i++) {
      await store
          .collection(StartupData.dbreference)
          .document('events')
          .collection(events[i].uid)
          .document('submissions')
          .get()
          .then((snapshot) {
        events[i].submissionCount = snapshot.data['count'];
      });
    }
    return callback(events);
  }

  getFootfall(int major, int minor) async {
    Set users = HashSet();
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("monitoring")
        .document(major.toString())
        .collection(minor.toString())
        .where('timestamp',
        isGreaterThanOrEqualTo:
        DateTime
            .now()
            .millisecondsSinceEpoch - (24 * 60 * 60 * 1000))
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((visit) {
        users.add(visit.data['userUid']);
      });
    });
    return users.length;
  }

  addEvent(EventModel event, File image) async {
    String url = await uploadImageToStorage(event.uid, image);
    event.url = url;
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

  uploadImageToStorage(String uid, File image) async {
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

  saveEvent(EventModel model, File image) async {
    if (image != null) {
      String url = await uploadImageToStorage(model.uid, image);
      model.url = url;
      model.blurUrl = url;
    }
    await getEventsDBRef().child(model.uid).set(model.toJson());
  }

  deleteEvent(String uid) async {
    await getEventsDBRef().child(uid).remove();
  }

  getSubmissionForEvent(String uid) async {
    submissions = List();
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(uid)
        .document("submissions")
        .collection("allSubmissions")
        .orderBy('participatedAt', descending: true)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        submissions.add(OnlineEventSubmissionModel(doc));
      });
    });
    return submissionsFound(submissions);
  }

  getApprovedSubmissionForEvent(String uid) async {
    approvedSubmissions = List();
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(uid)
        .document("submissions")
        .collection("allSubmissions")
        .where('status', isEqualTo: 'Approved')
        .orderBy('participatedAt', descending: true)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        approvedSubmissions.add(OnlineEventSubmissionModel(doc));
      });
    });
    return approvedSubmissionsFound(approvedSubmissions);
  }

  updateSubmissionStatus(String status, String userId, String eventUid) async {
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(eventUid)
        .document("submissions")
        .collection("allSubmissions")
        .document(userId)
        .updateData({'status': status});
  }

  markSubmissionWinner(OnlineEventSubmissionModel model, String uid) async {
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(uid)
        .document("submissions")
        .collection("winnerSubmission")
        .add({
      'userUid': model.userUid,
      'imageUrl': model.imageUrl,
      'participatedAt': model.participatedAt,
      'markedWinnerAt': DateTime
          .now()
          .millisecondsSinceEpoch
    });
  }

  getAllFeedbacks(Function(List<FeedBack> feedbacks) feedbackFetched) async {
    List<FeedBack> feedbacks = List();
    await store
        .collection(StartupData.dbreference)
        .document("feedback")
        .collection("allfeedbacks")
        .orderBy('createdDate', descending: true)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        feedbacks.add(FeedBack.fromMap(doc.data, doc.documentID));
      });
    });
    return feedbackFetched(feedbacks);
  }

  updateFeedbackStatus(String id, String statusValue) async {
    await store.collection(StartupData.dbreference).document('feedback').collection('allfeedbacks').document(id).updateData({
      'feedbackStatus':statusValue,
      'updatedAt':DateTime.now().millisecondsSinceEpoch
    });
  }
}
