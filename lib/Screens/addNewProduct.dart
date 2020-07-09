import 'dart:convert';
import 'dart:io';
import 'package:astron_bags/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddNewProduct extends StatefulWidget {
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final scafkey = GlobalKey<ScaffoldState>();

  FirebaseAuth mauth;
  var selectedCategory;
  File imagefile;
  final picker = ImagePicker();
  TextEditingController tc;
  TextEditingController gptc;
  TextEditingController optc;
  String url;
  var model;
  bool load;
  var gprice;
  var oprice;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.imagefile = File(pickedFile.path);
    });
  }

  Future uploadImage() async {
    setState(() {
      load = true;
    });
    if (this.imagefile == null) {
      getImage();
      uploadImage();
    } else {
      FirebaseStorage storage = FirebaseStorage.instance;
      StorageReference ref = storage.ref().child("$selectedCategory/$model");
      StorageUploadTask task = ref.putFile(imagefile);
      StorageTaskSnapshot tasksnap = await task.onComplete;
      String tempurl = await ref.getDownloadURL();
      setState(() {
        url = tempurl;
      });
      print(url);
      var map = <String, dynamic>{
        'imgLink': url.toString(),
        'model': model,
        'gprice': gprice,
        'oprice': oprice
      };
      Firestore.instance
          .collection(selectedCategory)
          .document(model)
          .setData(map)
          .then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    load = false;
    mauth = FirebaseAuth.instance;
    if (mauth.currentUser() == null) {
      mauth.signInAnonymously();
    }
    super.initState();
    selectedCategory = "Select category";
    tc = TextEditingController();
    gptc = TextEditingController();
    optc = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafkey,
      appBar: AppBar(
        title: Text(
          'Add New Product',
          style: TextStyle(color: astronColor),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: astronColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: tc,
                    onChanged: (value) {
                      model = tc.text;
                    },
                    cursorColor: astronColor,
                    decoration: InputDecoration(
                      labelText: 'Enter Model number',
                      labelStyle: TextStyle(color: astronColor),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: astronColor)),
                      prefixIcon: Icon(
                        Icons.business_center,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.black,
                    ),
                    iconSize: 20.0,
                    hint: Text(
                      selectedCategory,
                      style: TextStyle(color: astronColor),
                    ),
                    items: <String>[
                      'College',
                      'Kids',
                      'Travelling',
                      'Trekking',
                      'Laptop',
                      'Office',
                      'Skybags'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: TextFormField(
                    controller: gptc,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      gprice = gptc.text;
                    },
                    cursorColor: astronColor,
                    decoration: InputDecoration(
                      labelText: 'Gujarat price (in Rupees)',
                      labelStyle: TextStyle(color: astronColor),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: astronColor)),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: TextFormField(
                    controller: optc,
                    onChanged: (value) {
                      oprice = optc.text;
                    },
                    keyboardType: TextInputType.number,
                    cursorColor: astronColor,
                    decoration: InputDecoration(
                      labelText: 'Other state price (in Rupees)',
                      labelStyle: TextStyle(color: astronColor),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: astronColor)),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: RaisedButton(
                    onPressed: () {
                      getImage();
                    },
                    color: astronColor,
                    child: Text(
                      'Choose Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: Visibility(
                    visible: load,
                    child: CircularProgressIndicator(
                        backgroundColor: astronColor,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: imagefile != null ? Image.file(imagefile) : Offstage(),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (tc.text.isEmpty) {
                          scafkey.currentState.showSnackBar(SnackBar(
                              content: Text('Please enter model number')));
                          return;
                        }
                        if (gptc.text.isEmpty) {
                          scafkey.currentState.showSnackBar(
                              SnackBar(content: Text('Please enter price')));
                          return;
                        }
                        if (optc.text.isEmpty) {
                          scafkey.currentState.showSnackBar(
                              SnackBar(content: Text('Please enter price')));
                          return;
                        }
                        if (selectedCategory == 'Select category') {
                          scafkey.currentState.showSnackBar(SnackBar(
                              content: Text('Please select a category')));
                          return;
                        }
                        uploadImage();
                      },
                      color: astronColor,
                      child: Text(
                        'Upload Product',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
