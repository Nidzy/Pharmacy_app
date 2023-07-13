import 'package:pharmacy_app/utilities/avtar_image.dart';
import 'package:pharmacy_app/utilities/pharmacy_item.dart';
import 'package:pharmacy_app/utilities/colors.dart';
import 'package:pharmacy_app/utilities/productcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({Key? key}) : super(key: key);

  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: ColorConstants.bottomBarColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstants.shadowColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: TabBar(
                indicatorColor: ColorConstants.bottomBarColor,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorConstants.primaryColor,
                ),
                labelPadding: EdgeInsets.only(top: 8, bottom: 8),
                unselectedLabelColor: ColorConstants.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Text(
                    "View Medicine",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "View Prescription",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  getAvailableItems(),
                  getPriscription()
                  /*ListView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      children: getNewMedicine()
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAvailableItems() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("medicines")
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
              print(medicineItem["medicineName"]);
              //double _width = 75, _height = 100;

              return Container(
                  padding: EdgeInsets.all(8),
                  child: ItemCard(item: medicineItem));
            },
          );
        });
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
