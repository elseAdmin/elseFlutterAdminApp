import 'package:else_admin_two/feedback/FeedbackUpdateScreen.dart';
import 'package:else_admin_two/feedback/feedback_model.dart';
import 'package:else_admin_two/firebaseUtil/database_manager.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class AllFeedback extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AllFeedbackState();
}

class AllFeedbackState extends State<AllFeedback> {
  List<FeedBack> feedbacks = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseManager().getAllFeedbacks(feedbackFetched);
  }

  feedbackFetched(List<FeedBack> feedbacks) {
    setState(() {
      this.feedbacks = feedbacks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Feedbacks"),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: feedbacks.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => _gotoFeedbackDetails(feedbacks[index]),
                child: Card(
              child: ListTile(
                title: richTextData('Subject', feedbacks[index].subject),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    richTextData('Status', feedbacks[index].feedbackStatus),
                    richTextData('Intensity',
                        feedbacks[index].feedbackIntensity.toString()),
                  ],
                ),
              ),
            ));
          },
        ));
  }
  _gotoFeedbackDetails(FeedBack feedBack){
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => FeedbackUpdateScreen(feedBack)));
  }
  Widget richTextData(String heading, String data) {
    return RichText(
      text: TextSpan(
          text: '$heading : ',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(
              text: '$data',
              style: TextStyle(
                  color: Constants.textColor, fontWeight: FontWeight.w400),
            ),
          ]),
    );
  }
}
