import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/event/SubmissionDIalog.dart';
import 'package:else_admin_two/event/events_model.dart';
import 'package:else_admin_two/event/online_submission_model.dart';
import 'package:else_admin_two/firebaseUtil/database_manager.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class SubmissionScreen extends StatefulWidget {
  final EventModel event;
  SubmissionScreen(this.event);
  @override
  createState() => SubmissionScreenState();
}

class SubmissionScreenState extends State<SubmissionScreen> {
  List<OnlineEventSubmissionModel> submissions;

  @override
  void initState() {
    super.initState();
    DatabaseManager.submissionsFound = submissionsFound;
    submissions = DatabaseManager.submissions;
  }

  submissionsFound(List<OnlineEventSubmissionModel> foundSubmissions) {
    setState(() {
      submissions = foundSubmissions;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.titleBarBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Submissions",
              style: TextStyle(
                color: Constants.titleBarTextColor,
                fontSize: 18,
              )),
          centerTitle: true,
        ),
        body: GridView.builder(
            shrinkWrap: true,
            itemCount: submissions.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Constants.mainBackgroundColor,
                child: GestureDetector(
                    onTap: () => viewSubmission(submissions[index]),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: submissions[index].imageUrl,
                    )),
              );
            }));
  }

  viewSubmission(OnlineEventSubmissionModel model) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => SubmissionDialogue(model,onReject,onApproved));
  }

  onApproved(String userUid){
    DatabaseManager().updateSubmissionStatus('Approved',userUid,widget.event.uid);
    Navigator.of(context, rootNavigator: true).pop();
  }
  onReject(String userUid){
    DatabaseManager().updateSubmissionStatus('Rejected',userUid,widget.event.uid);
   Navigator.of(context, rootNavigator: true).pop();
  }
}
