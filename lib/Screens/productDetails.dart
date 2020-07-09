import 'dart:io';
import 'package:astron_bags/Screens/productShowcase.dart';
import 'package:astron_bags/main.dart';
import 'package:astron_bags/models/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  FirebaseAuth mauth;
  var selectedCategory;
  File imagefile;
  final picker = ImagePicker();
  TextEditingController tc;
  TextEditingController gptc;
  TextEditingController optc;
  String url;
  var model;
  var oldmodel;
  bool catchange;
  var oldCategory;
  bool load;
  var gprice;
  var oprice;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.imagefile = File(pickedFile.path);
    });
  }

  Future uploadWithDiffCategory() async {
    print(catchange);
    Firestore.instance
        .collection(oldCategory)
        .document(widget.product.model)
        .delete();
    if (this.imagefile == null) {
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Products(
                      category: oldCategory,
                    ),),);
      });
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Products(
                      category: oldCategory,
                    )));
      });
    }
  }

  Future uploadImage() async {
    Firestore.instance.collection(oldCategory).document(oldmodel).delete();
    if (this.imagefile == null) {
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Products(
                      category: oldCategory,
                    )));
      });
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
      Firestore.instance.collection(oldCategory).document(oldmodel).delete();
      Firestore.instance
          .collection(selectedCategory)
          .document(model)
          .setData(map)
          .then((value) {
            setState(() {
              
            });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Products(
                      category: oldCategory,
                    )));
      });
    }
  }

  @override
  void initState() {
    super.initState();

    load = false;
    catchange = false;

    tc = TextEditingController();
    gptc = TextEditingController();
    optc = TextEditingController();

    tc.text = widget.product.model.toString();
    gptc.text = widget.product.gprice.toString();
    optc.text = widget.product.oprice.toString();

    gprice = widget.product.gprice;
    oprice = widget.product.oprice;
    model = widget.product.model;
    url = widget.product.imgLink;
    selectedCategory = widget.product.category;

    oldCategory = widget.product.category;
    oldmodel = widget.product.model;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Products(
                category: oldCategory,
              ),
            ));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.product.model,
            style: TextStyle(color: astronColor),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: astronColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: Center(
                child: imagefile == null
                    ? Image.network(
                        url,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.5,
                      )
                    : Image.file(
                        imagefile,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.5,
                      ),
              ),
            ),
            Center(
              child: Visibility(
                visible: load,
                child: CircularProgressIndicator(
                    backgroundColor: astronColor,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: tc,
                onChanged: (value) {
                  model = tc.text;
                },
                cursorColor: astronColor,
                decoration: InputDecoration(
                  labelText: 'Change Model number',
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
                    catchange = true;
                    selectedCategory = value;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: TextFormField(
                controller: gptc,
                onChanged: (value) {
                  gprice = gptc.text;
                },
                keyboardType: TextInputType.number,
                cursorColor: astronColor,
                decoration: InputDecoration(
                  labelText: 'Change Gujarat price (in Rupees)',
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
              margin: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 30.0, top: 10.0),
              child: TextFormField(
                controller: optc,
                onChanged: (value) {
                  oprice = optc.text;
                },
                keyboardType: TextInputType.number,
                cursorColor: astronColor,
                decoration: InputDecoration(
                  labelText: 'Change Other state price (in Rupees)',
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
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width * 0.6,
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      load = true;
                    });
                    if (catchange == true) {
                      print('inside true part');
                      uploadWithDiffCategory();
                    } else {
                      print('inside false part');
                      uploadImage();
                    }
                  },
                  color: astronColor,
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
