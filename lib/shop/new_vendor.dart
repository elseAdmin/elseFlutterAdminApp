import 'dart:collection';

import 'package:else_admin_two/firebaseUtil/firebase_api.dart';
import 'package:else_admin_two/firebaseUtil/storage_manager.dart';
import 'package:else_admin_two/shop/models/shop_model.dart';
import 'package:else_admin_two/utils/Contants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../utils/app_startup_data.dart';
import '../utils/pick_gallery_impl.dart';

class NewVendor extends StatefulWidget{
  final ShopModel shopModel;
  NewVendor(this.shopModel);

  @override
  _NewVendor createState() => _NewVendor();
}

class _NewVendor extends State<NewVendor>{
  final _formKey = GlobalKey<FormState>();
  final StorageManager _storageManager =
      StorageManager(StartupData.dbreference + '/category/shops/');
  FireBaseApi _fireBaseApi = FireBaseApi("shopStaticData");
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _floorController = TextEditingController();
  TextEditingController _shopNumberController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  List _category;
  String _imageUrl;
  String _openTime;
  String _closeTime;
  String _universe;
  List<String> timeList = [
    "1 a.m",
    "2 a.m",
    "3 a.m",
    "4 a.m",
    "5 a.m",
    "6 a.m",
    "7 a.m",
    "8 a.m",
    "9 a.m",
    "10 a.m",
    "11 a.m",
    "12 noon",
    "1 p.m",
    "2 p.m",
    "3 p.m",
    "4 p.m",
    "5 p.m",
    "6 p.m",
    "7 p.m",
    "8 p.m",
    "9 p.m",
    "10 p.m",
    "11 p.m",
    "12 midnight"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.shopModel != null) {
      _nameController.text = widget.shopModel.name;
      _aboutController.text = widget.shopModel.about;
      _floorController.text = widget.shopModel.floor.toString();
      _shopNumberController.text = widget.shopModel.shopNo;
      _category = widget.shopModel.category;
      _openTime = widget.shopModel.openTime;
      _closeTime = widget.shopModel.closeTime;
      _contactController.text = widget.shopModel.contactInfo;
      _imageUrl = widget.shopModel.imageUrl;
      setState(() {});
    }
  }

  onImageSelectedFromCameraOrGallery(file) {
    print(file);
    if (_universe != null && _nameController.text.isNotEmpty) {
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
                        child: Center(
                          child: Text("CANCEL"),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          String path = StartupData.dbreference +
                              '/category/shops/${_nameController.text}';
                          _storageManager.addFilePath(path);
                          _storageManager
                              .uploadImageUrl(file)
                              .then((uploadUrl) {
                            setState(() {
                              _imageUrl = uploadUrl;
                              print('Values in image url list ' + _imageUrl);
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text("OK"),
                        ),
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
                title: Text('Either Universe Data or Shop Name not present'),
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

  void _addVendor() async {
    ShopModel shopModel = new ShopModel(
        _nameController.text.toLowerCase(),
        _aboutController.text,
        int.parse(_floorController.text),
        _shopNumberController.text,
        _category,
        _openTime,
        _closeTime,
        _contactController.text,
        _imageUrl);

    String _shopKey = _nameController.text.replaceAll(' ', '');

    _fireBaseApi
        .updateDocument(shopModel.toJson(), _shopKey.toLowerCase())
        .then((data) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return getModal();
          });
    });
  }

  void _popContext(BuildContext context) {
    Navigator.pop(context);
  }

  Widget getModal() {
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
            title: Text(
              "Vendor added",
              textAlign: TextAlign.center,
            ),
            subtitle: Text("Our team has started working on this......"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
          ),
          FlatButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              _popContext(context);
            },
            child: Text(
              'Ok',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
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
          "New Shop Register",
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
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLines: 6,
                    decoration: const InputDecoration(labelText: 'About'),
                    controller: _aboutController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Floor Number'),
                    controller: _floorController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Shop Number'),
                    controller: _shopNumberController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  MultiSelectFormField(
                    autovalidate: false,
                    titleText: 'Category',
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please select one or more options';
                      }
                      return null;
                    },
                    dataSource: [
                      {
                        "display": "FASHION",
                        "value": "fashion",
                      },
                      {
                        "display": "BEAUTY",
                        "value": "beauty",
                      },
                      {
                        "display": "KIDS",
                        "value": "kids",
                      },
                      {
                        "display": "ELECTRONICS",
                        "value": "electronics",
                      },
                      {
                        "display": "HOME FURNISHING",
                        "value": "home",
                      },
                      {
                        "display": "RESTAURANTS",
                        "value": "restaurants",
                      },
                      {
                        "display": "PUBS",
                        "value": "pubs",
                      },
                      {
                        "display": "ENTERTAINMENT",
                        "value": "entertainment",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    // required: true,
                    hintText: 'Please choose one or more',
                    value: _category,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        _category = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Open Time"),
                      DropdownButton<String>(
                        value: _openTime,
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
                            _openTime = newValue;
                          });
                        },
                        items: timeList
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
                      Text("Close Time"),
                      DropdownButton<String>(
                        value: _closeTime,
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
                            _closeTime = newValue;
                          });
                        },
                        items: timeList
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
                    decoration:
                        const InputDecoration(labelText: 'Contact Info'),
                    controller: _contactController,
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text("Cancel"),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print("Inside Data");
                            _addVendor();
                          }
                        },
                        child: Center(
                          child: Text("Save"),
                        ),
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

  Widget imageUpload() {
    if (_imageUrl == null || _imageUrl.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Upload Image"),
          GalleryImpl(onImageSelectedFromCameraOrGallery),
        ],
      );
    } else {
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
