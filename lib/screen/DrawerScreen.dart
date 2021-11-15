import 'package:cached_network_image/cached_network_image.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/controllers/DrawerScreenController.dart';
import 'package:zacharchive_flutter/controllers/LocationController.dart';
import 'package:zacharchive_flutter/controllers/LoginController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/screen/ControlRoomDescription.dart';
import 'package:zacharchive_flutter/screen/LoginScreen_2.dart';
import 'package:zacharchive_flutter/screen/MyProfileScreen.dart';
import 'package:zacharchive_flutter/screen/SearchPlantScreen_8.dart';
import 'package:zacharchive_flutter/screen/WebviewWidget.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import '../common/Images.dart';
import '../common/Strings.dart';
import 'OperationsHeavyTasks_25.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  LocationController locationController = Get.find();
  DrawerScreenController controller = Get.put(DrawerScreenController());
  LoginController loginController = Get.put(LoginController());

  void _refreshData() async {
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: ShowUp(
        child: GetX<DrawerScreenController>(builder: (controller) {
          return DeclarativeRefreshIndicator(
            refreshing: controller.loading.value,
            color: colorPrimary,
            onRefresh: _refreshData,
            child: Container(
              padding: 10.paddingAll(),
              width: screenWidth(context),
              height: screenHeight(context),
              child: ListView(
                padding: 10.paddingAll(),
                children: [
                  showTopLayout(),
                  10.horizontalSpace(),
                  showPlantLayout(),
                  10.horizontalSpace(),
                  showOperationLayout(),
                ],
              ),
            ),
          );
        }),
      )),
    );
  }

  Widget showItemWithImage(String title, String image) {
    return GestureDetector(
      onTap: () {
        if (title == Strings.tAndCondition)
          WebviewWidget().navigate();
        else if (title == Strings.logout) {
          logOut(context);
        }
      },
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(
                image,
                width: 28,
                height: 28,
              ),
            ),
            title == Strings.molsieveBed || title == Strings.carbonBeg
                ? 20.verticalSpace()
                : 40.verticalSpace(),
            Expanded(
              flex: 7,
              child: showText(
                  color: title == Strings.logout ? darkBlue : colorAccent,
                  text: title,
                  textSize:
                      title == Strings.molsieveBed || title == Strings.carbonBeg
                          ? 16
                          : 18,
                  fontWeight: FontWeight.w500,
                  maxlines: 1),
            ),
          ],
        ),
      ),
    );
  }

  showTopLayout() {
    return GetX<LocationController>(builder: (locationController) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showText(
              color: Colors.black,
              text: "Hi",
              textSize: 18,
              fontWeight: FontWeight.w300,
              maxlines: 1),
          Row(children: [
            showText(
                color: Colors.black,
                text: locationController.name.value,
                textSize: 20,
                fontWeight: FontWeight.w500,
                maxlines: 1),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var data =
                          await MyProfileScreen().navigate(isAwait: true);
                      print('dataDrawer' + data);
                      var user = await getUser();

                      if (data == Strings.update)
                        locationController.name.value = user!.data!.name!;
                    },
                    child: Container(
                      margin: 15.marginTop(),
                      child: showTextUnderline(
                          color: colorPrimary,
                          text: "View Profile",
                          textSize: 16,
                          fontweight: FontWeight.w500,
                          maxlines: 1),
                    ),
                  ),
                  25.verticalSpace(),
                  GestureDetector(
                    onTap: () {
                      pressBack();
                    },
                    child: SvgPicture.asset(
                      Images.close,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            )
          ]),
          10.horizontalSpace(),
          showDivider(
              context: context,
              top: 2,
              color: Colors.grey,
              width: screenWidth(context),
              height: 1,
              thickness: .4),
        ],
      );
    });
  }

  Widget showPlantLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        controller.plantCategoriesList.value.data != null
            ? showText(
                color: Colors.black,
                text: "Plant",
                textSize: 18,
                fontWeight: FontWeight.w500,
                maxlines: 1)
            : Container(),
        15.horizontalSpace(),
        showPlantCategoryList(),
        showDivider(
            context: context,
            top: 2,
            color: Colors.grey,
            width: screenWidth(context),
            height: 1,
            thickness: .4),
      ],
    );
  }

  Widget showOperationLayout() {
    return controller.operationCategoriesList.value.data != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.operationCategoriesList.value.data != null
                  ? showText(
                      color: Colors.black,
                      text: "Operation",
                      textSize: 18,
                      fontWeight: FontWeight.w500,
                      maxlines: 1)
                  : Container(),
              15.horizontalSpace(),
              showOperationCategoryList(),
              15.horizontalSpace(),
              showDivider(
                  context: context,
                  top: 2,
                  color: Colors.grey,
                  width: screenWidth(context),
                  height: 1,
                  thickness: .4),
              15.horizontalSpace(),
              showItemWithImage(Strings.tAndCondition, Images.icon_pass),
              15.horizontalSpace(),
              showDivider(
                  context: context,
                  top: 2,
                  color: Colors.grey,
                  width: screenWidth(context),
                  height: 1,
                  thickness: .4),
              15.horizontalSpace(),
              showItemWithImage(Strings.logout, Images.icon_logout),
              15.horizontalSpace(),
            ],
          )
        : Container();
  }

  logOut(context) {
    CustomDialog(context,
        widget: Container(
          padding: 20.paddingAll(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Logout',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w500,
                      fontSize: 30.0,
                      color: Colors.black.withOpacity(0.47))),
              16.horizontalSpace(),
              SvgPicture.asset(
                Images.logoBlack,
                height: 120,
              ),
              30.horizontalSpace(),
              Text(
                'Are you sure want to logout?',
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.47)),
                textAlign: TextAlign.center,
              ),
              30.horizontalSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(context, height: 50, text: 'No', isBorder: true,
                      onTap: () {
                    pressBack();
                  }, width: screenWidth(context) / 2.8),
                  CustomButton(context, height: 50, text: 'Yes', onTap: () {
                    callLogOutApi();
                  }, width: screenWidth(context) / 2.8)
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> callLogOutApi() async {
    if (await checkInternet()) {
      clearPreference();
      LoginScreen().navigate(
        isInfinity: true,
      );

      ApiCommonModal modal = await loginController.logOutUserAPI();
      print('logoutAPi_Res' + modal.status!);
    } else
      Strings.checkInternet.toast();
  }

  showPlantCategoryList() {
    return controller.plantCategoriesList.value.data != null
        ? CustomList(
            shrinkWrap: true,
            axis: Axis.vertical,
            list: controller.plantCategoriesList.value.data!,
            child: (data, i) {
              return GestureDetector(
                onTap: () {
                  hideKeyboard(context);
                  SearchPlantScreen(
                          controller.plantCategoriesList.value.data![i].name!,
                          controller.plantCategoriesList.value.data![i].id!
                              .toString())
                      .navigate(isRemove: true);
                },
                child: Container(
                  height: 35,
                  child: Row(
                    children: [
                      showIconNetworkImage(i),
                      40.verticalSpace(),
                      Expanded(
                        flex: 5,
                        child: showText(
                            color: colorAccent,
                            text: controller
                                .plantCategoriesList.value.data![i].name!,
                            textSize: 18,
                            fontWeight: FontWeight.w500,
                            maxlines: 1),
                      ),
                    ],
                  ),
                ),
              );
            })
        : Container();
  }

  showOperationCategoryList() {
    return controller.operationCategoriesList.value.data != null
        ? CustomList(
            shrinkWrap: true,
            axis: Axis.vertical,
            list: controller.operationCategoriesList.value.data!,
            child: (data, i) {
              return GestureDetector(
                onTap: () {
                  hideKeyboard(context);

                  print('typpee_' +
                      controller.operationCategoriesList.value.data![i].type!);

                  if (controller.operationCategoriesList.value.data![i].type ==
                      "Category")
                    OperationsHeavyTasks(controller
                            .operationCategoriesList.value.data![i].id!
                            .toString())
                        .navigate(isRemove: true);
                  else if (controller
                          .operationCategoriesList.value.data![i].type ==
                      "Listing")
                    SearchPlantScreen(
                            controller
                                .operationCategoriesList.value.data![i].name!,
                            controller
                                .operationCategoriesList.value.data![i].id!
                                .toString())
                        .navigate(isRemove: true);
                  else if (controller
                          .operationCategoriesList.value.data![i].type ==
                      "Product")
                    ControlRoomDescription(controller
                            .operationCategoriesList.value.data![i].id!
                            .toString())
                        .navigate(isRemove: true);
                },
                child: Container(
                  height: 35,
                  child: Row(
                    children: [
                      showIconNetworkImage(i),
                      40.verticalSpace(),
                      Expanded(
                        flex: 5,
                        child: showText(
                            color: colorAccent,
                            text: controller
                                .operationCategoriesList.value.data![i].name!,
                            textSize: 18,
                            fontWeight: FontWeight.w500,
                            maxlines: 1),
                      ),
                    ],
                  ),
                ),
              );
            })
        : Container();
  }

  showIconNetworkImage(int i) {
    return CachedNetworkImage(
      imageUrl: ApiEndpoint.MEDIA_PATH +
          controller.plantCategoriesList.value.data![i].iconUrl!,
      imageBuilder: (context, imageProvider) {
        return categoryImageSecond(imageProvider, 35, 35, BoxShape.rectangle);
      },
      placeholder: (context, url) {
        return showPlaceholderImage(
            image: Images.placeholderImage, width: 35, height: 35);
      },
      errorWidget: (context, url, error) {
        return showPlaceholderImage(
            image: Images.errorImage, width: 35, height: 35);
      },
    );
  }
}
