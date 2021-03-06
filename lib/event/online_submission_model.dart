import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineEventSubmissionModel {
  String imageUrl;
  int likes;
  String status;
  String userUid;
  DateTime participatedAt;

  OnlineEventSubmissionModel(DocumentSnapshot snapshot){
    this.imageUrl = snapshot.data["imageUrl"];
    this.likes = snapshot.data["likes"];
    this.status = snapshot.data["status"];
    this.userUid = snapshot.data["userUid"];
    this.participatedAt = DateTime.fromMillisecondsSinceEpoch(snapshot.data["participatedAt"]);
  }
}
