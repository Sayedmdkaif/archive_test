import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/RegisterController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class ChangePassword extends StatefulWidget {
  String from;
  String id;

  ChangePassword(this.from, this.id);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  RegisterController controller = Get.put(RegisterController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller.oldPasswordController.text = '';
    controller.passwordController.text = '';
    controller.cPasswordController.text = '';
  }

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
                            margin: 100.marginBottom(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 30, right: 30),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
                                        widget.from != Strings.forget
                                            ? 25.horizontalSpace()
                                            : 0.horizontalSpace(),
                                        widget.from != Strings.forget
                                            ? showOldPasswordWidget()
                                            : 0.horizontalSpace(),
                                        20.horizontalSpace(),
                                        showPasswordWidget(),
                                        20.horizontalSpace(),
                                        showConfirmPasswordWidget(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      showAddImage(),
                    ],
                  ),
                ],
              ),
            ));
      }),
    );
  }

  Widget showAddImage() {
    changeColor();

    final double circleRadius = 70.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: circleRadius / 2.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colorAccent,
                  gradient: new LinearGradient(
                      colors: [
                        colorAccent,
                        lightAccentColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                height: 70.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showImage(
                    image: Images.buttonChange,
                    height: 95,
                    from: Strings.changePwd),
              ],
            ),
            showDivider(
                context: context,
                top: 100,
                color: Colors.white,
                width: screenWidth(context) / 2.5,
                height: 2,
                thickness: 4)
          ],
        ),
      ],
    );
  }

  showImage(
      {required String image, required double height, required String from}) {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState!.validate()) callChangePwdAPI();
      },
      child: SvgPicture.asset(
        image,
        height: height,
        width: 50,
      ),
    );
  }

  showTopWidget() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
      child: Padding(
        padding: 5.paddingAll(),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      hideKeyboard(context);
                      pressBack();
                    },
                    child: backButton()),
              ),
              5.verticalSpace(),
              Expanded(
                flex: 7,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showText(
                          color: Colors.white,
                          text: "  Change Password",
                          textSize: 20,
                          fontWeight: FontWeight.w400,
                          maxlines: 1)
                    ],
                  ),
                ),
              ),
              //  showNotificationDrawerMenu(showLocation: false, isShowNotification: true,context:context),
            ]),
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
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value!.isEmpty)
          return 'Please enter old password';
        /*  else if (!Strings.validatePassword(value.trim()))
          return Strings.passwordHint;*/
        else {
          return null;
        }
      },
      controller: controller.oldPasswordController,
      cursorColor: Theme.of(context).cursorColor,
      autocorrect: true,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
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
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value!.isEmpty)
          return 'Please enter new password';
        else if (!Strings.validatePassword(value.trim()))
          return Strings.passwordHint;
        else {
          controller.passwordValue.value = value;
          return null;
        }
      },
      controller: controller.passwordController,
      cursorColor: Theme.of(context).cursorColor,
      autocorrect: true,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      obscureText:
          enableObscureText == true ? controller.passwordVisible.value : false,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 12.0,
        ),
        errorMaxLines: 2,
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
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value!.isEmpty)
          return 'Please enter confirm new password';
        else if (!Strings.validatePassword(value.trim()))
          return Strings.passwordHint;
        else if (value.toString().trim() !=
            controller.passwordValue.value.trim()) {
          return 'Confirm password does not match';
        } else
          return null;
      },
      controller: controller.cPasswordController,
      cursorColor: Theme.of(context).cursorColor,
      autocorrect: true,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      obscureText:
          enableObscureText == true ? controller.cPasswordVisible.value : false,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 12.0,
        ),
        errorMaxLines: 2,
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

  void callChangePwdAPI() async {
    hideKeyboard(context);
    if (await checkInternet()) {
      launchProgress2(context: context);

      ApiCommonModal modal;

      if (widget.from == Strings.forget)
        modal = await controller.updatePasswordAPI(id: widget.id);
      else
        modal = await controller.updateProfilePasswordAPI();

      // print('idakfi'+widget.id);
      print('changeRes' + modal.status! + " " + widget.from);

      disposeProgress();
      if (modal.status == "1") {
        successAlertSecond(
            context, Strings.successPasswordUpdated, widget.from);
        if (widget.from == Strings.profile)
          setPrefrenceData(
              data: controller.passwordController.getValue(),
              key: Strings.rememberPassword);
      } else if (modal.status == "0")
        "Please enter valid old password".toast();
      else
        Strings.went_wrong.toast();
    } else
      Strings.checkInternet.toast();
  }
}
