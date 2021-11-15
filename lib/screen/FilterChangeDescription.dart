import 'package:cached_network_image/cached_network_image.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/FilterDescriptionController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/screen/PlayVideo2.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import 'AddNoteScreen_12.dart';
import 'EquipmentNoteListScreen.dart';
import 'LockOutVerification_13.dart';
import 'OpenPdf_11.dart';
import 'PlayYoutubeVideo.dart';
import 'ViewImage.dart';

class FilterChangeDescription extends StatefulWidget {
  String productId;

  FilterChangeDescription(this.productId);

  @override
  _FilterChangeDescriptionState createState() =>
      _FilterChangeDescriptionState();
}

class _FilterChangeDescriptionState extends State<FilterChangeDescription> {
  FilterDescriptionController controller =
      Get.put(FilterDescriptionController());
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
    //await controller.fetchProductDetailsForFilterChangeAPI(categoryId:"9");
    await controller.fetchProductDetailsForFilterChangeAPI(
        categoryId: widget.productId);

    if (mounted) controller.loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ShowUp(
            child: GetX<FilterDescriptionController>(builder: (controller) {
              return Container(
                child: Column(
                  children: [
                    showTopWidget(),
                    DeclarativeRefreshIndicator(
                      refreshing: controller.loading.value,
                      color: colorPrimary,
                      onRefresh: _refreshData,
                      child: Container(
                        color: Colors.white,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              height: screenHeight(context) *
                                  getScreenLength(context),
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: 20.marginBottom(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      controller.productLisDetailsList.value
                                                      .data !=
                                                  null &&
                                              controller
                                                  .productLisDetailsList
                                                  .value
                                                  .data!
                                                  .details!
                                                  .isNotEmpty
                                          ? showItemList()
                                          : Container(),
                                      10.horizontalSpace(),
                                      controller.productLisDetailsList.value
                                                  .data !=
                                              null
                                          ? showEquipmentNotes()
                                          : Container(),
                                      10.horizontalSpace(),
                                      controller.productLisDetailsList.value
                                                      .data !=
                                                  null &&
                                              controller.productLisDetailsList
                                                  .value.data!.notes!.isNotEmpty
                                          ? showEquipmentNotesList()
                                          : Container(),
                                      40.horizontalSpace(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            showLockOutVerification(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          )),
    );
  }

  Widget showLockOutVerification() {
    return GestureDetector(
      onTap: () =>
          LockOutVerification(widget.productId, "operation").navigate(),
      child: Container(
        padding: 3.paddingAll(),
        margin: 5.marginAll(),
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

  Widget showEquipmentNotes() {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: showText(
                color: Colors.black,
                text: "Equipment Notes",
                textSize: 14,
                fontWeight: FontWeight.w600,
                maxlines: 1),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                controller.productLisDetailsList.value.data != null &&
                        controller
                            .productLisDetailsList.value.data!.notes!.isNotEmpty
                  && controller.productLisDetailsList.value.data!.notes!.length>5   ? showMaterialButton(
                        textSize: 10,
                        color: darkBlue,
                        width: 25,
                        height: 40,
                        showIcon: false,
                        text: Strings.viewAllNotes,
                        onTap: () {
                          EquipmentNoteListScreen(controller.originalNotesList)
                              .navigate();
                        })
                    : Container(),
                2.verticalSpace(),
                showMaterialButton(
                    textSize: 10,
                    color: darkBlue,
                    width: 25,
                    height: 40,
                    showIcon: true,
                    text: Strings.addNote,
                    onTap: () async {
                      String result =
                          await AddNoteScreen(widget.productId, "operation")
                              .navigate(isAwait: true);
                      print('ResultFrom_Add_Note' + result);
                      if (result == "true") _refreshData();
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget showEquipmentNotesList() {
    return CustomList(
        shrinkWrap: true,
        axis: Axis.vertical,
        list: controller.productLisDetailsList.value.data!.notes!,
        child: (data, i) {
          return Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showUserNameTitleLayout(i),
                  showText(
                      color: Colors.black,
                      text: "    " +
                          controller.productLisDetailsList.value.data!.notes![i]
                              .title![0]
                              .toUpperCase() +
                          controller.productLisDetailsList.value.data!.notes![i]
                              .title!
                              .substring(
                                  1,
                                  controller.productLisDetailsList.value.data!
                                      .notes![i].title!.length),
                      textSize: 14,
                      fontWeight: FontWeight.w400,
                      maxlines: 1),
                  Padding(
                      padding: 17.paddingLeft(),
                      child: showNotesDescription(controller
                          .productLisDetailsList.value.data!.notes![i].notes!)),
                  3.horizontalSpace(),
                  Container(
                      height: isNotesDetailsAllFilesEmpty(i) ? 0 : 100,
                      child: showNotesImagesVideosList(i)),
                  showDivider(
                      context: context,
                      top: 2,
                      color: Colors.grey,
                      width: screenWidth(context),
                      height: 1,
                      thickness: .4),
                ]),
          );
        });
  }

  Widget showNotesImagesVideosList(int i) {
    return CustomList(
        shrinkWrap: false,
        axis: Axis.horizontal,
        list: controller.productLisDetailsList.value.data!.notes![i].details!,
        child: (data, index) {
          return controller.productLisDetailsList.value.data!.notes![i]
                  .details![index].files!.isNotEmpty
              ? Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(5)),
                  ),
                  child: isImage(controller.productLisDetailsList.value.data!
                          .notes![i].details![index].files!)
                      ? boxImage(i, index)
                      : isYoutubeVideo(controller.productLisDetailsList.value
                              .data!.notes![i].details![index].files!)
                          ? showYoutubeVideo(i, index)
                          : showVideoImage(i, index))
              : Container();
        });
  }

  Widget showVideoImage(int i, int index) {
    return GestureDetector(
        onTap: () => PlayVideo2(ApiEndpoint.NOTES_MEDIA_PATH +
                controller.productLisDetailsList.value.data!.notes![i]
                    .details![index].files!)
            .navigate(),
        child: Container(
            margin: 5.marginBottom(),
            width: 120,
            height: 120,
            child: Stack(children: [
              GenThumbnailImage(
                  width: 120,
                  height: 120,
                  thumbnailRequest: ThumbnailRequest(
                      video: ApiEndpoint.NOTES_MEDIA_PATH +
                          controller.productLisDetailsList.value.data!.notes![i]
                              .details![index].files!,
                      thumbnailPath: null,
                      imageFormat: _format,
                      maxHeight: 120,
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
                    onTap: () => PlayVideo2(ApiEndpoint.NOTES_MEDIA_PATH +
                            controller.productLisDetailsList.value.data!
                                .notes![i].details![index].files!)
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

  Widget boxImage(int i, int j) {
    return GestureDetector(
      onTap: () => ViewImage(ApiEndpoint.NOTES_MEDIA_PATH +
              controller.productLisDetailsList.value.data!.notes![i].details![j]
                  .files!)
          .navigate(),
      child: CachedNetworkImage(
        imageUrl: ApiEndpoint.NOTES_MEDIA_PATH +
            controller
                .productLisDetailsList.value.data!.notes![i].details![j].files!,
        imageBuilder: (context, imageProvider) {
          return categoryImageSecond(
              imageProvider, 120, 80, BoxShape.rectangle);
        },
        placeholder: (context, url) {
          return showPlaceholderImage(
              image: Images.placeholderImage, width: 120, height: 80);
        },
        errorWidget: (context, url, error) {
          return showPlaceholderImage(
              image: Images.errorImage, width: 120, height: 80);
        },
      ),
    );
  }

  showYoutubeVideo(int i, int j) {
    var id = YoutubePlayer.convertUrlToId(controller
        .productLisDetailsList.value.data!.notes![i].details![j].files!);
    late YoutubePlayerController youtubePlayerController;
    if (id != null) {
      youtubePlayerController = YoutubePlayerController(
          initialVideoId: id,
          flags: const YoutubePlayerFlags(
            hideControls: true,
            autoPlay: false,
          ));
    }

    return id != null
        ? GestureDetector(
            onTap: () => PlayYoutubeVideo(controller.productLisDetailsList.value
                    .data!.notes![i].details![j].files!)
                .navigate(),
            child: Container(
              height: 80.0,
              width: 120.0,
              child: YoutubePlayer(
                key: ObjectKey(youtubePlayerController),
                controller: youtubePlayerController,
                actionsPadding: const EdgeInsets.only(left: 16.0),
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 10.0),
                  ProgressBar(isExpanded: true),
                  const SizedBox(width: 10.0),
                  RemainingDuration(),
                ],
              ),
            ),
          )
        : Container();
  }

  isNotesDetailsAllFilesEmpty(int index) {
    var flag = false;

    for (int i = 0;
        i <
            controller.productLisDetailsList.value.data!.notes![index].details!
                .length;
        i++) {
      if (controller.productLisDetailsList.value.data!.notes![index].details![i]
          .files!.isNotEmpty) {
        flag = true;
        break;
      }
    }

    if (flag)
      return false;
    else
      return true;
  }

  Widget showUserNameTitleLayout(int i) {
    return Container(
      child: Row(
        children: [
          SvgPicture.asset(
            Images.text,
            width: 15,
            height: 15,
          ),
          3.verticalSpace(),
          Row(
            children: [
              showText(
                  color: Colors.black,
                  text: controller
                      .productLisDetailsList.value.data!.notes![i].userName!,
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  maxlines: 1),
              2.verticalSpace(),
              showText(
                  color: Colors.black,
                  text: convertDate(controller
                      .productLisDetailsList.value.data!.notes![i].createdAt!),
                  textSize: 12,
                  fontWeight: FontWeight.w300,
                  maxlines: 1),
            ],
          ),
          i == 0 || i == 1
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      showMaterialButton(
                          textSize: 10,
                          color: greenColor,
                          width: 30,
                          height: 30,
                          showIcon: false,
                          text: Strings.newText,
                          onTap: () {
                            print('clieck');
                          }),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget showNotesDescription(String notes) {
    return ReadMoreText(
      notes,
      trimLines: 2,
      colorClickableText: colorPrimary,
      trimMode: TrimMode.Line,
      trimCollapsedText: '...more',
      trimExpandedText: '  less',
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
    );
  }

  showItemList() {
    return Column(
      children: [
        10.horizontalSpace(),
            CustomList(
            shrinkWrap: true,
            axis: Axis.vertical,
            list: controller.productLisDetailsList.value.data!.details!,
            child: (data, i) {
              // return Container(width: screenWidth(context),height: 50,color: Colors.red,);

              return controller.productLisDetailsList.value.data!.details![i]
                      .valueAlt!.isNotEmpty
                  ? showPdfItem(
                      label: controller
                          .productLisDetailsList.value.data!.details![i].label!,
                      link: controller
                          .productLisDetailsList.value.data!.details![i].valueAlt!)
                  : showSerialNumbers(
                      controller
                          .productLisDetailsList.value.data!.details![i].label,
                      controller
                          .productLisDetailsList.value.data!.details![i].value!);
            }),
          ],
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

  showSerialNumbers(String? label, String? value) {
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
                          text: "  Filter Name",
                          textSize: 20,
                          fontWeight: FontWeight.w400,
                          maxlines: 1)
                    ],
                  ),
                ),
              ),
              //showNotificationDrawerMenu(showLocation:false,isShowNotification: true,context:context),
            ]),
      ),
    );
  }
}
