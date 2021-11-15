import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';

class ViewImage extends StatefulWidget {
  String image;

  ViewImage(this.image);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('VIewImage' + widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              showTopWidget(),
              20.horizontalSpace(),
              Container(
                margin: 50.marginTop(),
                child: PhotoView(
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      child: CircularProgressIndicator(
                        backgroundColor: colorPrimary,
                        valueColor: AlwaysStoppedAnimation(colorAccent),
                        strokeWidth: 5,
                      ),
                    ),
                  ),
                  minScale: .1,
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  imageProvider: NetworkImage(widget.image),
                ),
              ),
            ],
          ),
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
                text: " Image",
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }
}
