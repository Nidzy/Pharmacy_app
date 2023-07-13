import 'package:pharmacy_app/app_walkthrough.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_core/firebase_core.dart';


import 'login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pharmacy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Splash()
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  //it will check for introscreen already shown or not
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = prefs.getBool('alreadySeen') ?? false;
    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Login()));
    } else {
      await prefs.setBool('alreadySeen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => IntroWalkthrough()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: buildPngImage('drugstore', 90, 90)),
          SizedBox(
            height: 10,
          ),
          Text(
            "Smart Pharmacy",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
