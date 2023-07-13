import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/add_prescription.dart';
import 'package:pharmacy_app/request_medicine.dart';
import 'package:pharmacy_app/requests_list.dart';
import 'package:pharmacy_app/settings.dart';
import 'package:pharmacy_app/utilities/pharmacy_cover.dart';
import 'package:pharmacy_app/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';


class UserHome extends StatefulWidget {

  const UserHome({ Key? key }) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}


class _UserHomeState extends State<UserHome> {
  int activeTab = 0;
  GlobalKey<FormState> _key = new GlobalKey();
  String? userName;
  var userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser!.email;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appBgColor,
      bottomNavigationBar: getBottomBar(),
      body: getPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: "f1",
              onPressed: () {
                // Add your onPressed code here!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestMedicine(),
                    // builder: (context) => StudentHome(),
                  ),
                );
              },
              label: const Text('Make medicine request',style: TextStyle(color: ColorConstants.bottomBarColor)),
              icon: Icon(Icons.add_box_sharp,color: ColorConstants.bottomBarColor,),
              backgroundColor: ColorConstants.secondary,
            ),

          ],
        ),
      ),
    );
  }

  Widget getBottomBar() {
    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorConstants.bottomBarColor,
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 0;
                    });
                  },
                  child: BottomBarItem(Icons.home, "", isActive: activeTab == 0, activeColor: ColorConstants.secondary),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 1;

                    });
                  },
                  child: BottomBarItem(Icons.library_books_outlined, "", isActive: activeTab == 1, activeColor: ColorConstants.secondary),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeTab = 2;
                    });
                  },
                  child: BottomBarItem(Icons.settings, "", isActive: activeTab == 2, activeColor: ColorConstants.secondary),
                )
              ]
          )
      ),
    );
  }

  Widget getPage(){
    return
      Container(
        decoration: BoxDecoration(
            color: ColorConstants.bottomBarColor
        ),
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.appBgColor,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80)
              )
          ),
          child: IndexedStack(
            index: activeTab,
            children: <Widget>[
              HomePage(),
              AddPrescription(),
              //RequestedItemList(userEmail: userEmail),
              Setting()
            ],
          ),
        ),
      );
  }

}
