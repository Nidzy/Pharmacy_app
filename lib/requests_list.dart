import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pharmacy_app/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';



class RequestedItemList extends StatefulWidget {
  final String userEmail;

  RequestedItemList({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BorrowedBookListState();
}

class BorrowedBookListState extends State<RequestedItemList> {
  @override
  void initState() {
    super.initState();
    //fetch current date and compare it with books due date

    /*DateTime now = DateTime.now();
    String formattedDate = Jiffy('yyyy-MM-dd').format(now);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorConstants.bottomBarColor,
            title: Text(widget.userEmail)),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("medicineRequest")
                .doc(widget.userEmail)
                .collection("requestedMedicineList")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              return Container(
                  child: snapshot.data!.docs.length > 0
                      ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var medicineItem = snapshot.data!.docs[index];
                      return Card(
                          elevation: 10,
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(16.0))),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  bottom: 10,
                                  right: 10,
                                  top: 10),
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Wrap(
                                          children: [
                                            buildPngImage(
                                                "drugs", 25, 25),
                                            Text(
                                              " Medicine Name : " +
                                                  medicineItem["medicineName"],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: ColorConstants
                                                      .textTitleColor,
                                                  fontWeight:
                                                  FontWeight.bold),
                                              // bookDistinctItem.toString(),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        )),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                          runAlignment:
                                          WrapAlignment.start,
                                          children: [
                                            buildPngImage(
                                                "drug", 25, 25),
                                            Text(
                                              " Refferal Doctor Name : " +
                                                  medicineItem["doctorName"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorConstants
                                                      .mainColor,
                                                  fontWeight:
                                                  FontWeight.normal),
                                              // bookDistinctItem.toString(),
                                              textAlign: TextAlign.start,
                                            ),
                                            Align(
                                                alignment:
                                                Alignment.topLeft,
                                                child: TextButton(
                                                    onPressed: () {
                                                      showAlertDialog(
                                                          message:
                                                          "you want to delete this request ?",
                                                          context:
                                                          context,
                                                          onNoPress: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          onYesPress:
                                                              () async {
                                                            Navigator.pop(
                                                                context);
                                                            await FirebaseFirestore.instance.runTransaction(
                                                                    (Transaction
                                                                myTransaction) async {
                                                                  await myTransaction
                                                                      .delete(
                                                                      medicineItem.reference);
                                                                }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                backgroundColor:
                                                                ColorConstants
                                                                    .accentColor,
                                                                content: Text(
                                                                    "Request Deleted Successfully",
                                                                    style:
                                                                    TextStyle(color: ColorConstants.buttonTextColor)))));
                                                          });
                                                    },
                                                    child: Wrap(
                                                      crossAxisAlignment:
                                                      WrapCrossAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                            'Delete Request',
                                                            style: (TextStyle(
                                                                color: ColorConstants
                                                                    .errorColor))),
                                                        Icon(
                                                          Icons.delete_forever,
                                                          color: ColorConstants
                                                              .accentColor,
                                                        ),
                                                      ],
                                                    ))),
                                          ],
                                        )),
                                  ])));
                    },
                  )
                      : showEmptyView(context));
            }) /*)*/);
  }
}
