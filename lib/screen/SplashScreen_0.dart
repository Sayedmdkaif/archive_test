import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/controllers/SplashController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<SplashController>(
            init: SplashController(),
            builder: (controller) {
              return ShowUp(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Images.bgImage),
                          fit: BoxFit.cover)),
                  child: Padding(
                    padding: 20.paddingAll(),
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        Images.logoWhite,
                        width: screenWidth(context),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
