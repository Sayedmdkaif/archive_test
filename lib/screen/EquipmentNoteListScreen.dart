import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zacharchive_flutter/animations/ShowUp.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/PlantProductDetailModal2.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import 'AddNoteScreen_12.dart';
import 'PlayVideo2.dart';
import 'PlayYoutubeVideo.dart';
import 'ViewImage.dart';

class EquipmentNoteListScreen extends StatefulWidget {
  List<Note> notes;

  EquipmentNoteListScreen(this.notes);

  @override
  _EquipmentNoteListScreenState createState() =>
      _EquipmentNoteListScreenState();
}

class _EquipmentNoteListScreenState extends State<EquipmentNoteListScreen> {
  FocusNode messageFocus = FocusNode();

  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 50;
  int _timeMs = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ShowUp(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
              child: Container(
                height: screenHeight(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showTopWidget(),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          color: Colors.white,
                          child: SingleChildScrollView(
                              child: showEquipmentNotesList())),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget showEquipmentNotesList() {
    return CustomList(
        shrinkWrap: true,
        axis: Axis.vertical,
        list: widget.notes,
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
                          widget.notes[i].title![0].toUpperCase() +
                          widget.notes[i].title!
                              .substring(1, widget.notes[i].title!.length),
                      textSize: 14,
                      fontWeight: FontWeight.w400,
                      maxlines: 1),
                  Padding(
                      padding: 17.paddingLeft(),
                      child: showNotesDescription(widget.notes[i].notes!)),
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
        list: widget.notes[i].details!,
        child: (data, index) {
          return widget.notes[i].details![index].files!.isNotEmpty
              ? Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(5)),
                  ),
                  child: isImage(widget.notes[i].details![index].files!)
                      ? boxImage(i, index)
                      : isYoutubeVideo(widget.notes[i].details![index].files!)
                          ? showYoutubeVideo(i, index)
                          : showVideoImage(i, index))
              : Container();
        });
  }

  showYoutubeVideo(int i, int j) {
    var id = YoutubePlayer.convertUrlToId((widget.notes[i].details![j].files!));
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
            onTap: () =>
                PlayYoutubeVideo(widget.notes[i].details![j].files!).navigate(),
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

  Widget showVideoImage(int i, int index) {
    return GestureDetector(
        onTap: () => PlayVideo2(ApiEndpoint.NOTES_MEDIA_PATH +
                widget.notes[i].details![index].files!)
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
                          widget.notes[i].details![index].files!,
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
                            widget.notes[i].details![index].files!)
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

  isNotesDetailsAllFilesEmpty(int index) {
    var flag = false;

    for (int i = 0; i < widget.notes[index].details!.length; i++) {
      if (widget.notes[index].details![i].files!.isNotEmpty) {
        flag = true;
        break;
      }
    }

    if (flag)
      return false;
    else
      return true;
  }

  Widget showNotesImagesList(int i) {
    return CustomList(
        shrinkWrap: false,
        axis: Axis.horizontal,
        list: widget.notes[i].details!,
        child: (data, index) {
          return widget.notes[i].details![index].files!.isNotEmpty
              ? Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(5)),
                  ),
                  child: boxImage(i, index))
              : Container();
        });
  }

  Widget boxImage(int i, int j) {
    return GestureDetector(
      onTap: () => ViewImage(
              ApiEndpoint.NOTES_MEDIA_PATH + widget.notes[i].details![j].files!)
          .navigate(),
      child: CachedNetworkImage(
        imageUrl:
            ApiEndpoint.NOTES_MEDIA_PATH + widget.notes[i].details![j].files!,
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
                  text: widget.notes[i].userName!,
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  maxlines: 1),
              2.verticalSpace(),
              showText(
                  color: Colors.black,
                  text: convertDate(widget.notes[i].createdAt!),
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

  Padding showTopWidget() {
    return Padding(
      padding: 5.paddingAll(),
      child: Row(
        children: [
          backButton().pressBack(),
          15.verticalSpace(),
          showText(
              color: Colors.white,
              text: " Equipment Notes",
              textSize: 20,
              fontWeight: FontWeight.w400,
              maxlines: 1)
        ],
      ),
    );
  }
}
