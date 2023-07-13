import 'package:flutter/material.dart';
import 'package:pharmacy_app/login.dart';
import 'package:pharmacy_app/utilities/ViewPrescription.dart';
import 'package:pharmacy_app/utilities/colors.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingState();
}

class SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: ColorConstants.bottomBarColor,
        ),
        body: Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(child: Text("View Prescription",textAlign: TextAlign.start,),
                        onTap:(){ Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPrescription(),
                      ),
                    );}),
                    Row(
                      children: [
                        Text("Logout"),
                        IconButton(
                          onPressed: () {
                            showAlertDialog(
                                message: "you want to logout ?",
                                context: context,
                                onNoPress: () {
                                  Navigator.pop(context);
                                },
                                onYesPress: () async {
                                  await FirebaseAuth.instance.signOut();
                                  // checkLoginState();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Login()),
                                      ModalRoute.withName('/'));
                                });
                          },
                          icon: Icon(Icons.power_settings_new),
                        )
                      ],
                    )
                  ],
                ))));
  }
}
