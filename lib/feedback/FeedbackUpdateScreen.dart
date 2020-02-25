import 'package:else_admin_two/feedback/feedback_model.dart';
import 'package:else_admin_two/firebaseUtil/database_manager.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class FeedbackUpdateScreen extends StatefulWidget {
  FeedBack feedback;
  FeedbackUpdateScreen(this.feedback);
  @override
  State<StatefulWidget> createState() => FeedbackUpdateScreenState();
}

class FeedbackUpdateScreenState extends State<FeedbackUpdateScreen> {
  String statusValue = 'PENDING';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Feedback"),
        ),
        floatingActionButton: FloatingActionButton(
      elevation: 10,
      child: Icon(Icons.save),
      onPressed: updateFeedback,
    ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Status :'),
                DropdownButton<String>(
                  value: statusValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      statusValue = newValue;
                    });
                  },
                  items: Constants.feedbackStates
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            )
          ],
        ));
  }
  updateFeedback() async {
    await DatabaseManager().updateFeedbackStatus(widget.feedback.id,statusValue);
  }
}
