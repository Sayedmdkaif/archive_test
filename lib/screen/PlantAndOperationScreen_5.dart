import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/LocationController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/screen/OperationScreen.dart';
import 'package:zacharchive_flutter/screen/PlantScreen_6.dart';
import 'package:zacharchive_flutter/screen/QrCode_7.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class PlantAndOperationScreen extends StatefulWidget {
  @override
  _PlantAndOperationScreenState createState() =>
      _PlantAndOperationScreenState();
}

class _PlantAndOperationScreenState extends State<PlantAndOperationScreen> {
  final double circleRadius = 70.0;
  final double circleBorderWidth = 8.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime backbuttonpressedTime = DateTime.now();
  LocationController controller = Get.put(LocationController());
  var isNetRunning = false;
  var changeStatus = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getInternetStatus();
    getAllLocations();
  }

  getLocation() async {
    var user = await getUser();
    controller.location.value = user!.data!.location!;
    controller.name.value = user.data!.name!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: ShowUp(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
              child: Column(
                children: [
                  showTopWidget(),
                  Container(
                      margin: EdgeInsets.only(left: 5, right: 5, top: 30),
                      child: Column(
                        children: [
                          Image.asset(
                            Images.logo2,
                            height: screenWidth(context) * .6,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: showImage(Images.mainButtonPlant,
                                    Strings.plantEquipment),
                              ),
                              Expanded(
                                flex: 1,
                                child: showImage(
                                    Images.mainButtonOps, Strings.operation),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: 20.marginBottom(),
                          height: 100,
                          child: showImage(Images.scanImage, Strings.scan),
                        ),
                        showDivider(
                            context: context,
                            top: 20,
                            color: Colors.white,
                            width: screenWidth(context) / 2.5,
                            height: 2,
                            thickness: 4)
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showImage(String image, String from) {
    return GestureDetector(
      onTap: () {
        print('clickKaif' + isNetRunning.toString());

        if (from == Strings.plantEquipment) if (isNetRunning)
          PlantScreen().navigate();
        else
          Strings.checkInternet.toast();
        else if (from == Strings.operation) if (isNetRunning)
          OperationScreen().navigate();
        else
          Strings.checkInternet.toast();
        else if (from == Strings.scan) QrCode().navigate();

        /* else
              SearchPlantScreen(from).navigate();*/
      },
      child: SvgPicture.asset(
        image,
        height: 120,
        width: double.infinity,
      ),
    );
  }

  Widget showTopWidget() {
    print('menuCalled');

    return GetX<LocationController>(builder: (controller) {
      return Padding(
        padding: 5.paddingAll(),
        child: Row(children: [
          SvgPicture.asset(
            Images.logoWhite,
            width: 10,
            height: 50,
          ),
          Expanded(
              child: Container(
            margin: 10.marginTop(),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              //showLocation(controller),

              showLocationDropdown(controller),
              showNotificationDrawerMenu(
                  isShowNotification: true, context: context)
            ]),
          )),
        ]),
      );
    });
  }

/*  Row showLocation(LocationController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: screenWidth(context) * .2,
          child: showText(
              color: Colors.white,
              text: controller.location.value,
              textSize: 18,
              fontweight: FontWeight.w300,
              maxlines: 1),
        ),
        1.verticalSpace(),
        Icon(
          Icons.location_pin,
          color: Colors.white,
          size: 20,
        ),
        20.verticalSpace(),
      ],
    );
  }*/

  Widget showLocationDropdown(LocationController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: screenWidth(context) * getSize(),
          child: IgnorePointer(
            ignoring: false,
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent))),
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.black,
              isExpanded: true,
              hint: Text(controller.location.value),
              value: controller.location.value,
              onChanged: (newValue) {
                controller.location.value = newValue as String;

                getSelectedLocationId();

                hideKeyboard(context);
              },
              items: controller.locationList.map((location) {
                return DropdownMenuItem(
                  child: new Text(location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                  value: location,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void callUpdateUserLocationAPI() async {
    hideKeyboard(context);
    if (await checkInternet()) {
      launchProgress2(context: context);

      ApiCommonModal modal = await controller.updateUserLocationAPI();

      disposeProgress();
      if (modal.status == "1") {
        var user = await getUser();

        user!.data!.location = controller.location.value;

        await saveUser(user);
        'Location Updated Successfully'.toast();
      } else
        Strings.went_wrong.toast();
    } else
      Strings.checkInternet.toast();
  }

  Future<void> getSelectedLocationId() async {
    var user = await getUser();
    for (var f in user!.data!.allLocations!
        .where((item) => item.city == controller.location.value)) {
      controller.selectedLocationId.value = f.id!.toString();

      break;
    }

    print('selectedLocId' + controller.selectedLocationId.value);

    if (changeStatus == 1) callUpdateUserLocationAPI();
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

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton =
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      "Please click back again to exit".toast();
      return false;
    }

    //print('exitcalled');
    //return false;
    exit(0);
    return true;
  }

  void getInternetStatus() async {
    if (await checkInternet()) isNetRunning = true;

    var subscription = await Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none)
        isNetRunning = false;
      else
        isNetRunning = true;

      print('result' + result.toString());
      print('ResultKaif' + isNetRunning.toString());
    });

    print('isNetRunning' + isNetRunning.toString());
  }

  num getSize() {
    return controller.location.value.length > 10 ? .4 : .3;
  }
}
