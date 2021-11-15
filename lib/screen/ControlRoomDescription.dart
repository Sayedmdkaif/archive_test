import 'package:cached_network_image/cached_network_image.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/controllers/ControlRoomController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/screen/OpenPdf_11.dart';
import 'package:zacharchive_flutter/screen/PlayVideo2.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import 'AddNoteScreen_12.dart';
import 'LockOutVerification_13.dart';
import 'ViewImage.dart';

class ControlRoomDescription extends StatefulWidget {
  String categoryId = "";

  ControlRoomDescription(this.categoryId);

  @override
  _ControlRoomDescriptionState createState() => _ControlRoomDescriptionState();
}

class _ControlRoomDescriptionState extends State<ControlRoomDescription> {
  ControlRoomController controller = Get.put(ControlRoomController());
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 50;
  int _timeMs = 0;

  @override
  void initState() {
    super.initState();

    _refreshData();
  }

  void _refreshData() async {
    controller.loading.value = true;
    await controller.fetchControlRoomProductDetailsAPI(
        productId: widget.categoryId);

    if (mounted) controller.loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ShowUp(
        child: Column(
          children: [
            showTopWidget(),
            GetX<ControlRoomController>(builder: (controller) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 10, right: 10),
                height: screenHeight(context) * getScreenLength(context),
                child: SingleChildScrollView(
                  child: Container(
                    margin: 20.marginBottom(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DeclarativeRefreshIndicator(
                              refreshing: controller.loading.value,
                              color: colorPrimary,
                              onRefresh: _refreshData,
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                        height: screenHeight(context) *
                                            getScreenLength(context),
                                        child: getList()),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          10.horizontalSpace(),
                                          showLockOutVerification(),
                                        ],
                                      ),
                                    )
                                  ])),

                          //  controller.controlRoomListData.value.data!=null &&  controller.controlRoomListData.value.data!.isNotEmpty?showDataList():Container(),

                          // getList()
                        ]),
                  ),
                ),
              );
            }),
          ],
        ),
      )),
    );
  }

  Widget getList() {
    var _mediaQueryData = MediaQuery.of(context);
    if (controller.controlRoomListData.value.status == null ||
        controller.controlRoomListData.value.status == "0") {
      if (controller.noDataFound.value)
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (ctx, index) {
            return noDataFoundWidget(_mediaQueryData.size.height, Images.logoWhite,
                "No Product Details Found");
          },
        );
      else
        return Container(
          height: 100,
        );
    } else {
      return Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 100),
          child: showDataList());
      // }
    }
  }

  showTopWidget() {
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
                      Get.back();
                    },
                    child: backButton()),
              ),
              3.verticalSpace(),
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
                          text: "Control Room Documents",
                          textSize: 20,
                          fontWeight: FontWeight.w400,
                          maxlines: 1)
                    ],
                  ),
                ),
              ),
              showNotificationDrawerMenu(
                  showLocation: false,
                  isShowNotification: true,
                  context: context),
            ]),
      ),
    );
  }

  Widget showLockOutVerification() {
    return GestureDetector(
      onTap: () =>
          LockOutVerification(widget.categoryId, "operation").navigate(),
      child: Container(
        margin: 3.marginRight(),
        decoration: BoxDecoration(
          border: Border.all(
            color: darkBlue,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: 5.paddingAll(),
                child: showText(
                    color: darkBlue,
                    text: "Lock Out Verification",
                    textSize: 18,
                    fontWeight: FontWeight.w600,
                    maxlines: 1),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17,
                    color: darkBlue,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showDataList() {
    return CustomList(
        shrinkWrap: true,
        axis: Axis.vertical,
        list: controller.controlRoomListData.value.data!,
        child: (data, i) {
          if (controller
              .controlRoomListData.value.data![i].valueAlt!.isNotEmpty) {
            if (isImage(
                controller.controlRoomListData.value.data![i].valueAlt!))
              return Row(children: [boxImage(i)]);
            else if (isPdf(
                controller.controlRoomListData.value.data![i].valueAlt!))
              return showPdfItem(
                  label: controller.controlRoomListData.value.data![i].label!,
                  link:
                      controller.controlRoomListData.value.data![i].valueAlt!);
            else
              return Row(children: [showVideoImage(i)]);
          } else
            return showLableAndValueDetails(
                controller.controlRoomListData.value.data![i].label,
                controller.controlRoomListData.value.data![i].value!);

          //  return controller.controlRoomListData.value.data![i].valueAlt!.isNotEmpty?showPdfItem(label:  controller.controlRoomListData.value.data![i].label!,link:  controller.controlRoomListData.value.data![i].valueAlt!):showSerialNumbers(controller.controlRoomListData.value.data![i].label,controller.controlRoomListData.value.data![i].value!);
        });
  }

  Widget showVideoImage(int i) {
    return GestureDetector(
        onTap: () => PlayVideo2(ApiEndpoint.CONTROL_ROOM_VIDEO_PATH +
                controller.controlRoomListData.value.data![i].valueAlt!)
            .navigate(),
        child: Container(
            margin: 5.marginBottom(),
            width: 120,
            height: 100,
            child: Stack(children: [
              GenThumbnailImage(
                  width: 120,
                  height: 100,
                  thumbnailRequest: ThumbnailRequest(
                      video: ApiEndpoint.CONTROL_ROOM_VIDEO_PATH +
                          controller
                              .controlRoomListData.value.data![i].valueAlt!,
                      thumbnailPath: null,
                      imageFormat: _format,
                      maxHeight: 100,
                      maxWidth: 120,
                      timeMs: _timeMs,
                      quality: _quality)),
              Align(
                alignment: Alignment.center,
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: GestureDetector(
                    onTap: () => PlayVideo2(
                            ApiEndpoint.CONTROL_ROOM_VIDEO_PATH +
                                controller.controlRoomListData.value.data![i]
                                    .valueAlt!)
                        .navigate(),
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.5, 0.5),
                              blurRadius: 0.5,
                            ),
                          ],
                        ),
                        width: 20,
                        height: 20,
                        child: Padding(
                            padding: 5.paddingAll(),
                            child: Image.asset(Images.videoIcon,
                                width: 30, height: 30, color: colorPrimary))),
                  ),
                ),
              ),
            ])));
  }

  Widget boxImage(int i) {
    return GestureDetector(
      onTap: () => ViewImage(ApiEndpoint.CONTROL_ROOM_VIDEO_PATH +
              controller.controlRoomListData.value.data![i].valueAlt!)
          .navigate(),
      child: CachedNetworkImage(
        imageUrl: ApiEndpoint.CONTROL_ROOM_VIDEO_PATH +
            controller.controlRoomListData.value.data![i].valueAlt!,
        imageBuilder: (context, imageProvider) {
          return categoryImageSecond(
              imageProvider, 120, 100, BoxShape.rectangle);
        },
        placeholder: (context, url) {
          return showPlaceholderImage(
              image: Images.placeholderImage, width: 120, height: 100);
        },
        errorWidget: (context, url, error) {
          return showPlaceholderImage(
              image: Images.errorImage, width: 120, height: 100);
        },
      ),
    );
  }

  showPdfItem({
    required String label,
    required String link,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        showText(
            color: Colors.black,
            text: label,
            textSize: 16,
            fontWeight: FontWeight.w600,
            maxlines: 1),
        7.horizontalSpace(),
        showPdfFileItem(ApiEndpoint.MEDIA_PATH + link),
        5.horizontalSpace(),
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

  showLableAndValueDetails(String? label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        label!.isNotEmpty
            ? showText(
                color: Colors.black,
                text: label,
                textSize: 16,
                fontWeight: FontWeight.w600,
                maxlines: 1)
            : Container(),
        5.horizontalSpace(),
        label.isNotEmpty
            ? showText(
                color: colorAccent,
                text: value!,
                textSize: 16,
                fontWeight: FontWeight.w500,
                maxlines: 1)
            : Container(),
      ],
    );
  }

  Widget showPdfFileItem(String link) {
    return Container(
      child: Row(
        children: [
          link.contains(".pdf")
              ? SvgPicture.asset(
                  Images.pdf,
                  width: 25,
                  height: 25,
                )
              : Image.asset(
                  Images.placeholderImage,
                  width: 40,
                  height: 40,
                ),
          5.verticalSpace(),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                link.contains(".pdf")
                    ? OpenPDF(link).navigate()
                    : ViewImage(link).navigate();
              },
              child: showTextUnderline(
                  color: colorAccent,
                  text: "File Name",
                  textSize: 18,
                  fontweight: FontWeight.w500,
                  maxlines: 1),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 17,
                  color: darkBlue,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
