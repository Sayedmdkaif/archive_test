import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/CustomTextField.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/RegisterController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/modals/UserDetailModal.dart';
import 'package:zacharchive_flutter/screen/LoginScreen_2.dart';
import 'package:zacharchive_flutter/screen/WebviewWidget.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class RegisterScreen extends StatefulWidget {
  //List<MapEntry<String, List<String>>>? queryParams;
  String queryParams;
  String id = "";

  //RegisterScreen(this. queryParams);
  RegisterScreen(this.queryParams);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterController controller = Get.put(RegisterController());
  final formKey = GlobalKey<FormState>();

  void checkBoxCallBack(bool? checkBoxState) {
    if (checkBoxState != null) {
      controller.isChecked.value = checkBoxState;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('kaifData' + widget.queryParams);

    if (widget.queryParams.isNotEmpty) {
      var message = "success" + widget.queryParams.toString();

      //  message.toast();

      callGetUserDetailsAPI();
    }
    //else
    /*  "failed".toast();*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
              child: Container(
                child: ShowUp(
                  child: GetX<RegisterController>(builder: (controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        5.horizontalSpace(),
                        SvgPicture.asset(
                          Images.logoWhite,
                          height: screenWidth(context) / 7,
                        ),
                        10.horizontalSpace(),
                        showText(
                            color: darkBlue2,
                            text: 'Sign Up',
                            textSize: 18,
                            fontWeight: FontWeight.normal,
                            maxlines: 1),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            10.horizontalSpace(),
                            Container(
                              margin: EdgeInsets.only(left: 30, right: 30),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    showNameWidget(),
                                    10.horizontalSpace(),
                                    showEmailWidget(),
                                    10.horizontalSpace(),
                                    showCompanyNameWidget(),
                                    10.horizontalSpace(),
                                    showLocationWidget(),
                                    10.horizontalSpace(),
                                    showPhoneWidget(),
                                    10.horizontalSpace(),
                                    showPasswordWidget(),
                                    10.horizontalSpace(),
                                    showConfirmPasswordWidget(),
                                    10.horizontalSpace(),
                                    showPolicyCheckbox(),
                                    30.horizontalSpace(),
                                    showBottomWidget(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showNameWidget() {
    return CustomTextField(
      cursorColor: Colors.white,
      radius: 1,
      iconColor: Colors.black,
      boarder: false,
      labelStyle: TextStyle(color: darkBlue2),
      keyboardType: TextInputType.name,
      hintStyle: TextStyle(color: darkBlue2),
      controller: controller.nameController,
      autoFocus: false,
      validator: (value) {
        if (value.isEmpty)
          return 'Please enter name';
        else if (value.trim().isEmpty)
          return 'Please enter valid name';
        else if (value.trim().length < 3)
          return 'Please enter valid name';
        else if (value.length < 3 || value.length > 25)
          return 'Please use character between 3 to 25';
        else
          return null;
      },
      hint: Strings.name,
      textStyle: GoogleFonts.poppins(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
    );
  }

  Widget showCompanyNameWidget() {
    return CustomTextField(
      cursorColor: Colors.white,
      radius: 1,
      enabled: widget.queryParams == null ? true : false,
      iconColor: Colors.black,
      boarder: false,
      labelStyle: TextStyle(color: darkBlue2),
      keyboardType: TextInputType.name,
      hintStyle: TextStyle(color: darkBlue2),
      controller: controller.companyNameController,
      autoFocus: false,
      validator: (value) {
        if (value.isEmpty)
          return 'Please enter company name';
        else if (value.length < 3)
          return 'Please enter valid company name';
        else
          return null;
      },
      hint: Strings.companyName,
      textStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: widget.queryParams == null ? Colors.white : Colors.grey,
          fontWeight: FontWeight.normal),
    );
  }

  Widget showLocationWidget() {
    return CustomTextField(
      cursorColor: Colors.white,
      radius: 1,
      enabled: widget.queryParams == null ? true : false,
      iconColor: Colors.black,
      labelStyle: TextStyle(color: darkBlue2),
      boarder: false,
      keyboardType: TextInputType.name,
      hintStyle: TextStyle(color: darkBlue2),
      controller: controller.locationController,
      autoFocus: false,
      validator: (value) {
        if (value.isEmpty)
          return 'Please enter location name';
        else if (value.length < 3)
          return 'Please enter valid location name';
        else
          return null;
      },
      hint: Strings.location,
      textStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: widget.queryParams == null ? Colors.white : Colors.grey,
          fontWeight: FontWeight.normal),
    );
  }

  Widget showPhoneWidget() {
    return CustomTextField(
      cursorColor: Colors.white,
      radius: 1,
      iconColor: Colors.black,
      isNumber: true,
      boarder: false,
      keyboardType: TextInputType.phone,
      hintStyle: TextStyle(color: Colors.white),
      labelStyle: TextStyle(color: darkBlue2),
      controller: controller.phoneController,
      autoFocus: false,
      validator: (value) {
        if (value.isEmpty)
          return 'Please enter phone number';
        else if (value.length < 10 || value.length > 14)
          return 'Please enter valid phone number';
        else
          return null;
      },
      hint: Strings.phoneNumber,
      textStyle: GoogleFonts.poppins(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
    );
  }

  Widget showEmailWidget() {
    return CustomTextField(
      cursorColor: Colors.white,
      radius: 1,
      enabled: widget.queryParams == null ? true : false,
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
          fontSize: 16,
          color: widget.queryParams == null ? Colors.white : Colors.grey,
          fontWeight: FontWeight.normal),
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
          return 'Please enter password';
        else if (!Strings.validatePassword(value.trim()))
          return Strings.passwordHint;
        else {
          controller.passwordValue.value = value;
          return null;
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      controller: controller.passwordController,
      cursorColor: Theme.of(context).cursorColor,
      autocorrect: true,
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
        labelText: Strings.password,
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
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty)
          return 'Please enter confirm password';
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
        labelText: Strings.cPassword,
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

  showImage(String image, String from) {
    return GestureDetector(
      onTap: () async {
        print('isChecked' + controller.isChecked.value.toString());

        if (formKey.currentState!.validate()) {
          if (!controller.isChecked.value) {
            "Please accept the terms to proceed".toast();
          } else {
            print('runnkaifsdsdfasd');

            callRegisterAPI();
          }
        }
      },
      child: SvgPicture.asset(
        image,
        height: 120,
        width: double.infinity,
      ),
    );
  }

  void callRegisterAPI() async {
    print('registerCalled');
    hideKeyboard(context);
    if (await checkInternet()) {
      launchProgress2(context: context);

      ApiCommonModal registerModal =
          await controller.registerAPI(id: widget.id);
      disposeProgress();

      if (registerModal.status == "1") {
        successAlertSecond(context, Strings.successRegistered, 'registration');
        // LoginScreen().navigate(isRemove: true);
      } else
        Strings.went_wrong.toast();
    } else
      Strings.checkInternet.toast();
  }

  Widget showPolicyCheckbox() {
    return Row(
      children: [
        TaskCheckbox(
          checkboxState: controller.isChecked.value,
          toggleCheckboxState: checkBoxCallBack,
        ),
        5.verticalSpace(),
        Container(
          padding: 6.paddingTop(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => WebviewWidget().navigate(),
                child: showText(
                    color: Colors.white,
                    text: 'By registering you  agree to the',
                    textSize: 12,
                    fontWeight: FontWeight.normal,
                    maxlines: 1),
              ),
              GestureDetector(
                onTap: () => WebviewWidget().navigate(),
                child: showText(
                    color: Colors.grey,
                    text: 'Privacy Policy & Terms of Use',
                    textSize: 10,
                    fontWeight: FontWeight.normal,
                    maxlines: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  showBottomWidget() {
    return Container(
      margin: 10.marginBottom(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          showImage(Images.buttonSignUp, "start"),
          showText(
              color: Colors.white,
              text: 'Already have an account?',
              textSize: 14,
              fontWeight: FontWeight.normal,
              maxlines: 1),
          GestureDetector(
            onTap: () {
              //  Get.back();
              LoginScreen().navigate(isRemove: true);
            },
            child: showTextUnderline(
                color: darkBlue2,
                text: 'Login',
                textSize: 14,
                fontweight: FontWeight.normal,
                maxlines: 1),
          ),
        ],
      ),
    );
  }

  Future<void> callGetUserDetailsAPI() async {
    await Future.delayed(Duration(milliseconds: 100));
    //hideKeyboard(context);
    launchProgress2(context: context);
    UserDetailModal data = await controller.getUserDetailsFromLinkAPI(
        link: widget.queryParams + "/archive_littrell_app");
    disposeProgress();

    print('regGetStatus' + data.status!);
    print('regGetMessage' + data.message!);

    var status = "status" + data.status!;
    //  status.toast();
    // data.data!.id!.toString().toast();
    if (data.status == "1") {
      widget.id = data.data!.id!.toString();
      controller.emailController.text = data.data!.email!;
      controller.companyNameController.text = data.data!.companyName!;
      controller.locationController.text = data.data!.companyLocation!;
      controller.phoneController.text = data.data!.phone!;
    } else if (data.message!.contains("Email verified already")) {
      "Your email is already registered. Please login".toast();
      await Future.delayed(Duration(seconds: 1));
      LoginScreen().navigate(isRemove: true);
    } else
      Strings.went_wrong.toast();
  }
}

class TaskCheckbox extends StatelessWidget {
  final bool checkboxState;
  final Function toggleCheckboxState;

  TaskCheckbox(
      {required this.checkboxState, required this.toggleCheckboxState});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.white),
        child: Checkbox(
          value: checkboxState,
          onChanged: toggleCheckboxState as void Function(bool?)?,
          activeColor: Colors.white,
          checkColor: darkBlue2,
        ),
      ),
    );
  }
}
