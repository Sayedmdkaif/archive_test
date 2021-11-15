import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/CustomTextField.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/LoginController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/LoginModal.dart';
import 'package:zacharchive_flutter/screen/ForgetScreen_4.dart';
import 'package:zacharchive_flutter/screen/PlantAndOperationScreen_5.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController controller = Get.put(LoginController());
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
    print('loginInitCalled');

    getRememberDetails();

    //controller.emailController.text ='https://www.mysic.io/?album_id=3242';
    //controller.emailController.text ='mohd.kaif@logicsimplified.com';
    //controller.passwordController.text ='111111';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Get.back();
          return true;
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
              height: screenHeight(context),
              padding: 16.paddingAll(),
              width: screenWidth(context),
              child: ShowUp(
                child: GetX<LoginController>(builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        Images.logoWhite,
                        height: screenWidth(context) / 5,
                      ),
                      20.horizontalSpace(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Images.logo2,
                            height: screenWidth(context) * .4,
                          ),
                          10.horizontalSpace(),
                          Container(
                            margin: EdgeInsets.only(left: 30, right: 30),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  showEmailWidget(),
                                  15.horizontalSpace(),
                                  showPasswordWidget(),
                                  10.horizontalSpace(),
                                  showRememberMe(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: 30.marginBottom(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              showImage(Images.buttonLogin, "start"),
                              /* showText(
                                  color: Colors.white,
                                  text: 'New User?',
                                  textSize: 14,
                                  fontweight: FontWeight.normal,
                                  maxlines: 1),
                              GestureDetector(
                                onTap: () {
                                  RegisterScreen("").navigate();
                                },
                                child: showTextUnderline(
                                    color: darkBlue2,
                                    text: 'Sign up here',
                                    textSize: 14,
                                    fontweight: FontWeight.normal,
                                    maxlines: 1),
                              ),*/
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
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

  Widget showPasswordWidget() {
    var enableObscureText = true;
    var showSuffixIcon = true;

    return TextFormField(
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty)
          return 'Please enter password';
        else
          return null;
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

  showImage(String image, String from) {
    return GestureDetector(
      onTap: () async {
        if (formKey.currentState!.validate()) {
          if (controller.isChecked.value)
            saveEmailAndPassword(controller.emailController.value.text,
                controller.passwordController.value.text);
          else
            removeRememberDetails();

          callLoginAPI();
        }
      },
      child: SvgPicture.asset(
        image,
        height: 120,
        width: double.infinity,
      ),
    );
  }

  Widget showRememberMe() {
    return Row(
      children: [
        TaskCheckbox(
          checkboxState: controller.isChecked.value,
          toggleCheckboxState: checkBoxCallBack,
        ),
        5.verticalSpace(),
        showText(
            color: Colors.white,
            text: 'Remember Me',
            textSize: 12,
            fontWeight: FontWeight.normal,
            maxlines: 1),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                ForgetScreen().navigate();
              },
              child: showText(
                  color: Colors.white,
                  text: 'Forgot Password?',
                  textSize: 12,
                  fontWeight: FontWeight.normal,
                  maxlines: 1),
            ),
          ],
        ))
      ],
    );
  }

  void saveEmailAndPassword(String email, String password) {
    print('saveRememberDetails');
    setPrefrenceData(data: email, key: Strings.rememberEmail);
    setPrefrenceData(data: password, key: Strings.rememberPassword);
  }

  void getRememberDetails() async {
    await Future.delayed(Duration(seconds: 1));

    print('remberCalled');

    var rememberEmail =
        await getPrefrenceData(defaultValue: '', key: Strings.rememberEmail);
    var rememberPassword =
        await getPrefrenceData(defaultValue: '', key: Strings.rememberPassword);

    try {
      print('remberCalledEmail' + rememberEmail);
    } catch (e) {
      print('remberCalledEmai_Excep');
    }

    if (rememberEmail != null) {
      print('rememberEmail' + rememberEmail);
      print('rememberPassword' + rememberPassword);

      controller.emailController.text = rememberEmail;
      controller.passwordController.text = rememberPassword;
      controller.isChecked.value = true;
    } else {
      print('RemberEmail_is_Null');
      controller.emailController.text = '';
      controller.passwordController.text = '';
      controller.isChecked.value = false;
    }
  }

  Future<void> removeRememberDetails() async {
    await removPrefrenceData(key: Strings.rememberEmail);
    await removPrefrenceData(key: Strings.rememberPassword);
  }

  void callLoginAPI() async {
    hideKeyboard(context);
    if (await checkInternet()) {
      launchProgress2(context: context);

      LoginModal loginModal = await controller.loginAPI();

      disposeProgress();
      if (loginModal.status == "1") {
        await saveUser(loginModal);
        PlantAndOperationScreen().navigate(isRemove: true);
      } else
        "Email or password is incorrect".toast();
    } else
      Strings.checkInternet.toast();
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
