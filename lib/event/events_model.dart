import 'package:else_admin_two/event/base_model.dart';
import 'package:else_admin_two/event/beacon_model.dart';
import 'package:firebase_database/firebase_database.dart';

class EventModel extends BaseModel{
  String description;
  String type;
  DateTime startDate;
  DateTime endDate;
  String rules;
  int totalRules;
  String id;
  String url;
  String blurUrl;
  String name;
  String status;
  String uid;
  int observedDays;
  List<BeaconData> beaconDataList;

  EventModel(DataSnapshot snapshot){
    if(snapshot!=null) {
      this.description = snapshot.value['description'];
      this.startDate = DateTime.parse(snapshot.value['startDate']);
      this.endDate = DateTime.parse(snapshot.value["endDate"]);
      this.rules = snapshot.value['rules'];
      this.type = snapshot.value['type'];
      this.observedDays = snapshot.value['observedDays'];

      List list = snapshot.value['beaconMeta'];
      beaconDataList = List();
      for (int i = 1; i < list.length; i++) {
        BeaconData data = new BeaconData(list[i]['major'], list[i]['minor']);
        beaconDataList.add(data);
      }


      this.id = snapshot.key;
      this.url = snapshot.value['url'];
      this.name = snapshot.value['name'];
      this.status = snapshot.value['status'];
      this.blurUrl = snapshot.value['blurUrl'];
      this.uid = snapshot.value['uid'];
    }
  }

  toJson(){
    return{
      "description":this.description,
      "startDate":startDate.toString(),
      "endDate":endDate.toString(),
      "rules": rules,
      "type":type ,
      "observedDays": observedDays,
      "url": url,
      "name": name,
      "status":status,
      //"blurUrl": blurUrl,
      "uid": uid,
      //"beaconMeta": beaconDataList,
    };
  }
}