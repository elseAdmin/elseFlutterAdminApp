import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/event/online_submission_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmissionDialogue extends StatelessWidget{
  final OnlineEventSubmissionModel model;
  final Function(String) onReject;
  final Function(String) onApprove;
  SubmissionDialogue(this.model,this.onReject,this.onApprove);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SimpleDialog(
      elevation: 20,
      children: <Widget>[
        Column(children: <Widget>[
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: model.imageUrl,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(child:Text('Reject'),onTap: reject,),
            GestureDetector(child:Text('Approve'),onTap: approved,)
          ],)
        ],)
      ],
    );
  }
  reject(){
    onReject(model.userUid);
  }
  approved(){
    onApprove(model.userUid);
  }

}