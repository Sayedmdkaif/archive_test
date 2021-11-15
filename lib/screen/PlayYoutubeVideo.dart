import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import '../common/CommonWidgets.dart';
import '../common/Images.dart';

class PlayYoutubeVideo extends StatefulWidget {
  String url;

  PlayYoutubeVideo(this.url);

  @override
  _PlayYoutubeVideoState createState() => _PlayYoutubeVideoState();
}

class _PlayYoutubeVideoState extends State<PlayYoutubeVideo> {
  bool isPortait = true;
  late var id;
  late YoutubePlayerController youtubePlayerController;

  @override
  void initState() {
    super.initState();
    print('youtuurr' + widget.url);

    id = YoutubePlayer.convertUrlToId(widget.url);
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //if landscape
        if (!isPortait) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: OrientationBuilder(builder: (context, orientation) {
            print(
                'kaifOrit' + (orientation == Orientation.portrait).toString());
            isPortait = orientation == Orientation.portrait;
            return Column(
              children: [
                isPortait ? showTopWidget() : Container(),
                10.horizontalSpace(),
                Expanded(
                  child: Center(
                    child: Container(
                        width: screenWidth(context),
                        height: screenHeight(context),
                        child: showYoutubeVideo()),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
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
          children: [
            backButton().pressBack(),
            15.verticalSpace(),
            showText(
                color: Colors.white,
                text: "Video",
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }

  showYoutubeVideo() {
    return Container(
      height: screenWidth(context),
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
          FullScreenButton(),
        ],
      ),
    );
  }
}
