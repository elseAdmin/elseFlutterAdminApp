import 'package:else_admin_two/feedback/feedback_preview.dart';
import 'package:else_admin_two/feedback/feedback_screen.dart';
import 'package:else_admin_two/feedback/models/feedback_crud_model.dart';
import 'package:else_admin_two/feedback/models/feedback_model.dart';
import 'package:else_admin_two/firebaseUtil/api.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:else_admin_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';

class FeedBackList extends StatefulWidget{
  @override
  _FeedBackList createState() => _FeedBackList();
}

class _FeedBackList extends State<FeedBackList> with AutomaticKeepAliveClientMixin<FeedBackList>{
  List<FeedBackPreview> _feedBackPendingPreviewMap = List();
  List<FeedBackPreview> _feedBackProgressPreviewMap = List();
  List<FeedBackPreview> _feedBackAckPreviewMap = List();
  List<FeedBackPreview> _feedBackCompletePreviewMap = List();
  FeedbackCrudModel feedbackCrudModel;

  @override
  void initState() {
    super.initState();
    _getFeedBackData();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  _getFeedBackData(){
    String path = '/unityOneRohini/feedback/allfeedbacks';
    feedbackCrudModel = FeedbackCrudModel(new Api(path));
    feedbackCrudModel.fetchFeedBacks().then((feedBackList){
      for(FeedBack feedBack in feedBackList){
        FeedBackPreview feedBackPreview = new FeedBackPreview(
            StartupData.dbreference, feedBack);
        switch(feedBack.feedbackStatus){
          case 'IN_PROCESS':
            _feedBackProgressPreviewMap.add(feedBackPreview);
            break;
          case 'PENDING':
            _feedBackPendingPreviewMap.add(feedBackPreview);
            break;
          case 'INVALID':
            break;
          case 'ACKNOWLEDGED':
            _feedBackAckPreviewMap.add(feedBackPreview);
            break;
          case 'COMPLETED':
            _feedBackCompletePreviewMap.add(feedBackPreview);
            break;
        }
      }
    });
    setState(() {

    });
  }

  _clearList(){
    _feedBackPendingPreviewMap = List();
    _feedBackProgressPreviewMap = List();
    _feedBackAckPreviewMap = List();
    _feedBackCompletePreviewMap = List();
  }

  _refreshList(){
    _clearList();
    _getFeedBackData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.textColor),
          bottom: TabBar(
            labelColor: Constants.textColor,
            tabs: [
              Tab(text: 'Pending',),
              Tab(text: 'Progress'),
              Tab(text: 'Acknowledged',),
              Tab(text: 'Completed',),
            ],
          ),
          backgroundColor: Constants.titleBarBackgroundColor,
          title: Text(
            "Feedbacks",
            style: TextStyle(
              color: Constants.titleBarTextColor,
              fontSize: 18,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FeedbackPage(_feedBackPendingPreviewMap, _refreshList),
            FeedbackPage(_feedBackProgressPreviewMap, _refreshList),
            FeedbackPage(_feedBackAckPreviewMap, _refreshList),
            FeedbackPage(_feedBackCompletePreviewMap, _refreshList),
          ],
        ),
      ),
    );
  }
}