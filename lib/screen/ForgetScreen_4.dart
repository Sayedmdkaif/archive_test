import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/CustomTextField.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/ForgetPwdController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/screen/ChangePassword.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  ForgetPwdController controller = Get.put(ForgetPwdController());
  final formKey = GlobalKey<FormState>();
  String inputOTP = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
          height: screenHeight(context),
          width: screenWidth(context),
          child: ShowUp(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                100.horizontalSpace(),
                showText(
                    color: darkBlue2,
                    text: Strings.forgetPwd,
                    textSize: 20,
                    fontWeight: FontWeight.w500,
                    maxlines: 1),
                40.horizontalSpace(),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: showText(
                      color: Colors.white,
                      text: Strings.forgetPwdDesc,
                      textSize: 16,
                      fontWeight: FontWeight.w300,
                      maxlines: 5),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [showEmailWidget()],
                        ),
                      ),
                    ),
                  ],
                ),
                50.horizontalSpace(),
                Container(
                  margin: 20.marginBottom(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      showImage(Images.buttonProceed, "start"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: showTextUnderline(
                      color: Colors.red,
                      text: Strings.cancel,
                      textSize: 18,
                      fontweight: FontWeight.w500,
                      maxlines: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showEmailWidget() {
    return CustomTextField(
      cursorColor: Colors.white,
      radius: 1,
      labelStyle: TextStyle(color: darkBlue2),
      iconColor: Colors.black,
      boarder: false,
      keyboardType: TextInputType.emailAddress,
      hintStyle: TextStyle(color: darkBlue2),
      controller: controller.emailController,
      autoFocus: false,
      validator: (value) {
        if (value.isEmpty)
          return 'Please enter email';
        else if (!Strings.isEmail(value.trim()))
          return 'Please enter valid email';
        else {
          return null;
        }
      },
      hint: Strings.email,
      textStyle: GoogleFonts.nunito(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
    );
  }

  showImage(String image, String from) {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState!.validate()) {
          callForgetPwdAPI();
        }
      },
      child: SvgPicture.asset(
        image,
        height: 120,
        width: double.infinity,
      ),
    );
  }

  void callForgetPwdAPI() async {
    hideKeyboard(context);
    if (await checkInternet()) {
      launchProgress2(context: context);

      ApiCommonModal modal = await controller.forgetPasswordAPI();
      print('modalstatu' + modal.status!);

      disposeProgress();
      if (modal.status == "1") {
        showOTPBottomSheet(modal.data!.id!);
        //show verify otp bottom sheet
      } else {
        "This Email Id is not registered".toast();
        //showOTPBottomSheet();
      }
    } else
      Strings.checkInternet.toast();
  }

  showOTPBottomSheet(String? id) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: 280,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              20.horizontalSpace(),
                              Text(
                                'OTP has been sent to your email id',
                                style: GoogleFonts.poppins(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              50.horizontalSpace(),
                              Container(
                                margin: 0.marginVertical(),
                                child: OTPTextField(
                                  length: 4,
                                  fieldWidth: 45,
                                  width: MediaQuery.of(context).size.width,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.box,
                                  onCompleted: (pin) {
                                    print("Completed: " + pin);
                                    inputOTP = pin;
                                  },
                                ),
                              ),
                              40.horizontalSpace(),
                              CustomButton(context,
                                  height: 50,
                                  textStyle: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  borderRadius: 35,
                                  text: Strings.submit, onTap: () async {
                                if (inputOTP.length == 4) {
                                  hideKeyboard(context);
                                  if (await checkInternet()) {
                                    launchProgress(context: context);
                                    print('inputOTP' + inputOTP);
                                    print('id' + id!);

                                    var res = await controller.verifyOTPAPI(
                                        id: id, otp: inputOTP);
                                    print('resultkaif' + res.status.toString());
                                    disposeProgress();

                                    if (res.status == "1") {
                                      Get.back();
                                      ChangePassword(Strings.forget, id)
                                          .navigate();
                                    } else
                                      "Please enter valid OTP".toast();
                                  } else
                                    Strings.checkInternet.toast();
                                } else
                                  "Please enter  OTP".toast();
                              }),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
