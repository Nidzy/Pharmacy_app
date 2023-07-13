import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/utilities/colors.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddPrescription extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddPrescriptionState();
}

class AddPrescriptionState extends State<AddPrescription> {
  GlobalKey<FormState> _key = new GlobalKey();

  final ImagePicker _picker = ImagePicker();
  XFile _imageFile = XFile("");
  dynamic _pickImageError;
  bool _showLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Prescription"),
        backgroundColor: ColorConstants.bottomBarColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              SizedBox(height: 10),
              addPrescription(),
              _showLoading
                  ? Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              )
                  : button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget addPrescription() {
    return Form(
      key: _key,
      child: Container(
          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          // decoration: bgDecoration(),
          child: Column(children: [
            Text("Click here to upload prescription"),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: _imageFile.path.isEmpty
                  ? buildPngImage("prescription", 60, 60)
                  : Image.file(File(_imageFile.path), height: 70),
              /*,*/
              onTap: () {
                showOptionsDialog(context);
              },
            ),
            SizedBox(
              height: 10,
            ),
          ])),
    );
  }

  Widget button() {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: ColorConstants.bottomBarColor),
        onPressed: () async {
          if (_key.currentState!.validate()) {
            setState(() {
              _showLoading = true;
            });

            await uploadFileAndAddMedicinePrescription(_imageFile.path);

          }
        },
        child: Text(
          'Add Medicine Prescription',
          style: TextStyle(color: ColorConstants.secondary),
        ));
  }

  //function called when tapped on camera image
  void _onImageTap(ImageSource source, {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: null,
        maxHeight: null,
        imageQuality: 60,
      );
      setState(() {
        _imageFile = pickedFile!;
        print(_imageFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  //alert dialog for choosing camera/ gallery option
  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose Photo"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Camera"),
                    ),
                    onTap: () {
                      _onImageTap(ImageSource.camera, context: context);
                      Navigator.of(context).pop();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Gallery"),
                    ),
                    onTap: () {
                      _onImageTap(ImageSource.gallery, context: context);
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadFileAndAddMedicinePrescription(String filePath) async {
    File file = File(filePath);
    try {
      String refImage = "images/${DateTime.now()}.jpg";

      var result = await firebase_storage.FirebaseStorage.instance
          .ref(refImage)
          .putFile(file);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(refImage)
          .getDownloadURL();
      var userId = FirebaseAuth.instance.currentUser!.uid;
      print(userId);
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      FirebaseFirestore.instance.collection('medicinesPrescription').add({
        "photo": downloadURL,
        "username": user['username'],
        "user_id": userId,
        "timestamp": FieldValue.serverTimestamp(),
        "isBorrowed": false
      });
      print("downloadURL ${downloadURL}");
      setState(() {
        _showLoading = false;

      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.bottomBarColor,
          content: Text('Medicine Prescription added',
              style: TextStyle(color: ColorConstants.secondary))));
      Navigator.of(context).pop();
    } on firebase_core.FirebaseException catch (e) {
      print("Error ${e.message}");
    }
  }
}
