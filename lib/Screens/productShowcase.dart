import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    print(snapshot.documents.elementAt(0));
    return snapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getAllProducts(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (_, index) {
                    return Card(
                      elevation: 8.0,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.2,
                              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Image.network(
                                  snapshot.data[index].data['imgLink']),
                            ),
                            Text(
                              snapshot.data[index].data['model']
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            )
                          ],
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
