import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'colors.dart';

class ViewPrescription extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ViewPrescriptionState();
}

class ViewPrescriptionState extends State<ViewPrescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Prescription"),
          backgroundColor: ColorConstants.bottomBarColor,
        ),
        body: Card(child: getPriscription()));
  }

  getPriscription() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("medicinesPrescription")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var medicineItem = snapshot.data!.docs[index];
                // print(medicineItem["username"]);
                //double _width = 75, _height = 100;

                return Container(
                    padding: EdgeInsets.all(8),
                    child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Image.network(medicineItem["photo"])));
              });
        });
  }
}
