import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/CustomTextField.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/RegisterController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class TAndCondition extends StatefulWidget {
  @override
  _TAndConditionState createState() => _TAndConditionState();
}

class _TAndConditionState extends State<TAndCondition> {
  RegisterController controller = Get.put(RegisterController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetX<RegisterController>(builder: (controller) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: controller.color.value,
            body: ShowUp(
              child: Column(
                children: [
                  showTopWidget(),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        color: Colors.white,
                        height:
                            screenHeight(context) * getScreenLength(context),
                        child: SingleChildScrollView(
                          child: Container(
                            margin: 30.marginBottom(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 20),
                                  child: showText(
                                      color: textColor2,
                                      text: Strings.textDescription,
                                      textSize: 14,
                                      fontWeight: FontWeight.w400,
                                      maxlines: 300),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      }),
    );
  }

  Container showTopWidget() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
      child: Padding(
        padding: 10.paddingAll(),
        child: Row(
          children: [
            backButton().pressBack(),
            15.verticalSpace(),
            showText(
                color: Colors.white,
                text: " " + Strings.tAndCondition,
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }

  Future<void> changeColor() async {
    await Future.delayed(Duration(milliseconds: 1200));

    controller.color.value = colorAccent;
  }

  Widget showOldPasswordWidget() {
    var enableObscureText = true;
    var showSuffixIcon = true;
    return TextFormField(
      onEditingComplete: () => getNode(context).nextFocus(),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty)
          return 'Please enter old password';
        else if (value.length < 5)
          return 'old password must be more than 5 characters';
        else {
          return null;
        }
      },
      controller: controller.oldPasswordController,
      cursorColor: Theme.of(context).cursorColor,
      autocorrect: true,
      obscureText: enableObscureText == true
          ? controller.oldPasswordVisible.value
          : false,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: darkBlue2, width: 2.0)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        labelText: Strings.oldPassword,
        labelStyle: TextStyle(
            color: darkBlue2, fontWeight: FontWeight.w400, fontSize: 16),
        suffixIcon: showSuffixIcon == true
            ? IconButton(
                icon: Icon(
                  controller.oldPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: darkBlue2,
                ),
                onPressed: () {
                  controller.oldPasswordVisible.value =
                      !controller.oldPasswordVisible.value;
                },
              )
            : null,
      ),
    );
  }

  Widget showPasswordWidget() {
    var enableObscureText = true;
    var showSuffixIcon = true;
    return TextFormField(
      onEditingComplete: () => getNode(context).nextFocus(),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty)
          return 'Please enter new password';
        else if (value.length < 5)
          return 'new password must be more than 5 characters';
        else {
          controller.passwordValue.value = value;
          return null;
        }
      },
      controller: controller.passwordController,
      cursorColor: Theme.of(context).cursorColor,
      autocorrect: true,
      obscureText:
          enableObscureText == true ? controller.passwordVisible.value : false,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: darkBlue2, width: 2.0)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        labelText: Strings.newPassword,
        labelStyle: TextStyle(
            color: darkBlue2, fontWeight: FontWeight.w400, fontSize: 16),
        suffixIcon: showSuffixIcon == true
            ? IconButton(
                icon: Icon(
                  controller.passwordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: darkBlue2,
                ),
                onPressed: () {
                  controller.passwordVisible.value =
                      !controller.passwordVisible.value;
                },
              )
            : null,
      ),
    );
  }

  Widget showConfirmPasswordWidget() {
    var enableObscureText = true;
    var showSuffixIcon = true;

    return TextFormField(
      onEditingComplete: () => getNode(context).nextFocus(),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty)
          return 'Please enter confirm new password';
        else if (value.length < 5)
          return 'Please enter atleast 6 digit newconfirm new password';
        else if (value.toString().trim() !=
            controller.passwordValue.value.trim()) {
          return 'Confirm new password do not matched';
        } else
          return null;
      },
      controller: controller.cPasswordController,
      cursorColor: Theme.of(context).cursorColor,
      autocorrect: true,
      obscureText:
          enableObscureText == true ? controller.cPasswordVisible.value : false,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: darkBlue2, width: 2.0)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0)),
        labelText: Strings.cNewPassword,
        labelStyle: TextStyle(
            color: darkBlue2, fontWeight: FontWeight.w400, fontSize: 16),
        suffixIcon: showSuffixIcon == true
            ? IconButton(
                icon: Icon(
                  controller.cPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: darkBlue2,
                ),
                onPressed: () {
                  controller.cPasswordVisible.value =
                      !controller.cPasswordVisible.value;
                },
              )
            : null,
      ),
    );
  }
}
