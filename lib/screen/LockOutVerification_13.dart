import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/LockOutController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/screen/ViewImage.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import 'AddNoteScreen_12.dart';
import 'PlayVideo2.dart';

class LockOutVerification extends StatefulWidget {
  String productId;
  String from;

  LockOutVerification(this.productId, this.from);

  @override
  _LockOutVerificationState createState() => _LockOutVerificationState();
}

class _LockOutVerificationState extends State<LockOutVerification> {
  final _controller = ScrollController();
  var count = 0.0;
  var reachedToBottom = false;
  LockOutController controller = Get.put(LockOutController());
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 50;
  int _timeMs = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(_scrollListener);
    _refreshData();
  }

  void _refreshData() async {
    print('_refreshData_called' + widget.productId);

    if (await checkInternet()) {
      launchProgress2(context: context);

      await controller.fetchLockoutDetailsAPI(
          productId: widget.productId, from: widget.from);
      disposeProgress();
    } else
      Strings.checkInternet.toast();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ShowUp(
            child: GetX<LockOutController>(builder: (controller) {
              return controller.lockOutDetailsData.value.data != null &&
                      controller.lockOutDetailsData.value.status != "0"
                  ? Column(
                      children: [
                        showTopWidget(),
                        Container(
                          padding: 5.paddingAll(),
                          height: screenHeight(context) * .77,
                          color: Colors.white,
                          child: SingleChildScrollView(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.horizontalSpace(),
                              showText(
                                  color: darkBlue,
                                  text: (controller.selectedDataIndex + 1)
                                          .toString() +
                                      "." +
                                      controller.selectedTitle.value,
                                  textSize: 18,
                                  fontWeight: FontWeight.w500,
                                  maxlines: 2),
                              10.horizontalSpace(),
                              isImage(controller.selectedImage.value)
                                  ? showImage()
                                  : showVideo(),
                              Container(
                                height: 30,
                                width: screenWidth(context),
                                color: Colors.red,
                                child: Padding(
                                  padding: 2.paddingAll(),
                                  child: showText(
                                      color: Colors.white,
                                      text:
                                          controller.selectedImageCaption.value,
                                      textSize: 18,
                                      fontWeight: FontWeight.w500,
                                      maxlines: 2),
                                ),
                              ),
                              10.horizontalSpace(),
                              showTableList(controller.selectedDataIndex),
                            ],
                          )),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  color: Colors.white,
                                  height: 70,
                                  child: Row(children: [
                                    Flexible(
                                        flex: 1,
                                        child: leftAndRightImage(Strings.left)),
                                    Flexible(flex: 5, child: showImageList()),
                                    Flexible(
                                        flex: 1,
                                        child:
                                            leftAndRightImage(Strings.right)),
                                  ])),
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(
                      child: Column(children: [
                      showTopWidget(),
                      showNoDataFoundWidget()
                    ]));
            }),
          )),
    );
  }

  Widget showNoDataFoundWidget() {
    if (controller.noDataFound.value)
      return ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (ctx, index) {
          return noDataFoundWidget(screenHeight(context), Images.logoWhite,
              "No LockOut Verification Data Found");
        },
      );
    else
      return Container(
        height: 100,
      );
  }

  Container showTopWidget() {
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
                text: " Lockout Verification",
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }

  showImage() {
    return GestureDetector(
      onTap: () => ViewImage(
              ApiEndpoint.LOCKOUT_MEDIA_PATH + controller.selectedImage.value)
          .navigate(),
      child: CachedNetworkImage(
        imageUrl:
            ApiEndpoint.LOCKOUT_MEDIA_PATH + controller.selectedImage.value,
        imageBuilder: (context, imageProvider) {
          return categoryImageSecond(
              imageProvider, double.infinity, 200, BoxShape.rectangle);
        },
        placeholder: (context, url) {
          return showPlaceholderImage(
              image: Images.placeholderImage,
              width: double.infinity,
              height: 200);
        },
        errorWidget: (context, url, error) {
          return showPlaceholderImage(
              image: Images.errorImage, width: double.infinity, height: 200);
        },
      ),
    );
  }

  showVideo() {
    return GestureDetector(
        onTap: () => PlayVideo2(
                ApiEndpoint.LOCKOUT_MEDIA_PATH + controller.selectedImage.value)
            .navigate(),
        child: Container(
            width: screenWidth(context),
            height: 200,
            child: Stack(children: [
              GenThumbnailImage(
                  width: screenWidth(context),
                  height: 200,
                  thumbnailRequest: ThumbnailRequest(
                      video: ApiEndpoint.LOCKOUT_MEDIA_PATH +
                          controller.selectedImage.value,
                      thumbnailPath: null,
                      imageFormat: _format,
                      maxHeight: 200,
                      maxWidth: screenWidth(context).toInt(),
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
                    onTap: () => PlayVideo2(ApiEndpoint.LOCKOUT_MEDIA_PATH +
                            controller.selectedImage.value)
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
                        width: 40,
                        height: 40,
                        child: Padding(
                            padding: 5.paddingAll(),
                            child: Image.asset(Images.videoIcon,
                                width: 30, height: 30, color: colorPrimary))),
                  ),
                ),
              ),
            ])));
  }

  Widget showTableList(int selectedDataIndex) {
    return controller.lockOutDetailsData.value.data![selectedDataIndex].details!
                .length >
            0
        ? CustomList(
            itemSpace: 0,
            shrinkWrap: true,
            axis: Axis.vertical,
            list: controller
                .lockOutDetailsData.value.data![selectedDataIndex].details!,
            child: (data, i) {
              return showTable(i, selectedDataIndex);
            })
        : Container(
            width: screenWidth(context),
          );

    /* return controller.lockOutDetailsData.value.data!.details![selectedDataIndex].length>0?  CustomList(
        itemSpace: 0,
        shrinkWrap: true,
        axis: Axis.vertical,
        list: controller.lockOutDetailsData.value.data!.details![selectedDataIndex] ,
        child: (data, i) {
          return showTable(i,selectedDataIndex);
        }):Container(color: Colors.blue,width: screenWidth(context),height: 200,);*/
  }

  showTable(int i, int selectedDataIndex) {
    return Table(
      defaultColumnWidth: FixedColumnWidth(screenWidth(context)),
      border: TableBorder.all(
          color: Colors.black12, style: BorderStyle.solid, width: 1),
      children: [
        TableRow(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: 5.paddingAll(),
                child: showText(
                    color: Colors.black,
                    text: controller.lockOutDetailsData.value
                        .data![selectedDataIndex].details![i].label!,
                    textSize: 14,
                    fontWeight: FontWeight.w500,
                    maxlines: 1),
              ),
              Padding(
                  padding: 5.paddingAll(),
                  child: showText(
                      color: Colors.black,
                      text: controller.lockOutDetailsData.value
                          .data![selectedDataIndex].details![i].value!,
                      textSize: 12,
                      fontWeight: FontWeight.w300,
                      maxlines: 5)),
            ],
          ),
        ]),
      ],
    );
  }

  Widget showDummyDescriptioin() {
    return ReadMoreText(
      Strings.dummy,
      trimLines: 2,
      colorClickableText: colorPrimary,
      trimMode: TrimMode.Line,
      trimCollapsedText: '...more',
      trimExpandedText: '  less',
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
    );
  }

  Widget showImageList() {
    return ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: controller.lockOutDetailsData.value.data!.length,
        itemBuilder: (context, index) {
          return Container(
            child:
                isImage(controller.lockOutDetailsData.value.data![index].image!)
                    ? Row(children: [
                        boxImage(index),
                        Container(
                          width: 5,
                        )
                      ])
                    : Row(children: [
                        showVideoImage(index),
                        Container(
                          width: 5,
                        )
                      ]),
          );
        });
  }

  Widget boxImage(int index) {
    return GestureDetector(
      onTap: () {
        print('clickeImage');

        controller.selectedTitle.value =
            controller.lockOutDetailsData.value.data![index].title!;
        controller.selectedImage.value =
            controller.lockOutDetailsData.value.data![index].image!;
        controller.selectedImageCaption.value =
            controller.lockOutDetailsData.value.data![index].caption!;

        controller.selectedDataIndex = index;
      },
      child: CachedNetworkImage(
        imageUrl: ApiEndpoint.LOCKOUT_MEDIA_PATH +
            controller.lockOutDetailsData.value.data![index].image!,
        imageBuilder: (context, imageProvider) {
          return categoryImageSecond(
              imageProvider, 90, 120, BoxShape.rectangle);
        },
        placeholder: (context, url) {
          return showPlaceholderImage(
              image: Images.errorImage, width: 70, height: 70);
        },
        errorWidget: (context, url, error) {
          return showPlaceholderImage(
              image: Images.errorImage, width: 70, height: 70);
        },
      ),
    );
  }

  Widget showVideoImage(int index) {
    return GestureDetector(
        onTap: () {
          print('clickeVudei');
          controller.selectedTitle.value =
              controller.lockOutDetailsData.value.data![index].title!;
          controller.selectedImage.value =
              controller.lockOutDetailsData.value.data![index].image!;
          controller.selectedImageCaption.value =
              controller.lockOutDetailsData.value.data![index].caption!;

          if (controller
                  .lockOutDetailsData.value.data![index].details!.length <=
              0) "No data is available".toast();

          controller.selectedDataIndex = index;
        },
        child: Container(
            margin: 5.marginBottom(),
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: Stack(children: [
              GenThumbnailImage(
                  width: 100,
                  height: 120,
                  thumbnailRequest: ThumbnailRequest(
                      video: ApiEndpoint.LOCKOUT_MEDIA_PATH +
                          controller
                              .lockOutDetailsData.value.data![index].image!,
/*
                      video: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
*/

                      thumbnailPath: null,
                      imageFormat: _format,
                      maxHeight: 120,
                      maxWidth: 100,
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
                    onTap: () {
                      print('clickeVudei');
                      controller.selectedTitle.value = controller
                          .lockOutDetailsData.value.data![index].title!;
                      controller.selectedImage.value = controller
                          .lockOutDetailsData.value.data![index].image!;
                      controller.selectedImageCaption.value = controller
                          .lockOutDetailsData.value.data![index].caption!;

                      if (controller.lockOutDetailsData.value.data![index]
                              .details!.length <=
                          0) "Data is not available".toast();

                      controller.selectedDataIndex = index;
                    },
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

  _scrollListener() {
    var message = "";

    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      message = "reach the bottom";
      reachedToBottom = true;
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      message = "reach the top";

      reachedToBottom = false;
    }

    // print('messageKaif' + message);
    // print('reachedToBottom' + reachedToBottom.toString());
  }

  Widget leftAndRightImage(String from) {
    return GestureDetector(
      onTap: () {
        if (from == Strings.right) {
          if (!reachedToBottom) {
            print('rightClicked');
            count++;
            _controller.animateTo(count * 70,
                duration: Duration(milliseconds: 100),
                curve: Curves.fastOutSlowIn);
          }
        } else if (from == Strings.left) {
          if (reachedToBottom) {
            count--;
            print('leftClicked');
            _controller.animateTo(count * 70,
                duration: Duration(milliseconds: 100),
                curve: Curves.fastOutSlowIn);
          }
        }
        print('clicked' + count.toString());
      },
      child: Container(
        height: 65,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(0)),
          color: colorAccent, // Make rounded corner of border
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 17,
          color: Colors.white,
        ),
      ),
    );
  }
}
