import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/login.dart';
import 'package:pharmacy_app/utilities/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmacy_app/utilities/productcard.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> itemDetailsCopy = [];
  bool _isLoggedIn = false;
  final TextEditingController _searchController = new TextEditingController();
  bool isDefaultListVisible = true;
  bool isSearchListVisible = false;
  bool _isSearching = false;
  String _searchText = "";
  List<Map<String, dynamic>> searchresult = [];
  FocusNode focusNode = new FocusNode();
  bool _showLoading = false;

  //search widget
  Widget appBarTitle = new Text(
    "Search medicine",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    checkLogin();
    getMedicinesDetails();
    _isSearching = false;
  }

  checkLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _isLoggedIn = false;
        print('User signed out');
      } else {
        print('User signed in!');
        _isLoggedIn = true;
      }
      setState(() {});
    });
  }

  _HomePageState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchController.text;
          //getSuggestion(_searchText);
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> getSuggestion(String suggestion) =>
      FirebaseFirestore.instance
          .collection('medicines')
          .orderBy('medicineName')
      // .orderBy('your-document')
          .startAt([_searchText])
          .endAt([_searchText + '\uf8ff'])
          .get()
          .then((snapshot) {
        print("actual data " +
            snapshot.docs.map((doc) => doc.data()).toList().toString());
        return snapshot.docs.map((doc) => doc.data()).toList();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: buildAppBar(context),
      body: getStackBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: ColorConstants.bottomBarColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: icon,
            onPressed: () {
              focusNode.requestFocus();
              setState(() {
                if (this.icon.icon == Icons.search) {
                  this.icon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchController,
                    focusNode: focusNode,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search medicines...",
                        hintStyle: new TextStyle(color: Colors.white)),
                    // onChanged: searchOperation,
                    onSubmitted: searchOperation,
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
          IconButton(
            onPressed: () {
              showAlertDialog(
                  message: "Do you want to sign out from app ?",
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
                            builder: (BuildContext context) => Login()),
                        ModalRoute.withName('/'));
                  });
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Center(
          child: Text(
            "",
            style: new TextStyle(color: Colors.grey, fontSize: 15),
          ));
      _isSearching = false;
      _searchController.clear();
      searchresult.clear();
      focusNode.unfocus();
    });
  }

  getTopBlock() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          /* decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
              color: ColorConstants.bottomBarColor),*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 35, right: 15),
                child: Text(
                  "Hello, Nidhi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorConstants.mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 15),
                child: Text(
                  "Welcome to Smart Pharmacy!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorConstants.mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    "Medicines Available",
                    style: TextStyle(
                        color: ColorConstants.bottomBarColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }

  getStackBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  child: getTopBlock(),
                ),
                Positioned(
                    top: 140,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 260,
                      child: getAvailableMedicines(),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getMedicinesDetails() async =>
      await FirebaseFirestore.instance
          .collection('medicines')
          .get()
          .then((snapshot) {
        itemDetailsCopy = snapshot.docs.map((doc) => doc.data()).toList();

        print("get medicine details " + itemDetailsCopy.toString());
        itemDetailsCopy.forEach((e) => e.keys.forEach((k) {
          // print("K is" + k);
        }));
        return snapshot.docs.map((doc) => doc.data()).toList();
      });

  getAvailableMedicines() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("medicines")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();
          return Container(
              child:
              searchresult.length != 0 || _searchController.text.isNotEmpty
                  ? new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: searchresult.length,
                itemBuilder: (BuildContext context, int index) {
                  // String listData = searchresult[index];
                  Map<String, dynamic> listData = searchresult[index];

                  return Container(
                      padding: EdgeInsets.all(8),
                      child: ItemCard(item: listData));
                },
              )
                  : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var medicineItem = snapshot.data!.docs[index];
                  print(medicineItem["medicineName"]);
                  //double _width = 75, _height = 100;

                  return Container(
                      padding: EdgeInsets.all(8),
                      child: ItemCard(item: medicineItem));
                },
              ));
        });
  }

  void searchOperation(String searchText) async {
    searchresult.clear();
    if (_isSearching != null) {
      List<Map<String, dynamic>> list = await getSuggestion(searchText);
      print("search" + list.toString());
      searchresult = list;
    }
  }
}
