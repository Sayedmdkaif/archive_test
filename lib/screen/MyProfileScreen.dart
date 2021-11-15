import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/CustomTextField.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/LocationController.dart';
import 'package:zacharchive_flutter/controllers/MyProfileController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/screen/ChangePassword.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  MyProfileController controller = Get.put(MyProfileController());
  final formKey = GlobalKey<FormState>();
  var updateStatus = false;
  var changeStatus = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllLocations();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: updateStatus ? Strings.update : Strings.notUpdate);
        return true;
      },
      child: SafeArea(
        child: GetX<MyProfileController>(builder: (controller) {
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
                                    margin:
                                        EdgeInsets.only(left: 30, right: 30),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          20.horizontalSpace(),
                                          showNameWidget(),
                                          15.horizontalSpace(),
                                          showEmailWidget(),
                                          15.horizontalSpace(),
                                          showCompanyNameWidget(),
                                          15.horizontalSpace(),
                                          // showLocationWidget(),
                                          showText(
                                              color: darkBlue2,
                                              text: Strings.selectLocation,
                                              textSize: 14,
                                              fontWeight: FontWeight.w400,
                                              maxlines: 1),
                                          showLocationDropdown(),
                                          15.horizontalSpace(),
                                          showPhoneWidget(),
                                          25.horizontalSpace(),
                                          showChangePasswordModify(),
                                          10.horizontalSpace(),
                                          showDivider(
                                              context: context,
                                              top: 2,
                                              color: Colors.grey,
                                              width: screenWidth(context),
                                              height: 1,
                                              thickness: .4),
                                          30.horizontalSpace(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        showEditImage(),
                      ],
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }

  Widget showNameWidget() {
    return CustomTextField(
      fillColor: Colors.white,
      cursorColor: Colors.black,
      radius: 1,
      enabled: controller.edited.value ? true : false,
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
          fontSize: 16,
          color: controller.edited.value ? Colors.black : Colors.grey,
          fontWeight: FontWeight.normal),
    );
  }

  Widget showCompanyNameWidget() {
    return CustomTextField(
      fillColor: Colors.white,
      cursorColor: Colors.black,
      radius: 1,
      enabled: /*controller.edited.value?true:*/ false,
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
          color: /*controller.edited.value?Colors.black:*/ Colors.grey,
          fontWeight: FontWeight.normal),
    );
  }

  Widget showLocationDropdown() {
    //true=disabled
    //false=enabled
    return Container(
      height: 40,
      child: IgnorePointer(
        ignoring: controller.edited.value &&
                controller.changeLocationStatus.value == 1
            ? false
            : true,
        child: DropdownButtonFormField(
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
          iconEnabledColor: Colors.black,
          isExpanded: true,
          hint: Text(
            controller.locationController.getValue(),
          ),
          value: controller.locationController.getValue(),
          onChanged: (newValue) {
            controller.locationController.text = newValue as String;

            getSelectedLocationId();

            hideKeyboard(context);
          },
          items: controller.locationList.map((location) {
            return DropdownMenuItem(
              child: new Text(location,
                  style: controller.edited.value &&
                          controller.changeLocationStatus.value == 1
                      ? controller.dropDownTextStyle2.value
                      : controller.dropDownTextStyle1.value),
              value: location,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget showLocationWidget() {
    return CustomTextField(
      cursorColor: Colors.black,
      fillColor: Colors.white,
      radius: 1,
      enabled: /*controller.locationEdited.value?true:*/ false,
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
          color: /*controller.locationEdited.value?Colors.black:*/ Colors.grey,
          fontWeight: FontWeight.normal),
    );
  }

  Widget showPhoneWidget() {
    return CustomTextField(
      cursorColor: Colors.black,
      fillColor: Colors.white,
      radius: 1,
      isNumber: true,
      enabled: controller.edited.value ? true : false,
      iconColor: Colors.black,
      boarder: false,
      keyboardType: TextInputType.number,
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
          fontSize: 16,
          color: controller.edited.value ? Colors.black : Colors.grey,
          fontWeight: FontWeight.normal),
    );
  }

  Widget showEmailWidget() {
    return CustomTextField(
      fillColor: Colors.white,
      cursorColor: Colors.black,
      radius: 1,
      enabled: false,
      iconColor: Colors.black,
      boarder: false,
      labelStyle: TextStyle(color: darkBlue2),
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
      textStyle: GoogleFonts.poppins(
          fontSize: 16, color: Colors.grey, fontWeight: FontWeight.normal),
    );
  }

  Widget showEditImage() {
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
                    image: controller.edited.value
                        ? Images.buttonTick
                        : Images.buttonEdit,
                    height: 70,
                    from: Strings.scan),
              ],
            ),
            showDivider(
                context: context,
                top: 90,
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
      onTap: () async {
        print('NotcallUpdate' + controller.edited.value.toString());
        print('isFormValid' + formKey.currentState!.validate().toString());
        var user = await getUser();

        if (formKey.currentState!.validate() && controller.edited.value) {
          /* if(controller.selectedLocations.value==Strings.selectLocation)
          "Please select location".toast();*/
          //else
          callUpdateProfileAPI();
        }

        controller.edited.value = !controller.edited.value;

        if (controller.edited.value)
          controller.dropDownTextStyle2.value = TextStyle(color: Colors.black);
        else
          controller.dropDownTextStyle2.value =
              TextStyle(color: Colors.black54);
      },
      child: SvgPicture.asset(
        image,
        height: height,
        width: 50,
      ),
    );
  }

  void callUpdateProfileAPI() async {
    print('callUpdate');
    hideKeyboard(context);
    if (await checkInternet()) {
      launchProgress2(context: context);

      ApiCommonModal modal = await controller.updateProfileAPI(
          name: controller.nameController.getValue(),
          phone: controller.phoneController.getValue());

      disposeProgress();
      if (modal.status == "1") {
        var user = await getUser();

        user!.data!.name = controller.nameController.getValue();
        user.data!.phone = controller.phoneController.getValue();
        user.data!.location = controller.locationController.getValue();

        LocationController locationController = Get.find();
        locationController.location.value =
            controller.locationController.getValue();

        await saveUser(user);
        updateStatus = true;
        successAlertSecond(context, Strings.successProfileUpdated, '');
      } else
        Strings.went_wrong.toast();
    } else
      Strings.checkInternet.toast();
  }

  Widget showTopWidget() {
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
                      pressBack(
                          result: updateStatus
                              ? Strings.update
                              : Strings.notUpdate);
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
                          text: "  My Profile",
                          textSize: 20,
                          fontWeight: FontWeight.w400,
                          maxlines: 1)
                    ],
                  ),
                ),
              ),
              showNotificationDrawerMenu(
                  isShowNotification: true, context: context),
            ]),
      ),
    );
  }

  Future<void> changeColor() async {
    await Future.delayed(Duration(milliseconds: 1200));

    controller.color.value = colorAccent;
  }

  Widget showChangePasswordModify() {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  showText(
                      color: red2,
                      text: "Change Password",
                      textSize: 18,
                      fontWeight: FontWeight.w500,
                      maxlines: 1),
                  10.horizontalSpace(),
                  Container(
                      width: screenWidth(context) / 6,
                      child: MyDottedSeparator())
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    hideKeyboard(context);
                    ChangePassword(Strings.profile, '').navigate();
                  },
                  child: showTextUnderline(
                      color: colorAccent,
                      text: "Modify",
                      textSize: 18,
                      fontweight: FontWeight.w500,
                      maxlines: 1),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> getUserDetails() async {
    var user = await getUser();

     controller.nameController.text = user!.data!.name!;
   // controller.nameController.text = 'https://www.exampletest.com/kaif';
    controller.emailController.text = user.data!.email!;
    controller.companyNameController.text = user.data!.company!;
    controller.locationController.text = user.data!.location!;
    controller.phoneController.text = user.data!.phone!;
    controller.changeLocationStatus.value = user.data!.changeLocation!;
  }

  Future<void> getAllLocations() async {
    var user = await getUser();

    changeStatus = user!.data!.changeLocation!;
    print('BeforeLocation' + user.data!.allLocations.toString());
    controller.locationList.clear();
    if (changeStatus == 1) {
      for (int i = 0; i < user.data!.allLocations!.length; i++)
        controller.locationList.add(user.data!.allLocations![i].city!);
    } else
      controller.locationList.add(user.data!.location);

    print('locationList' + controller.locationList.toString());
  }

  Future<void> getSelectedLocationId() async {
    var user = await getUser();
    for (var f in user!.data!.allLocations!.where(
        (item) => item.city == controller.locationController.getValue())) {
      controller.selectedLocationId.value = f.id!.toString();

      break;
    }

    print('selectedLocId' + controller.selectedLocationId.value);
  }
}
