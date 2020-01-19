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

      this.url = snapshot.value['url'];
      this.name = snapshot.value['name'];
      this.status = snapshot.value['status'];
      this.blurUrl = snapshot.value['blurUrl'];
      this.uid = snapshot.value['uid'];
    }
  }
  EventModel.fromMap(Map snapshot)
      : this.description = snapshot['description'],
        this.startDate = DateTime.parse(snapshot['startDate']),
        this.endDate = DateTime.parse(snapshot["endDate"]),
        this.rules = snapshot['rules'],
        this.type = snapshot['type'],
        this.observedDays = snapshot['observedDays'],
        this.url = snapshot['url'],
        this.name = snapshot['name'],
        this.status = snapshot['status'],
        this.blurUrl = snapshot['blurUrl'],
        this.uid = snapshot['uid'],
        this.beaconDataList = getListB(snapshot['beaconMeta']);

  static getListB(snapshot) {
    List list = snapshot;
    List<BeaconData> beaconList = List();
    for (int i = 1; i < list.length; i++) {
      BeaconData data = new BeaconData(list[i]['major'], list[i]['minor']);
      beaconList.add(data);
    }
    return beaconList;
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