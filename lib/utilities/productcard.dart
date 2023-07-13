import 'package:pharmacy_app/utilities/avtar_image.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/utilities/avtar_image.dart';

import 'colors.dart';

class ItemCard extends StatelessWidget {
  ItemCard({Key? key , @required this.item}) : super(key: key);
  final item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 255,
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.only(left: 5, right: 5),

      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 5),
            child: AvatarImage(item["photo"],
              width: 110, height: 110, isSVG: false, borderColor: ColorConstants.accentColor,
            ),
            // ),
          ),
          SizedBox(height: 15,),
          Text(item["medicineName"],
              maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: ColorConstants.primary ,fontWeight: FontWeight.w600)
          ),
          SizedBox(height: 8,),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(text: '£' " " + item["sellingPrice"], style: TextStyle(fontSize: 16, color: ColorConstants.primary ,fontWeight: FontWeight.w500)),
                    TextSpan(text: "   "),
                    TextSpan(text: '£' " " +item["originalPrice"],
                        style: TextStyle(color: Colors.grey, fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500)
                    ),
                  ]
              )
          )
        ],
      ),
    );
  }
}