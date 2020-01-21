import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_admin_two/event/online_submission_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApprovedSubmissionDialogue extends StatelessWidget {
  final OnlineEventSubmissionModel model;
  final Function(OnlineEventSubmissionModel) onSelected;
  ApprovedSubmissionDialogue(this.model, this.onSelected);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SimpleDialog(
      elevation: 20,
      children: <Widget>[
        Column(
          children: <Widget>[
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: model.imageUrl,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(child: Text('Select as winner'), onTap: winner)
              ],
            )
          ],
        )
      ],
    );
  }

  winner() {
    onSelected(model);
  }
}
