import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/AddNoteController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class AddNoteScreen extends StatefulWidget {
  String productId;
  String from;

  AddNoteScreen(this.productId, this.from);

  var noteAdded = false;

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  AddNoteController controller = Get.put(AddNoteController());
  ImagePicker picker = ImagePicker();

  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 50;
  int _sizeH = 0;
  int _sizeW = 0;
  int _timeMs = 0;
  String? _tempDir;
  final formKey = GlobalKey<FormState>();
  final videoInfo = FlutterVideoInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTemporaryDirectory().then((d) => _tempDir = d.path);
    widget.noteAdded = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('kaifche' + widget.noteAdded.toString());
        await pressBack(result: widget.noteAdded.toString());

        return true;
      },
      child: SafeArea(
        child: GetX<AddNoteController>(builder: (controller) {
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
                              child: GetX<AddNoteController>(
                                  builder: (controller) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    20.horizontalSpace(),
                                    showText(
                                        color: Colors.black,
                                        text: " Add your note here",
                                        textSize: 18,
                                        fontWeight: FontWeight.w500,
                                        maxlines: 1),
                                    20.horizontalSpace(),
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          showTitleWidget(),
                                          noteWidget(),
                                        ],
                                      ),
                                    ),
                                    20.horizontalSpace(),
                                    showText(
                                        color: Colors.black,
                                        text: " Add Image/Video",
                                        textSize: 16,
                                        fontWeight: FontWeight.w500,
                                        maxlines: 1),
                                    20.horizontalSpace(),
                                    showCameraGalleryButton(),
                                    controller.imageList.isNotEmpty
                                        ? showText(
                                            color: Colors.black,
                                            text: "  Images",
                                            textSize: 18,
                                            fontWeight: FontWeight.w500,
                                            maxlines: 1)
                                        : Container(),
                                    controller.imageList.isNotEmpty
                                        ? Container(
                                            height: 130,
                                            child: showImagesHorizontalList())
                                        : Container(),
                                    20.horizontalSpace(),
                                    controller.videoWidget.isNotEmpty
                                        ? showText(
                                            color: Colors.black,
                                            text: "  Videos",
                                            textSize: 18,
                                            fontWeight: FontWeight.w500,
                                            maxlines: 1)
                                        : Container(),
                                    controller.videoList.isNotEmpty
                                        ? Container(
                                            height: 130,
                                            child: showVideosHorizontalList())
                                        : Container(),
                                    10.horizontalSpace(),
                                    controller.youtubeList.isNotEmpty
                                        ? showText(
                                            color: Colors.black,
                                            text: "  Youtube Videos",
                                            textSize: 18,
                                            fontWeight: FontWeight.w500,
                                            maxlines: 1)
                                        : Container(),
                                    controller.youtubeList.isNotEmpty
                                        ? Container(
                                            height: 130,
                                            child: showYoutubeVideosList())
                                        : Container(),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                        showAddImage(),
                      ],
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }

  Widget showAddImage() {
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
                    image: Images.addImage, height: 70, from: Strings.addNote),
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
      onTap: () {
        if (formKey.currentState!.validate()) callAddNotesAPi();
      },
      child: SvgPicture.asset(
        image,
        height: height,
        width: 50,
      ),
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
            GestureDetector(
                onTap: () async {
                  hideKeyboard(context);
                  await pressBack(result: widget.noteAdded.toString());
                },
                child: backButton()),
            15.verticalSpace(),
            showText(
                color: Colors.white,
                text: " Add Note",
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }

  Widget showTitleWidget() {
    return Container(
      margin: 5.marginAll(),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff707070)),
          borderRadius: BorderRadius.circular(4)),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty)
            return 'Please enter title';
          else if (value.trim().isEmpty)
            return 'Please enter valid title';
          else if (value.trim().isEmpty)
            return 'Please enter valid title';
          else if (value.trim().length < 3)
            return 'Please enter valid title';
          else if (value.length < 3 || value.length > 25)
            return 'Please use character between 3 to 25';
          else
            return null;
        },
        controller: controller.titleController,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: Strings.enterTitle,
          labelStyle: TextStyle(color: Colors.black54),
          hintText: Strings.enterTitle,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget noteWidget() {
    return Container(
      margin: 5.marginAll(),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff707070)),
          borderRadius: BorderRadius.circular(4)),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty)
            return 'Please enter note';
          else if (value.trim().isEmpty)
            return 'Please enter valid note';
          else if (value.trim().isEmpty)
            return 'Please enter valid note';
          else if (value.trim().length < 3)
            return 'Please enter valid note';
          else
            return null;
        },
        controller: controller.noteController,
        maxLines: 6,
        decoration: InputDecoration(
          labelText: Strings.enterNote,
          labelStyle: TextStyle(color: Colors.black54),
          hintText: Strings.enterNote,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  showCameraGalleryButton() {
    return Container(
      margin: 5.marginAll(),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: darkBlue,
                ),
              ),
              margin: 5.marginAll(),
              child: showMaterialButton(
                  textSize: 14,
                  textColor: darkBlue,
                  color: colorAccent3,
                  width: screenWidth(context) / 2,
                  height: 47,
                  showIcon: false,
                  text: Strings.camera,
                  onTap: () {
                    selectImageVideoBottomSheet(Strings.camera);
                  }),
            ),
          ),
          2.verticalSpace(),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: darkBlue,
                ),
              ),
              margin: 5.marginAll(),
              child: showMaterialButton(
                  textColor: darkBlue,
                  textSize: 14,
                  color: colorAccent3,
                  width: screenWidth(context) / 2,
                  height: 47,
                  showIcon: false,
                  text: Strings.gallery,
                  onTap: () {
                    selectImageVideoBottomSheet(Strings.gallery);
                  }),
            ),
          ),
          2.verticalSpace(),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: darkBlue,
                ),
              ),
              margin: 5.marginAll(),
              child: showMaterialButton(
                  textColor: darkBlue,
                  textSize: 14,
                  color: colorAccent3,
                  width: screenWidth(context) / 2,
                  height: 47,
                  showIcon: false,
                  text: Strings.youtubeLink,
                  onTap: () {
                    showAddYoutubeLinkAlert();
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> changeColor() async {
    await Future.delayed(Duration(milliseconds: 1200));
    controller.color.value = colorAccent;
  }

  Future<void> selectImageVideoBottomSheet(String from) async {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
            primary: true,
            child: Container(
              margin: 5.marginTop(),
              padding: 10.paddingAll(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        hideKeyboard(context);
                        pressBack();
                      },
                      child: backButton(Colors.black)),
                  GestureDetector(
                    onTap: () {
                      Get.back();

                      if (from == Strings.camera)
                        pickCameraImages();
                      else
                        pickGalleryImages();
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          Images.placeholderImage,
                          width: 50,
                          height: 50,
                        ),
                        3.verticalSpace(),
                        showText(
                            color: Colors.black,
                            text: "Upload Image",
                            textSize: 18,
                            fontWeight: FontWeight.w500,
                            maxlines: 1),
                      ],
                    ),
                  ),
                  15.horizontalSpace(),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                        if (from == Strings.camera)
                          pickCameraVideos();
                        else
                          pickGalleryVideos();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            Images.placeholderImage,
                            width: 50,
                            height: 50,
                          ),
                          3.verticalSpace(),
                          showText(
                              color: Colors.black,
                              text: "Upload Video",
                              textSize: 18,
                              fontWeight: FontWeight.w500,
                              maxlines: 1),
                        ],
                      )),
                ],
              ),
            ));
      }),
    );
  }

  Future<void> pickCameraImages() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    File image = File(pickedFile!.path);
    controller.imageList.add(image);

    controller.images.add(image.path);

    print('cameraImage' + controller.imageList.toString());
  }

  Future<void> pickCameraVideos() async {
    Duration timeDuration = Duration(milliseconds: 60000);

    XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.camera, maxDuration: timeDuration);

    File video = File(pickedFile!.path);

    controller.videoList.add(video);

    controller.videos.add(video.path);

    // setState(() {
    controller.videoWidget.add(Container(
      height: 130,
      width: 150,
      child: GenThumbnailImage(
          thumbnailRequest: ThumbnailRequest(
              video: pickedFile.path,
              thumbnailPath: _tempDir,
              imageFormat: _format,
              maxHeight: _sizeH,
              maxWidth: _sizeW,
              timeMs: _timeMs,
              quality: _quality)),
    ));
    // });

    print('cameraVideo' + controller.videoList.toString());
  }

  Future<void> pickGalleryImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      // List<File> files = result.paths.map((path) => File(path!)).toList();
      controller.imageList
          .addAll(result.paths.map((path) => File(path!)).toList());

      controller.images.addAll(result.paths.map((path) => path!).toList());

      print('SelectedGalleryImages' + controller.imageList.toString());
    } else {
      // User canceled the picker
    }
  }

  //video length should less than or equal to 5 minutes
  bool isVideoLengthBig(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      print("${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds");
    else
      print("$twoDigitMinutes:$twoDigitSeconds");

    if (duration.inHours > 0)
      return true;
    else if (int.parse(twoDigitMinutes) >= 1)
      return true;
    else
      return false;
  }

  Future<void> pickGalleryVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );
    if (result != null) {
      var newList = result.paths.map((path) => File(path!)).toList();

      controller.videoList.addAll(newList);

      controller.videos.addAll(result.paths.map((path) => path!).toList());

      print('videoSize' + newList.length.toString());

      for (int i = 0; i < newList.length; i++) {
        //controller.videos.add(newList[i].path);

        VideoData? info = await videoInfo.getVideoInfo(newList[i].path);
        Duration timeDuration = Duration(milliseconds: info!.duration!.toInt());
        print('isVideoLengthBig_' + isVideoLengthBig(timeDuration).toString());

        //  if(!isVideoLengthBig(timeDuration))
        controller.videoWidget.add(Container(
          height: 130,
          width: 150,
          child: GenThumbnailImage(
              thumbnailRequest: ThumbnailRequest(
                  video: newList[i].path,
                  thumbnailPath: _tempDir,
                  imageFormat: _format,
                  maxHeight: _sizeH,
                  maxWidth: _sizeW,
                  timeMs: _timeMs,
                  quality: _quality)),
        ));
        /*else
          {
            "Please upload maximum 5 minutes video".toast();
            newList.clear();
            break;
          }
*/

        print('katSize' + controller.videoWidget.length.toString());

        //  print('SelectedGalleryVideos' + controller.videoList.toString());
      }

      /*  setState(() {

      });*/

    } else {
      // User canceled the picker
    }
  }

  Widget showImagesHorizontalList() {
    return CustomList(
        shrinkWrap: false,
        axis: Axis.horizontal,
        list: controller.imageList,
        child: (data, index) {
          return Card(
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                children: [
                  Stack(children: [
                    Image.file(
                      controller.imageList[index],
                      width: 150,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      right: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              controller.imageList.removeAt(index);
                              controller.images.removeAt(index);
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
                                width: 25,
                                height: 25,
                                child: Padding(
                                    padding: 5.paddingAll(),
                                    child: SvgPicture.asset(
                                      Images.close,
                                      width: 25,
                                      height: 25,
                                      color: Colors.red,
                                    ))),
                          ),
                        ),
                      ),
                    ),
                  ])
                ],
              ),
            ),
          );
        });
  }

  Widget showVideosHorizontalList() {
    return CustomList(
        shrinkWrap: false,
        axis: Axis.horizontal,
        list: controller.videoWidget,
        child: (data, index) {
          return Card(
            elevation: 5,
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(5)),
              ),
              child: Stack(children: [
                controller.videoWidget[index] != null
                    ? controller.videoWidget[index]
                    : Container(
                        width: 150,
                      ),
                Align(
                  alignment: Alignment.center,
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: GestureDetector(
                      onTap: () {},
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
                          width: 25,
                          height: 25,
                          child: Padding(
                              padding: 5.paddingAll(),
                              child: Image.asset(Images.videoIcon,
                                  width: 25, height: 25, color: colorPrimary))),
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller.videoWidget.removeAt(index);
                          controller.videos.removeAt(index);
                          controller.videoList.removeAt(index);
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
                            width: 25,
                            height: 25,
                            child: Padding(
                                padding: 5.paddingAll(),
                                child: SvgPicture.asset(
                                  Images.close,
                                  width: 25,
                                  height: 25,
                                  color: Colors.red,
                                ))),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  void callAddNotesAPi() async {
    hideKeyboard(context);
    if (await checkInternet()) {
      launchProgress2(context: context);

      String result = await controller.addProductNotesAPI(
          productId: widget.productId, from: widget.from);

      // if(result!=null)
      print('addNoteResult' + result);

      disposeProgress();

      if (result != null && result == "1") {
        widget.noteAdded = true;
        controller.titleController.text = '';
        controller.noteController.text = '';

        controller.images.clear();
        controller.imageList.clear();

        controller.videos.clear();
        controller.videoList.clear();
        controller.videoWidget.clear();

        controller.youtubeURLS.clear();
        controller.youtubeList.clear();
        successAlertSecond(context, Strings.successNotedAdded, "notes");
      } else
        Strings.went_wrong.toast();
    } else
      Strings.checkInternet.toast();
  }

  void showAddYoutubeLinkAlert() {
    controller.ytLinkController.text = '';
    return CustomDialog(context,
        widget: Container(
          padding: 20.paddingAll(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Strings.appName,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 30.0,
                      color: Colors.black.withOpacity(0.47))),
              16.horizontalSpace(),
              Text(
                "Please " + Strings.youtubeLInk,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.47)),
                textAlign: TextAlign.center,
              ),
              30.horizontalSpace(),
              showEnterYoutubeLinkTextField(),
              20.horizontalSpace(),
              showAlertBothButton(),
            ],
          ),
        ));
  }

  Widget showEnterYoutubeLinkTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff707070)),
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        keyboardType: TextInputType.name,
        maxLines: 1,
        controller: controller.ytLinkController,
        decoration: InputDecoration(
          hintText: Strings.youtubeLInk,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Row showAlertBothButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: 5.marginAll(),
            child: CustomButton(context,
                height: 50,
                text: 'ADD',
                textStyle: TextStyle(fontSize: 14, color: Colors.white),
                onTap: () async {
              // print('linkText'+controller.ytLinkController.text.toString());
              // print('kafilink'+YoutubePlayer.convertUrlToId(controller.ytLinkController.text)!);
              var id = "";

              if (controller.ytLinkController.text.isEmpty) {
                {
                  hideKeyboard(context);
                  "Please enter  youtube video link".toast();
                }
                return;
              } else if (YoutubePlayer.convertUrlToId(
                      controller.ytLinkController.text) !=
                  null) {
                id = YoutubePlayer.convertUrlToId(
                    controller.ytLinkController.text)!;

                if (id.isEmpty) {
                  hideKeyboard(context);
                  "Please enter valid youtube link".toast();
                } else {
                  controller.youtubeURLS.add(controller.ytLinkController.text);
                  controller.youtubeList.add(YoutubePlayerController(
                      initialVideoId: id,
                      flags: const YoutubePlayerFlags(
                        autoPlay: false,
                      )));

                  hideKeyboard(context);
                  pressBack();
                }
              } else {
                hideKeyboard(context);
                "Please enter valid youtube link".toast();
              }
            }, width: screenWidth(context)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: 5.marginAll(),
            child: CustomButton(context,
                height: 50,
                text: 'CANCEL',
                isBorder: true,
                textStyle: TextStyle(fontSize: 14, color: colorPrimary),
                onTap: () {
              hideKeyboard(context);
              pressBack();
            }, width: screenWidth(context)),
          ),
        ),
      ],
    );
  }

  showYoutubeVideosList() {
    return Container(
      height: 130,
      margin: EdgeInsets.all(5),
      child: CustomList(
          shrinkWrap: true,
          itemSpace: 30,
          axis: Axis.horizontal,
          list: controller.youtubeList,
          child: (data, index) {
            print('loopRUn');

            return Container(
              height: 130,
              width: 160.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  YoutubePlayer(
                    key: ObjectKey(controller.youtubeList[index]),
                    controller: controller.youtubeList[index],
                    actionsPadding: const EdgeInsets.only(left: 16.0),
                    bottomActions: [
                      CurrentPosition(),
                      const SizedBox(width: 10.0),
                      ProgressBar(isExpanded: true),
                      const SizedBox(width: 10.0),
                      RemainingDuration(),
                      // FullScreenButton(),
                    ],
                  ),
                  Positioned(
                    right: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: GestureDetector(
                        onTap: () {
                          print('removeY');

                          controller.youtubeList.removeAt(index);
                          controller.youtubeURLS.removeAt(index);
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
                            width: 25,
                            height: 25,
                            child: Padding(
                                padding: 5.paddingAll(),
                                child: SvgPicture.asset(
                                  Images.close,
                                  width: 25,
                                  height: 25,
                                  color: Colors.red,
                                ))),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class GenThumbnailImage extends StatefulWidget {
  final ThumbnailRequest? thumbnailRequest;
  final double? width;
  final double? height;

  const GenThumbnailImage(
      {Key? key, this.thumbnailRequest, this.width, this.height})
      : super(key: key);

  @override
  _GenThumbnailImageState createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: genThumbnail(widget.thumbnailRequest!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final _image = snapshot.data.image;
          final _width = snapshot.data.width;
          final _height = snapshot.data.height;
          final _dataSize = snapshot.data.dataSize;
          return ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: widget.height,
                width: widget.width,
                child: _image,
              ));
        } else if (snapshot.hasError) {
          return Container(
            height: widget.height,
            width: widget.width,
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Errorkaif:\n${snapshot.error.toString()}",
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            height: widget.height,
            width: widget.width,
          );
        }
      },
    );
  }
}

Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
  //WidgetsFlutterBinding.ensureInitialized();
  Uint8List? bytes;
  final Completer<ThumbnailResult> completer = Completer();
  if (r.thumbnailPath != null) {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: r.video!,
        thumbnailPath: r.thumbnailPath,
        imageFormat: r.imageFormat!,
        maxHeight: r.maxHeight!,
        maxWidth: r.maxWidth!,
        timeMs: r.timeMs!,
        quality: r.quality!);

    print("thumbnail file is located: $thumbnailPath");

    final file = File(thumbnailPath!);
    bytes = file.readAsBytesSync();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
        video: r.video!,
        imageFormat: r.imageFormat!,
        maxHeight: r.maxHeight!,
        maxWidth: r.maxWidth!,
        timeMs: r.timeMs!,
        quality: r.quality!);
  }

  int _imageDataSize = bytes!.length;
  print("image size: $_imageDataSize");

  final _image = Image.memory(
    bytes,
    fit: BoxFit.cover,
  );
  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(ThumbnailResult(
      image: _image,
      dataSize: _imageDataSize,
      height: info.image.height,
      width: info.image.width,
    ));
  }));
  return completer.future;
}

class ThumbnailRequest {
  final String? video;
  final String? thumbnailPath;
  final ImageFormat? imageFormat;
  final int? maxHeight;
  final int? maxWidth;
  final int? timeMs;
  final int? quality;

  const ThumbnailRequest(
      {this.video,
      this.thumbnailPath,
      this.imageFormat,
      this.maxHeight,
      this.maxWidth,
      this.timeMs,
      this.quality});
}

class ThumbnailResult {
  final Image? image;
  final int? dataSize;
  final int? height;
  final int? width;

  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}
