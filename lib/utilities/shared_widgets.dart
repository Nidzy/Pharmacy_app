import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildPngImage(String assetName,double height, double width) {
  return Image.asset(
    'assets/images/$assetName.png',
    filterQuality: FilterQuality.high,
    height: height,
    width: width,
  );
}

Widget buildImage(String assetName) {
  return Align(
    child: SvgPicture.asset('assets/images/$assetName.svg', width: 320.0),
    alignment: Alignment.bottomCenter,
  );
}

showAlertDialog(
    {BuildContext? context,
      VoidCallback? onNoPress,
      VoidCallback? onYesPress,String? message}) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Are you sure"),
    content: Text(message!),
    actions: [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        onPressed: onNoPress,
        child: const Text('No'),
      ),
      /*TextButton(
        style: ButtonStyle(backgroundColor: ),
        onPressed: () => onNoPress,
        child: const Text('No'),
      ),*/
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
        ),
        onPressed: onYesPress,
        child: const Text('Yes'),
      ),
      /*TextButton(
        onPressed: () => onYesPress,
        child: const Text('Yes'),
      ),*/
    ],
  );

  // show the dialog
  showDialog(
    context: context!,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showEmptyView(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: buildPngImage(
                "glasses",
                100,
                100,
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            "No Record available",
            textAlign: TextAlign.center,
          ),
        ]),
  );
}