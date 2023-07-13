import 'package:pharmacy_app/utilities/colors.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'login.dart';

class IntroWalkthrough extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IntroWalkthroughState();
}

class IntroWalkthroughState extends State<IntroWalkthrough> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle:
      TextStyle(color: ColorConstants.bottomBarColor, fontSize: 16),
      bodyTextStyle: bodyStyle,
      titlePadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: ColorConstants.bgColor,
      imagePadding: EdgeInsets.zero,
    );

    return Stack(fit: StackFit.loose, alignment: Alignment.center, children: [
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 25, right: 25, top: 30),
          color: ColorConstants.bgColor,
//            margin:checkConnectivity(connectionStatus)
//                ? EdgeInsets.only(top: 0):EdgeInsets.only(top: 50),
          child: IntroductionScreen(
            //key: introKey,
            pages: [
              PageViewModel(
                title:
                "Smart Pharmacy is an app to provide artist store owner to store and display medicines",
                body: "",
                image: buildPngImage('drugstore',200,200),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Pharmacy Store owner can add medicine with discounted price",
                body: "",
                image: buildPngImage('add_medicine',200,200),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Customer can view medicines and order medicines which are not available",
                body: "",
                image: buildPngImage('add',200,200),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title:
                "Start your medicine search",
                body: "",
                image: buildPngImage('drug',200,200),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => onIntroEnd(context),
            onSkip: () => onIntroEnd(context),
            showSkipButton: true,
            dotsFlex: 0,
            nextFlex: 0,
            skip: Text(
              "SKIP",
              style: TextStyle(color: ColorConstants.bottomBarColor),
            ),
            next: nextStep(),
            done: nextStep(),
            dotsDecorator: DotsDecorator(
              size: Size(10.0, 10.0),
              color: ColorConstants.shadowColor.withOpacity(0.1),
              activeColor: ColorConstants.bottomBarColor,
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          )),
    ]);
//    });
  }

  void onIntroEnd(context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  Widget nextStep() {
    return Container(
      height: 30,
      width: 30,
      child: Icon(
        Icons.arrow_forward,
        color: ColorConstants.bottomBarColor,
      ),
    );
  }
}
