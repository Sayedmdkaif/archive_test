import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';


 extension Utility on String {

   toast() => Fluttertoast.showToast(
     gravity: ToastGravity.BOTTOM,
         msg: this,
         backgroundColor: colorPrimary,
         textColor: Colors.white,
         toastLength: Toast.LENGTH_SHORT,
       );
 }

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension feild on TextEditingController {
  String value() => this.text.toString();
}

extension controller on TextEditingController {
  getValue() => this.text.toString();
}




//works on onTap
pressBack<T>({T? result}) {
  Get.back(result:result);
}


extension customWidget on Widget {


  onTap(Function onTap) {
    return InkWell(
      onTap: onTap(),
      child: this,
    );
  }

  //works on widget

  pressBack<T>({T? result}) {
    return InkWell(
      onTap: () {

        Get.back(result: result);
      },
      child: this,
    );
  }

  navigate(
      {bool isAwait = false,
      bool isRemove = false,
    bool isInfinity = false}) async {
    if (isRemove)
      Get.off(this, transition: Transition.rightToLeftWithFade);
    else if (isAwait)
      return await Get.to(this, transition: Transition.rightToLeftWithFade);
    else if (isInfinity)
      Get.offAll(this, transition: Transition.rightToLeftWithFade);
    else
      Get.to(this, transition: Transition.rightToLeftWithFade);
  }
}

extension Integer on int {
  delay(Function function) {
    Future.delayed(Duration(seconds: this), () {
      function();
    });
  }

  horizontalSpace() => SizedBox(height: this.toDouble());

  verticalSpace() => SizedBox(width: this.toDouble());


  loop(Function function) {
    for (var i = 0; i < this; i++) {
      function(i);
    }
  }

  paddingLeft() {
    return EdgeInsets.only(left: this.toDouble());
  }

  paddingTop() {
    return EdgeInsets.only(top: this.toDouble());
  }

  paddingAll() {
    return EdgeInsets.all(this.toDouble());
  }

  paddingRight() {
    return EdgeInsets.only(right: this.toDouble());
  }

 paddingBottom() {
    return EdgeInsets.only(bottom: this.toDouble());
  }

  paddingHorizontal() {
    return EdgeInsets.only(top: this.toDouble(), bottom: this.toDouble());
  }

  paddingVertical() {
    return EdgeInsets.only(left: this.toDouble(), right: this.toDouble());
  }

  marginAll() {
    return EdgeInsets.all(this.toDouble());
  }

  marginLeft() {
    return EdgeInsets.only(left: this.toDouble());
  }

 marginBottom() {
    return EdgeInsets.only(bottom: this.toDouble());
  }

  marginTop() {
    return EdgeInsets.only(top: this.toDouble());
  }

  marginRight() {
    return EdgeInsets.only(right: this.toDouble());
  }

  marginHorizontal() {
    return EdgeInsets.only(top: this.toDouble(), bottom: this.toDouble());
  }

  marginVertical() {
    return EdgeInsets.only(left: this.toDouble(), right: this.toDouble());
  }
}

extension OnWidget on BuildContext {
  pop() {
    Navigator.pop(this);
  }
}
