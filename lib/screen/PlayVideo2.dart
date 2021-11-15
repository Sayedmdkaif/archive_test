import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import '../common/CommonWidgets.dart';
import '../common/Images.dart';

class PlayVideo2 extends StatefulWidget {
  String url;

  PlayVideo2(this.url);

  @override
  _PlayVideo2State createState() => _PlayVideo2State();
}

class _PlayVideo2State extends State<PlayVideo2> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: false,
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        /*  'https://serverdevelopment.s3.us-east-2.amazonaws.com/equipment_notes/ImvIWpvG6PSPIgLIsVh88zHxm04OJK8ycdMBrnom.mp4',*/
        widget.url);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            showTopWidget(),
            Expanded(
              child: Center(
                child: Container(
                  width: screenWidth(context),
                  height: 240,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer(controller: _betterPlayerController),
                  ),
                ),
              ),
            ),
          ],
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
}
