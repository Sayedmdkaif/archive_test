import 'package:cached_network_image/cached_network_image.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/LocationController.dart';
import 'package:zacharchive_flutter/controllers/PlantScreenController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/screen/QrCode_7.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import 'SearchPlantScreen_8.dart';

class PlantScreen extends StatefulWidget {
  @override
  _PlantScreenState createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  final double circleRadius = 70.0;
  final double circleBorderWidth = 8.0;
  PlantScreenController controller = Get.put(PlantScreenController());
  LocationController locationController = Get.find();
  var changeStatus = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  getLocation() async {
    var user = await getUser();
    locationController.location.value = user!.data!.location!;
    changeStatus = user.data!.changeLocation!;
  }

  void _refreshData() async {
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ShowUp(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
              height: screenHeight(context),
              child: Column(children: [
                showTopWidget(),
                Expanded(
                    child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(child:
                        GetX<PlantScreenController>(builder: (controller) {
                      return DeclarativeRefreshIndicator(
                          refreshing: controller.loading.value,
                          color: colorPrimary,
                          onRefresh: _refreshData,
                          child: getList());
                    })),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(child: showScanImage(context)),
                      ],
                    )
                  ],
                ))
              ])),
        ),
      ),
    );
  }

  showImage(String image, String from) {
    return GestureDetector(
      onTap: () {
        if (from == Strings.scan)
          QrCode().navigate();
        else
          SearchPlantScreen(from, "1").navigate();
      },
      child: SvgPicture.asset(
        image,
        height: 120,
        width: double.infinity,
      ),
    );
  }

  showTopWidget() {
    return Padding(
      padding: 5.paddingAll(),
      child: Row(children: [
        Expanded(
          child: backButton().pressBack(),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: EdgeInsets.only(
                left: locationController.location.value.length > 10 ? 15 : 5,
                right: 5,
                top: 5,
                bottom: 5),
            child: showText(
                color: Colors.white,
                text: " " + Strings.plant,
                textSize: 16,
                fontWeight: FontWeight.w400,
                maxlines: getLineSize(locationController)),
          ),
        ),
        Container(
            margin: 3.marginTop(),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              showLocationDropdown(locationController),
              showNotificationDrawerMenu(
                  isShowNotification: true, context: context)
            ])),
      ]),
    );
  }

  num getSize(LocationController controller) {
    return controller.location.value.length > 10 ? .4 : .3;
  }

  int getLineSize(LocationController controller) {
    return controller.location.value.length > 10 ? 2 : 1;
  }

  Widget showLocationDropdown(LocationController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: screenWidth(context) * getSize(controller),
          child: IgnorePointer(
            ignoring: false,
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent))),
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.black,
              isExpanded: true,
              hint: Text(
                controller.location.value,
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
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

      ApiCommonModal modal = await locationController.updateUserLocationAPI();

      disposeProgress();
      if (modal.status == "1") {
        var user = await getUser();
        _refreshData();
        user!.data!.location = locationController.location.value;

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
        .where((item) => item.city == locationController.location.value)) {
      locationController.selectedLocationId.value = f.id!.toString();

      break;
    }

    print('selectedLocId' + locationController.selectedLocationId.value);
    if (changeStatus == 1) callUpdateUserLocationAPI();
  }

  Widget getList() {
    var _mediaQueryData = MediaQuery.of(context);
    if (controller.plantCategoriesList.value.status == null ||
        controller.plantCategoriesList.value.status == "0") {
      if (controller.noDataFound.value)
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (ctx, index) {
            return noDataFoundWidget(_mediaQueryData.size.height, Images.logoWhite,
                "No Plant Equipment Found");
          },
        );
      else
        return Container(
          height: 100,
        );
    } else {
      return Container(
          margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 100),
          child: showGridList());
      // }
    }
  }

  Widget showGridList() {
    return GridView.builder(
      itemCount: controller.plantCategoriesList.value.data!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (
        context,
        index,
      ) {
        return Column(children: [
          boxImage(index),
          showText(
              color: Colors.white,
              text: controller.plantCategoriesList.value.data![index].name!,
              textSize: 14,
              fontWeight: FontWeight.w500,
              maxlines: 1)
        ]);
      },
    );
  }

  Widget boxImage(int i) {
    return GestureDetector(
        onTap: () {
          SearchPlantScreen(controller.plantCategoriesList.value.data![i].name!,
                  controller.plantCategoriesList.value.data![i].id!.toString())
              .navigate();
        },
        child: Container(
          margin: 5.marginAll(),
          child: CachedNetworkImage(
            imageUrl: ApiEndpoint.MEDIA_PATH +
                controller.plantCategoriesList.value.data![i].iconUrl!,
            imageBuilder: (context, imageProvider) {
              return categoryImageSecond(
                  imageProvider, 100, 90, BoxShape.rectangle);
            },
            placeholder: (context, url) {
              return showPlaceholderImage(
                  image: Images.placeholderImage, width: 100, height: 100);
            },
            errorWidget: (context, url, error) {
              return showPlaceholderImage(
                  image: Images.errorImage, width: 100, height: 100);
            },
          ),
        ));
  }

/*
  GestureDetector showHexagon(int index) {
    return GestureDetector(
      onTap: () {
        print('kaifasd');
        SearchPlantScreen("kaif","1").navigate();
      },child: HexagonWidget.pointy(
        width: 90,
        color: Colors.white,
        child: Column(children: [
          20.horizontalSpace(),
          SvgPicture.asset(
            Images.notification_red,
            height: 30,
            width: 30,
          ),
          10.horizontalSpace(),
          showText(
              color: Colors.black,
              text: "kaif",
              textSize: 14,
              fontWeight: FontWeight.w400,
              maxlines: 1)]),
      ),
    );
  }
*/

}
