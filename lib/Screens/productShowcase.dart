import 'package:astron_bags/Screens/adminHomePage.dart';
import 'package:astron_bags/Screens/productDetails.dart';
import 'package:astron_bags/models/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:astron_bags/main.dart';

QuerySnapshot qn, snapshot;

class Products extends StatefulWidget {
  final category;

  const Products({Key key, this.category}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  getAllProducts() async {
    print(widget.category);
    qn = await Firestore.instance
        .collection('${widget.category}')
        .getDocuments()
        .then((results) {
      snapshot = results;
    });
    print(snapshot.documents.length);
    return snapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: astronColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.category,
          style: TextStyle(color: astronColor),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getAllProducts(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: astronColor,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ));
            } else {
              if (snapshot.data.length==0) {
                return Center(
                  child: Text(
                    'No data available!!!',
                    style: TextStyle(fontSize: 25.0,color: Colors.black),
                  ),
                );
              }
              return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      crossAxisCount: 2),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(
                              product: ProductModel(
                                  snapshot.data[index].data['model'].toString(),
                                  snapshot.data[index].data['imgLink'],
                                  widget.category,
                                  snapshot.data[index].data['gprice'],
                                  snapshot.data[index].data['oprice'],),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 8.0,
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                margin:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Image.network(
                                    snapshot.data[index].data['imgLink']),
                              ),
                              Text(
                                snapshot.data[index].data['model']
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
