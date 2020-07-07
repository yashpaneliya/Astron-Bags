import 'package:astron_bags/Screens/addNewProduct.dart';
import 'package:astron_bags/main.dart';
import 'package:astron_bags/widgets/catCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<String> categories = [
    'College',
    'Kids',
    'Travelling',
    'Trekking',
    'Laptop',
    'Office',
    'Skybags'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewProduct()));
        },
        backgroundColor: astronColor,
      ),
      body: SafeArea(
        child: GridView.builder(
            itemCount: 7,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return catCard(
                imgLink:
                    'https://png2.cleanpng.com/sh/448d0930a1181281f7711c041a56b83c/L0KzQYm3WcI3N6Frf5H0aYP2gLBuTfJia5x1edV0LXLkd7johBUuf5pxfNV7YXb3PbBCjP9vNahtgdVxLXn2PcXvhb1jbaR5RdV4bHzod7a0gvFoNZNqhNHCLYL2PYK8TgF2d146etNrNEDlQYbqVcY6QV82TaUENkW6QoK8U8c6PGo9T6U8N0i1PsH1h5==/kisspng-backpack-baggage-wildcraft-nylon-which-is-the-best-college-bag-below-rs-15-quo-5bab40b15c5699.1539657215379498733782.png',
                title: categories[index],
              );
            }),
      ),
    );
  }
}
