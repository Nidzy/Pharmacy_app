import 'package:pharmacy_app/home.dart';
import 'package:pharmacy_app/requests_list.dart';
import 'package:pharmacy_app/settings.dart';
import 'package:pharmacy_app/user_home.dart';
import 'package:pharmacy_app/utilities/bottom_item.dart';
import 'package:pharmacy_app/utilities/colors.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';
import 'package:flutter/material.dart';

import 'add_medicine.dart';
import 'medicine_page.dart';


class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int activeTab = 0;
  GlobalKey<FormState> _key = new GlobalKey();
  final _userRequestEmailController = TextEditingController();
  late String userEmail;
  bool _showLoading = false;

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: "f1",
              onPressed: () {
                // Add your onPressed code here!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMedicine(),
                    // builder: (context) => StudentHome(),
                  ),
                );
              },
              label: const Text('Add Medicine',
                  style: TextStyle(color: ColorConstants.bottomBarColor)),
              icon: Icon(
                Icons.medical_information_outlined,
                color: ColorConstants.bottomBarColor,
              ),
              backgroundColor: ColorConstants.secondary,
            ),
            FloatingActionButton.extended(
              heroTag: "f2",
              onPressed: () {
                // Add your onPressed code here!
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter state) {
                            return SingleChildScrollView(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 15),
                                        buildPngImage("add_medicine", 45, 45),
                                        SizedBox(height: 15),
                                        checkMedicineOrderRequest(context),
                                        SizedBox(height: 15),
                                        checkRequestedItemBtn(state),
                                      ],
                                    )));
                          });
                    });
              },
              label: const Text(
                'View request',
                style: TextStyle(color: ColorConstants.bottomBarColor),
              ),
              icon: const Icon(
                Icons.supervised_user_circle,
                color: ColorConstants.bottomBarColor,
              ),
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
        /*borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
        ),*/
        color: ColorConstants.bottomBarColor,
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  activeTab = 0;
                });
              },
              child: BottomBarItem(Icons.home_outlined, "",
                  isActive: activeTab == 0,
                  activeColor: ColorConstants.secondary),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  activeTab = 1;
                });
              },
              child: BottomBarItem(Icons.medical_information_outlined, "",
                  isActive: activeTab == 1,
                  activeColor: ColorConstants.secondary),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  activeTab = 2;
                });
              },
              child: BottomBarItem(Icons.settings_applications, "",
                  isActive: activeTab == 2,
                  activeColor: ColorConstants.secondary),
            )
          ])),
    );
  }

  Widget getPage() {
    return Container(
      decoration: BoxDecoration(color: ColorConstants.bottomBarColor),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.appBgColor,
          /*borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))*/),
        child: IndexedStack(
          index: activeTab,
          children: <Widget>[
            HomePage(),
            MedicinePage(),
            Setting(),
          ],
        ),
      ),
    );
  }

  Widget checkMedicineOrderRequest(BuildContext context) {
    return Form(
      key: _key,
      child: Container(
          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          // decoration: bgDecoration(),
          child: Column(children: [
            Text(
              "Check requested medicine from user",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                hintText: "Enter user email",
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
                fillColor: Colors.deepPurple,
                // counter: Offstage(),
              ),
              onChanged: (value) {
                // this.username = value;
              },
              maxLines: 1,
              controller: _userRequestEmailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter user email';
                } else {
                  setState(() {
                    userEmail = value;
                  });
                }
                return null;
              },
            ),
            SizedBox(height: 10),
          ])),
    );
  }

  Widget checkRequestedItemBtn(StateSetter state) {
    return TextButton(
        style: TextButton.styleFrom(backgroundColor: ColorConstants.bottomBarColor),
        child: Text('Check medicine request list',style:TextStyle(color: ColorConstants.secondary)),
        onPressed: () {
          if (_key.currentState!.validate()) {
            state(
                  () {
                _userRequestEmailController.clear();
                _showLoading = true;
              },
            );
            //add data to users borrow record
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestedItemList(userEmail: userEmail),
              ),
            );
          }
        });
  }
}
