import 'dart:convert';

import 'package:astron_bags/Screens/addNewProduct.dart';
import 'package:astron_bags/main.dart';
import 'package:astron_bags/widgets/catCard.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

var state;
var API_KEY = 'DGHqEuAzfnaH3KGswNAY0sW08rQDYOJU';
var url =
    'https://api.tomtom.com/search/2/reverseGeocode/37.8328%2C-122.27669.json?key=$API_KEY';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<String> images = [
    'https://i.pinimg.com/564x/7e/48/47/7e4847c66a792d46fa3a4a718a44e0c9.jpg',
    'https://thumbs.dreamstime.com/z/back-to-school-vector-illustration-cartoon-kids-going-isolated-white-background-108997382.jpg',
    'https://image.shutterstock.com/image-vector/man-woman-traveling-together-260nw-157226846.jpg',
    'https://i.pinimg.com/564x/ed/bf/ca/edbfca9d899421946f8f4c36362e9ba5.jpg',
    'https://p.globalsources.com/IMAGES/PDT/BIG/737/B1103998737.jpg',
    'https://previews.123rf.com/images/jtanki/jtanki1703/jtanki170300004/73111576-simple-business-cartoon-vector-illustration-icon-running-late-to-go-to-office.jpg',
    'https://d2j1mo4repc142.cloudfront.net/cdn/337447/media/catalog/product/cache/1/image/265x/9df78eab33525d08d6e5fb8d27136e95/placeholder/default/skybags-placeholder.jpg'
  ];

  List<String> categories = [
    'College',
    'Kids',
    'Travelling',
    'Trekking',
    'Laptop',
    'Office',
    'Skybags'
  ];

  getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var latstr = position.latitude;
    var longstr = position.longitude;
    print(latstr);
    print(longstr);
    http.Response res = await http.get(
      'https://api.tomtom.com/search/2/reverseGeocode/$latstr%2C$longstr.json?key=$API_KEY',
    );
    var body = json.decode(res.body);
    state = body['addresses']
        .elementAt(0)['address']['countrySubdivision']
        .toString();
    print(state);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Astron Bags',
          style: TextStyle(color: astronColor),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewProduct()));
        },
        backgroundColor: astronColor,
      ),
      body: SafeArea(
        child: GridView.builder(
            itemCount: 7,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemBuilder: (context, index) {
              return catCard(
                imgLink: images[index],
                title: categories[index],
              );
            }),
      ),
    );
  }
}
