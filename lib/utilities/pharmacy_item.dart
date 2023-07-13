import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'colors.dart';


class PharmacyItem extends StatelessWidget {
  PharmacyItem({  Key? key, @required this.medicine }) : super(key: key);
  final medicine;

  @override
  Widget build(BuildContext context) {
    double _width = 80, _height = 110;
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(top: 15),
        child: Row(
          children: [
            Stack(
                children: [
                  Card(
                      color: ColorConstants.primary,
                      child: Container(
                          color: ColorConstants.accentColor,
                          width: _width, height: _height,
                      padding: EdgeInsets.all(8),
                      // child: buildPngImage(book["image"], 50, 50
                      child: Image(image: AssetImage(medicine["image"])) /*Image.file(
                      File(book["image"],),
                      fit: BoxFit.cover,
                    ),*/
                  ))
                ]
            ),
            SizedBox(width: 18,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine["title"], style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                SizedBox(height: 12,),
                RichText(text: TextSpan(
                    children: [
                      TextSpan(text: medicine["price"], style: TextStyle(fontSize: 16, color: ColorConstants.primary ,fontWeight: FontWeight.w500)),
                      TextSpan(text: "   "),
                      TextSpan(text: medicine["ori_price"],
                          style: TextStyle(color: Colors.grey, fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w500)
                      ),
                    ]
                ))
              ],
            )
          ],
        )
    );
  }
}