import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/screen/LoginScreen_2.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    hideKeyboard(context);
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          closeAPP();
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
                height: screenHeight(context),
                padding: 16.paddingAll(),
                width: screenWidth(context),
                child: ShowUp(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        Images.logoWhite,
                        height: screenWidth(context) / 4,
                      ),
                      30.horizontalSpace(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Images.logo2,
                            height: screenWidth(context) * .6,
                          ),
                          10.horizontalSpace(),
                          Container(
                              margin: EdgeInsets.only(left: 30, right: 30),
                              child: showText(
                                  color: Colors.white,
                                  text: Strings.dummy,
                                  textSize: 12,
                                  fontWeight: FontWeight.normal,
                                  maxlines: 3))
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [showImage(Images.buttonStart, "start")],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showImage(String image, String from) {
    return GestureDetector(
      onTap: () {
        LoginScreen().navigate(isRemove: true);
      },
      child: SvgPicture.asset(
        image,
        height: 120,
        width: double.infinity,
      ),
    );
  }
}
