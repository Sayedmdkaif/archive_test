import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';

import 'Theme.dart';


//convert date from yyyy-MM-dd hh:mm:ss to dd-MMM-yyyy hh:mm:ss format
String convertDate(String input)
{

  var inputFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
  var date1 = inputFormat.parse(input);

  var outputFormat = DateFormat("dd-MMM-yyyy hh:mm:ss a");
  var date2 = outputFormat.format(date1);

  return date2;

}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}


double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}




bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,15}$)';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

double getstatusBarHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

bool isEmail(String em) {
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(em);
}

String randomString(int strlen) {
  var alpha = "ARBAEROMCBHAKJJNKKWROJOAIIAHRAMNSNDFNWNNWNXBFBWFEWUEWBBEUWEWBFBWBZKAKKNAKNBWWARAHNAKNAN";
  var numeric = "1234567890987654321123451234567890678900987654321";

  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 1; i < strlen + 1; i++) {
    if (i % 2 == 0)
      result += alpha[rnd.nextInt(alpha.length)];
    else
      result += numeric[rnd.nextInt(numeric.length)];
  }
  return result;
}


launchProgress({
  required BuildContext context,
  String message = 'Processing..',
}) {
  CustomDialog(context,
      durationmilliseconds: 1,
      isLoader: true,
      barrierDismissible: false,
      widget: Center(child: CircularProgressIndicator()));
}


launchProgress2({
  required BuildContext context,
  String message = 'Processing..',
}) {
  CustomDialog(context,
      durationmilliseconds: 1,
      isLoader: true,
      barrierDismissible: false,
      widget: Center(child: Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(15)),
color: Colors.white
          ),
          width: 70,
          height: 70,
          child: showAnimationLoading())));
}

Widget showAnimationLoading() {


  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: LoadingBouncingGrid.circle(
      borderColor: Colors.white,
      borderSize: 3.0,
      size: 40.0,
      backgroundColor: darkBlue2,
      duration: Duration(milliseconds: 500),
    ),
  );
}

disposeProgress() {
  Get.back();
}
