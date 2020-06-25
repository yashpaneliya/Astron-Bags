import 'package:flutter/material.dart';

Color astronColor=Color.fromRGBO(237, 47, 89,1);

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  
  AnimationController _animationController;
  Tween _tween;
  Animation _animation;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            setState(() {
              if (status == AnimationStatus.completed) {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => LineUp()));
              }
            });
          });
    _tween = Tween<double>(begin: 30.0, end: 340.0);
    _animation = _tween.animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.0, bottom: 70.0),
            width: screenwidth,
            height: 400.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/AstronLogo.png'),fit: BoxFit.contain)),
          ),
          Container(
            margin: EdgeInsets.only(left:30.0),
            height: 60.0,
            alignment: Alignment.center,
            width: _animation.value,
            decoration: BoxDecoration(
              color: astronColor,
              border: Border.all(width: 1.0,color:astronColor),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: _animation.value>150.0?Text('Loading...'.toUpperCase(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 3.0),):Offstage(),
          ),
        ],
      ),
    );
  }
}