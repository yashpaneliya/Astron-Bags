import 'package:astron_bags/Screens/productShowcase.dart';
import 'package:flutter/material.dart';

class catCard extends StatefulWidget {
  final title;
  final imgLink;

  const catCard({Key key, this.title, this.imgLink}) : super(key: key);
  @override
  _catCardState createState() => _catCardState();
}

class _catCardState extends State<catCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Products(category: widget.title,)));
      },
          child: Card(
        elevation: 8.0,
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.4,
                height: MediaQuery.of(context).size.height*0.17,
                margin: EdgeInsets.only(top:10.0,bottom: 10.0),
                child: Image.network(widget.imgLink),
              ),
              Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),)
            ],
          ),
        ),
      ),
    );
  }
}
