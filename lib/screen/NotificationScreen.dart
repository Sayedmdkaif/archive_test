import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/controllers/NotificationController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FocusNode messageFocus = FocusNode();

  NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();

    callSearchApi("");
  }

  void callSearchApi(String keyword) async {
    controller.fetchNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GetX<NotificationController>(builder: (controller) {
          return ShowUp(
            child: Container(
              height: screenHeight(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showTopWidget(),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: SingleChildScrollView(child: getList())),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getList() {
    /* var _mediaQueryData = MediaQuery.of(context);
    if (controller.searchList.value.status == null ||
        controller.searchList.value.status == "0") {
      if (controller.noDataFound.value)
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (ctx, index) {
            return noDataFoundWidget(_mediaQueryData.size.height, Images.error_image,
                "No Restaurant Found");
          },
        );
      else
        return Container(height: 100,);
    } else {*/

    return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: showList());
    // }
  }

  Widget showList() {
    return CustomList(
        itemSpace: 0.0,
        shrinkWrap: true,
        axis: Axis.vertical,
        list: controller.notificatinList,
        child: (data, i) {
          return Container(child: showNotification(i));
        });
  }

  showTopWidget() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
      child: Padding(
        padding: 5.paddingAll(),
        child: Row(
          children: [
            backButton().pressBack(),
            15.verticalSpace(),
            showText(
                color: Colors.white,
                text: " Notifications",
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }

  showNotification(int i) {
    return Column(
      children: [
        Padding(
          padding: 5.paddingAll(),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: darkBlue,
                          size: 25,
                        ),
                        Expanded(
                          child: showTitle(
                              title: controller.notificatinList[i].title!,
                              size: 16,
                              weight: FontWeight.w400,
                              line: 1),
                        )
                      ],
                    ),
                    showTitle(
                        title: "       " + controller.notificatinList[i].time!,
                        size: 14,
                        weight: FontWeight.w300,
                        line: 1),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: showDivider(
                          context: context,
                          top: 2,
                          color: Colors.grey,
                          width: screenWidth(context),
                          height: 1,
                          thickness: .4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
