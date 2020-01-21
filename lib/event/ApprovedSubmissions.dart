import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/event/ApprovedSubmissionDialog.dart';
import 'package:else_admin_two/event/SubmissionDIalog.dart';
import 'package:else_admin_two/event/events_model.dart';
import 'package:else_admin_two/event/online_submission_model.dart';
import 'package:else_admin_two/firebaseUtil/database_manager.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class ApprovedSubmissionScreen extends StatefulWidget {
  final EventModel event;
  ApprovedSubmissionScreen(this.event);
  @override
  createState() => ApprovedSubmissionScreenState();
}

class ApprovedSubmissionScreenState extends State<ApprovedSubmissionScreen> {
  List<OnlineEventSubmissionModel> submissions;

  @override
  void initState() {
    super.initState();
    DatabaseManager.approvedSubmissionsFound = approvedSubmissionsFound;
    submissions = DatabaseManager.approvedSubmissions;
  }

  approvedSubmissionsFound(List<OnlineEventSubmissionModel> foundSubmissions) {
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
          title: Text("Approved Submissions",
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
        context: context,
        builder: (BuildContext context) => ApprovedSubmissionDialogue(model,onSelected));
  }

  onSelected(OnlineEventSubmissionModel model) async{
    await DatabaseManager().markSubmissionWinner(model,widget.event.uid);
    Navigator.of(context, rootNavigator: true).pop();
  }
}
