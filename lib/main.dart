import 'package:astron_bags/Screens/adminHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Color astronColor = Color.fromRGBO(237, 47, 89, 1);
FirebaseAuth mauth;
FirebaseUser currentuser;
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    theme: ThemeData(fontFamily: 'Raleway', primaryColor: astronColor),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Tween _tween;
  Animation _animation;

  @override
  void initState() {
    mauth = FirebaseAuth.instance;
    fetchuser();
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            setState(() {
              if (status == AnimationStatus.completed) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AdminHomePage()));
              }
            });
          });
    _tween = Tween<double>(begin: 30.0, end: 340.0);
    _animation = _tween.animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  fetchuser() async {
    currentuser = await mauth.currentUser();
    if (currentuser == null) {
      mauth.signInAnonymously().then((value) async {
        currentuser = await mauth.currentUser();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: screenwidth * 0.8,
              height: 400.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/AstronLogo.png'),
                      fit: BoxFit.contain)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30.0),
            height: 60.0,
            alignment: Alignment.center,
            width: _animation.value,
            decoration: BoxDecoration(
              color: astronColor,
              border: Border.all(width: 1.0, color: astronColor),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: _animation.value > 300.0
                ? Text(
                    'Finished...'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0),
                  )
                : Offstage(),
          ),
        ],
      ),
    );
  }
}
