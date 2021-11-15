import 'package:cached_network_image/cached_network_image.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/LocationController.dart';
import 'package:zacharchive_flutter/controllers/OperationScreenController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import 'ControlRoomDescription.dart';
import 'OperationsHeavyTasks_25.dart';
import 'SearchPlantScreen_8.dart';

class OperationScreen extends StatefulWidget {
  @override
  _OperationScreenState createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  final double circleRadius = 70.0;
  final double circleBorderWidth = 8.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  OperationScreenController operationController =
      Get.put(OperationScreenController());

  LocationController controller = Get.find();

  var changeStatus = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  getLocation() async {
    var user = await getUser();
    controller.location.value = user!.data!.location!;
    changeStatus = user.data!.changeLocation!;
  }

  void _refreshData() async {
    print('refffff');
    operationController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                        GetX<OperationScreenController>(builder: (controller) {
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

  Widget getList() {
    var _mediaQueryData = MediaQuery.of(context);
    if (operationController.operationCategoriesList.value.status == null ||
        operationController.operationCategoriesList.value.status == "0") {
      if (operationController.noDataFound.value)
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (ctx, index) {
            return noDataFoundWidget(_mediaQueryData.size.height, Images.logoWhite,
                "No Operation Category Found");
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
      itemCount: operationController.operationCategoriesList.value.data!.length,
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
              text: operationController
                  .operationCategoriesList.value.data![index].name!,
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
          print('typpee_' +
              operationController.operationCategoriesList.value.data![i].type!);

          if (operationController.operationCategoriesList.value.data![i].type ==
              "Category")
            OperationsHeavyTasks(operationController
                    .operationCategoriesList.value.data![i].id!
                    .toString())
                .navigate();
          else if (operationController
                  .operationCategoriesList.value.data![i].type ==
              "Listing")
            SearchPlantScreen(
                    operationController
                        .operationCategoriesList.value.data![i].name!,
                    operationController
                        .operationCategoriesList.value.data![i].id!
                        .toString())
                .navigate();
          else if (operationController
                  .operationCategoriesList.value.data![i].type ==
              "Product")
            ControlRoomDescription(operationController
                    .operationCategoriesList.value.data![i].id!
                    .toString())
                .navigate();
        },
        child: Container(
          margin: 5.marginAll(),
          child: CachedNetworkImage(
            imageUrl: ApiEndpoint.OPERATION_MEDIA_PATH +
                operationController
                    .operationCategoriesList.value.data![i].image!,
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

  Widget showTopWidget() {
    return GetX<LocationController>(builder: (controller) {
      return Padding(
        padding: 5.paddingAll(),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: backButton().pressBack(),
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
                          text: "  " + Strings.operations,
                          textSize: 16,
                          fontWeight: FontWeight.w400,
                          maxlines: 1)
                    ],
                  ),
                ),
              ),
              Container(
                  margin: 3.marginTop(),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    showLocationDropdown(controller),
                    showNotificationDrawerMenu(
                        isShowNotification: true, context: context)
                  ])),
            ]),
      );
    });
  }

  num getSize(LocationController controller) {
    return controller.location.value.length > 10 ? .4 : .3;
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

      ApiCommonModal modal = await controller.updateUserLocationAPI();

      disposeProgress();
      if (modal.status == "1") {
        var user = await getUser();
        _refreshData();
        user!.data!.location = controller.location.value;

        await saveUser(user);
        'Location Updated Successfully'.toast();
      }
    } else
      Strings.went_wrong.toast();

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
}
