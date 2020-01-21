import 'package:else_admin_two/deals/models/deals_model.dart';
import 'package:else_admin_two/firebaseUtil/firebase_api.dart';
import 'package:else_admin_two/firebaseUtil/storage_manager.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:flutter/material.dart';

import '../utils/app_startup_data.dart';
import '../utils/pick_gallery_impl.dart';

class NewDeal extends StatefulWidget{
  final DealModel dealModel;
  NewDeal(this.dealModel);

  @override
  _NewDeal createState() => _NewDeal();
}

class _NewDeal extends State<NewDeal>{
  final _formKey = GlobalKey<FormState>();
  final StorageManager _storageManager = StorageManager(StartupData.dbreference+'/background/dealBackground/');
  FireBaseApi _fireBaseApi = FireBaseApi("dealsStaticData");
  TextEditingController _nameController = TextEditingController();
  TextEditingController _shortDetailController = TextEditingController();
  TextEditingController _uidController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _shopNameController = TextEditingController();
  TextEditingController _couponController = TextEditingController();
  List<TextEditingController> _detailController = [];
  TextEditingController detailsController = TextEditingController();
  int countDetails = 0;

  List<TextEditingController> _tncController = [];
  TextEditingController tncController = TextEditingController();
  int countTnc = 0;

  String _universe;
  String _imageUrl;
  String _dealStatus;
  DateTime selectedDate = DateTime.now();
  List<Widget> _detailsChildren = [];
  List<Widget> _tncChildren = [];


  @override
  void initState() {
    super.initState();
    _detailController.add(detailsController);
    _tncController.add(tncController);
    if(widget.dealModel != null){
      _shopNameController.text = widget.dealModel.shopName;
      _imageUrl = widget.dealModel.url;
      _nameController.text = widget.dealModel.name;
      _shortDetailController.text = widget.dealModel.shortDetails;
      _uidController.text = widget.dealModel.uid;
      _couponController.text = widget.dealModel.couponCode;
      _dealStatus = widget.dealModel.status;
      selectedDate = widget.dealModel.validity;
      _dateController.text = selectedDate.day.toString() + '/' + selectedDate.month.toString() + '/' + selectedDate.year.toString();
      _tncController[0].text = widget.dealModel.tnc[0];
      _detailController[0].text = widget.dealModel.details[0];
      for(int i=1; i<widget.dealModel.tnc.length; ++i){
        _addTnc(widget.dealModel.tnc[i]);
      }
      for(int i=1; i<widget.dealModel.details.length; ++i){
        _addDetails(widget.dealModel.details[i]);
      }
      setState(() {});
    }
  }

  _addDetails(String detail){
    setState(() => ++countDetails);
    _detailController.length = countDetails+1;
    _detailController[countDetails] = TextEditingController();
    if(detail != null){
      _detailController[countDetails].text = detail;
    }
    _detailsChildren = List.from(_detailsChildren)
      ..add(
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Details',
            ),
            controller: _detailController[countDetails],
            validator: (value) {
              if (value == null || value.length == 0) {
                return 'Please enter some text';
              }
              return null;
            },
          )
      );
  }

  _addTnc(String tnc){
    setState(() => ++countTnc);
    _tncController.length = countTnc+1;
    _tncController[countTnc] = TextEditingController();
    if(tnc != null){
      _tncController[countTnc].text = tnc;
    }
    _tncChildren = List.from(_tncChildren)
      ..add(
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Terms and Condition',
            ),
            controller: _tncController[countTnc],
            validator: (value) {
              if (value == null || value.length == 0) {
                return 'Please enter some text';
              }
              return null;
            },
          )
      );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = selectedDate.day.toString() + '/' + selectedDate.month.toString() + '/' + selectedDate.year.toString();
      });
  }

  onImageSelectedFromCameraOrGallery(file) {
    print(file);
    if(_universe != null && _nameController.text.isNotEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return Container(
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: Card(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 3,
                    child: Image.file(file),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Center(child: Text("CANCEL"),),
                      ),
                      FlatButton(
                        onPressed: (){
                          ///unityOneRohini/background/dealBackground
                          String path = StartupData.dbreference+'/background/dealBackground/${_nameController.text}';
                          _storageManager.addFilePath(path);
                          _storageManager.uploadImageUrl(file).then((uploadUrl){
                            setState(() {
                              _imageUrl=uploadUrl;
                              print('Values in image url list '+_imageUrl);
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Center(child: Text("OK"),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context){
          return Card(
            child: ListTile(
              title: Text('Either Universe Data or Deal Name not present'),
              subtitle: FlatButton(
                child: Center(child: Text("OK"),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }
      );
    }
  }

  _addDeals() async{

    List tnc = List();
    List details = List();
    for(TextEditingController tncController in _tncController){
      tnc.add(tncController.text);
    }
    for(TextEditingController detailController in _detailController){
      details.add(detailController.text);
    }

    DealModel dealModel = new DealModel(tnc, selectedDate, _shopNameController.text,
        _imageUrl, _imageUrl, _nameController.text, _shortDetailController.text,
        details, _dealStatus, _uidController.text.toUpperCase(), _couponController.text);

    _fireBaseApi.updateDocument(dealModel.toJson(), _uidController.text.toUpperCase()).then((data){
      showModalBottomSheet(context: context, builder: (context){
        return getModal();
      });
    });
  }

  void _popContext(BuildContext context){
    Navigator.pop(context);
  }

  Widget getModal(){
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white70,
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Vendor added", textAlign: TextAlign.center,),
            subtitle: Text("Our team has started working on this......"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
          ),
          FlatButton(
            color: Colors.white,
            onPressed: (){
              Navigator.pop(context);
              _popContext(context);
            },
            child: Text('Ok', style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20.0),),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Deal Register",
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          borderOnForeground: true,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Universe"),
                      DropdownButton<String>(
                        value: _universe,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black12,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _universe = newValue;
                          });
                        },
                        items: <String>['unityOneRohini']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Name'
                    ),
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'UID'
                    ),
                    controller: _uidController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Short Detail'
                    ),
                    controller: _shortDetailController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Status"),
                      DropdownButton<String>(
                        value: _dealStatus,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.black12,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _dealStatus = newValue;
                          });
                        },
                        items: <String>['active','inactive']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Validity"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Validity',
                              ),
                              controller: _dateController,
                              enabled: false,
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          FlatButton(
                            onPressed: () => _selectDate(context),
                            child: Icon(Icons.date_range),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Shop Name'
                    ),
                    controller: _shopNameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Details',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: (){
                          _addDetails(null);
                        },
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _detailController[0],
                  ),
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: _detailsChildren,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Terms and Condition',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: (){
                          _addTnc(null);
                        },
                      )
                    ),
                    controller: _tncController[0],
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: _tncChildren,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Coupon Code'
                    ),
                    controller: _couponController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  imageUpload(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Center(child: Text("Cancel"),),
                      ),
                      FlatButton(
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            print("Inside Data");
                            _addDeals();
                          }
                        },
                        child: Center(child: Text("Save"),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageUpload(){
    if(_imageUrl == null || _imageUrl.isEmpty){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Upload Image"),
          GalleryImpl(onImageSelectedFromCameraOrGallery),
        ],
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height / 8,
        width: MediaQuery.of(context).size.height / 4,
        child: Card(
          child: Image(
            image: NetworkImage(_imageUrl),
          ),
        ),
      );
    }
  }

}