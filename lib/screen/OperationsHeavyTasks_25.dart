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
import 'package:zacharchive_flutter/controllers/OperationHeavyTaskController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import 'ControlRoomDescription.dart';

class OperationsHeavyTasks extends StatefulWidget {
  String categoryId = "";

  OperationsHeavyTasks(this.categoryId);

  @override
  _OperationsHeavyTasksState createState() => _OperationsHeavyTasksState();
}

class _OperationsHeavyTasksState extends State<OperationsHeavyTasks> {
  final double circleRadius = 70.0;
  final double circleBorderWidth = 8.0;
  OperationHeavyTaskController controller =
      Get.put(OperationHeavyTaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    controller.loading.value = true;
    var dataList = await controller.fetchOpeationHeavyTaskSubCategoryAPI(
        categoryId: widget.categoryId);
    // print('ListRes'+controller.plantProductListOne.value.data!.length.toString());
    if (mounted) controller.loading.value = false;
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
                    Container(child: GetX<OperationHeavyTaskController>(
                        builder: (controller) {
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

  showTopWidget() {
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
                        text: Strings.operationHeavyTask,
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
    );
  }

  Widget getList() {
    var _mediaQueryData = MediaQuery.of(context);
    if (controller.operationSubCategoryList.value.status == null ||
        controller.operationSubCategoryList.value.status == "0") {
      if (controller.noDataFound.value)
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (ctx, index) {
            return noDataFoundWidget(_mediaQueryData.size.height, Images.logoWhite,
                "No Operation Category  Found");
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
      itemCount: controller.operationSubCategoryList.value.data!.length,
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
              text:
                  controller.operationSubCategoryList.value.data![index].name!,
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
              controller.operationSubCategoryList.value.data![i].type!);

          if (controller.operationSubCategoryList.value.data![i].type ==
              "Product")
            ControlRoomDescription(controller
                    .operationSubCategoryList.value.data![i].id!
                    .toString())
                .navigate();
        },
        child: Container(
          margin: 5.marginAll(),
          child: CachedNetworkImage(
            imageUrl: ApiEndpoint.OPERATION_MEDIA_PATH +
                controller.operationSubCategoryList.value.data![i].image!,
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
}
