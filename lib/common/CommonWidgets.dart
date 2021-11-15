import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:package_info/package_info.dart';
import 'package:zacharchive_flutter/screen/LoginScreen_2.dart';
import 'package:zacharchive_flutter/screen/PlantAndOperationScreen_5.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';
import '../screen/DrawerScreen.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/screen/NotificationScreen.dart';
import 'package:zacharchive_flutter/screen/PlantScreen_6.dart';
import 'package:zacharchive_flutter/screen/QrCode_7.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

import 'Strings.dart';

Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    print("NO_InterNEt");
    return false;
  }
  print("InterNEt");
  return true;
}

class inputTextFieldWidget extends StatefulWidget {
  TextEditingController controller;
  String title;
  Icon? icon;
  TextInputType keyboardType;
  bool isEnable;
  double? height;

  inputTextFieldWidget({
    required this.controller,
    required this.title,
    required this.icon,
    required this.keyboardType,
    required this.isEnable,
    this.height,
  });

  @override
  _inputTextFieldWidgetState createState() => _inputTextFieldWidgetState();
}

class _inputTextFieldWidgetState extends State<inputTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 0),
      child: TextField(
        onEditingComplete: () => getNode(context).nextFocus(),
        enabled: widget.isEnable,
        keyboardType: widget.keyboardType,
        maxLines: 1,
        cursorColor: Colors.white,
        controller: widget.controller,
        decoration: InputDecoration(
          hoverColor: Colors.white,
          focusColor: Colors.white,
          fillColor: Colors.white,
          labelText: widget.title,
          labelStyle: TextStyle(color: darkBlue),
          hintText: widget.title,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}


class inputTextFieldWidget2 extends StatefulWidget {
  TextEditingController controller;
  String title;
  Icon? icon;
  TextInputType keyboardType;
  bool isEnable;
  double? height;

  inputTextFieldWidget2({
    required this.controller,
    required this.title,
    required this.icon,
    required this.keyboardType,
    required this.isEnable,
    this.height,
  });

  @override
  _inputTextFieldWidget2State createState() => _inputTextFieldWidget2State();
}

class _inputTextFieldWidget2State extends State<inputTextFieldWidget2> {
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      style: TextStyle(color: Colors.white),
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
          labelStyle: TextStyle(
              color: darkBlue2,
              fontWeight: FontWeight.w400,
              fontSize: 18),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: darkBlue2, width: 2.0)),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.red, width: 2.0)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2.0)),
          labelText: widget.title),
    );
  }
}

getNode(BuildContext context) {
  return FocusScope.of(context);
}

Widget noDataFoundWidget(double height, String imagePath, String errorMsg) {
  height = height - (height * 20) / 100;
  return Container(
    height: height,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              Images.logoBlack,
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              errorMsg,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}




//color is optinal args
Widget backButton([Color? color]) {
  return Container(
    width: 40,
    height: 40,
    child: Padding(
      padding: 5.paddingAll(),
      child: Icon(
        Icons.arrow_back_outlined,
        color: color==null?Colors.white:color,
        size: 28,
      ),
    ),
  );
}

categoryImage(
  ImageProvider imageProvider,
  double width,
  double height,
  BoxShape shape,
) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      shape: shape,
      image: DecorationImage(
        image: imageProvider,
        fit: BoxFit.fill,
      ),
    ),
  );
}

categoryImageSecond(
  ImageProvider imageProvider,
  double width,
  double height,
  BoxShape shape,
) {
  return Container(
    margin: 3.marginAll(),
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: new BorderRadius.all(Radius.circular(5)),
      image: DecorationImage(
        image: imageProvider,
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget customIcon(
    {required IconData icon,
    Function? onTap,
    Color color = Colors.black,
    double margin = 8.0,
    double? size}) {
  return GestureDetector(
    onTap: () {
      onTap!();
    },
    child: Container(
        margin: EdgeInsets.all(margin),
        child: Icon(
          icon,
          color: color,
          size: size,
        )),
  );
}

Text showText(
    {required Color color,
    required String text,
    required double textSize,
    required FontWeight fontWeight,
    required int maxlines}) {
  return Text(
    text,
    maxLines: maxlines,
    style: GoogleFonts.nunito(
        fontSize: textSize, fontWeight: fontWeight, color: color),
  );
}

Text showTextUnderline(
    {required Color color,
    required String text,
    required double textSize,
    required FontWeight fontweight,
    required int maxlines}) {
  return Text(
    text,
    maxLines: maxlines,
    style: GoogleFonts.nunito(
        fontSize: textSize,
        fontWeight: fontweight,
        color: color,
        decoration: TextDecoration.underline),
  );
}

Image showPlaceholderImage(
    {required String image,
    required double width,
    required double height,
    BoxFit? fit}) {
  return Image.asset(
    image,
    width: width,
    height: height,
    fit: fit == null ? BoxFit.cover : BoxFit.fill,
  );
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());

  SystemChannels.textInput.invokeMethod('TextInput.hide');
}


void closeAPP() {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

Widget CustomButton(BuildContext context,
    {String text = '',
    Function? onTap,
    String? icon,
    bool isActive = true,
    bool isBorder = false,
    Color? borderColor,
    bool isSingleColor = false,
    Color? color,
    double? width,
    double height = 45,
    EdgeInsetsGeometry margin = const EdgeInsets.all(0.0),
    TextStyle? textStyle,
    double borderRadius = 25.0}) {
  return InkWell(
    onTap: () {
      if (isActive) onTap!();
    },
    child: Container(
      height: height,
      margin: margin,
      child: Center(
        child: Row(
          mainAxisAlignment:
              icon == null ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            SizedBox(width: icon == null ? 0.0 : 45),
            icon == null ? SizedBox() : SvgPicture.asset(icon),
            SizedBox(width: icon == null ? 0.0 : 35),
            Padding(
              padding: 2.paddingAll(),
              child: Text(
                text,
                style: textStyle == null
                    ? GoogleFonts.nunito(
                        color: isBorder ? colorPrimary : Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0)
                    : textStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: color,
        gradient: !isBorder
            ? color == null
                ? new LinearGradient(
                    colors: [
                      colorSecondPrimary,
                      colorPrimary,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)
                : null
            : null,
        border:
            isBorder ? Border.all(color: borderColor ?? colorPrimary) : null,
        borderRadius: new BorderRadius.all(Radius.circular(borderRadius)),
     /*   boxShadow: !isBorder
            ? [
                BoxShadow(
                  color: colorPrimary,
                  offset: Offset(0, 3),
                  blurRadius: 15,
                ),
              ]
            : null,*/
      ),
      width: width == null ? screenWidth(context) : width,
    ),
  );
}

getAppVersion() async {
  PackageInfo packageInfo = PackageInfo(
    appName: Strings.appName,
    packageName: 'Unknown',
    version: Strings.version,
    buildNumber: 'Unknown',
  );

  print('appVersion' + packageInfo.version);

  return packageInfo.version;
}

getDevice() {
  if (Platform.isAndroid) return "android";

  return "ios";
}

customAlertDialog(BuildContext context,
    {Widget content = const Text('Pass sub widgets'),
    Function? function,
    String title = "",
    bool isActionButtonVisible = true,
    String actionText = 'OK',
    String canelText = 'Cancel'}) {
  if (Platform.isIOS)
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => new CupertinoAlertDialog(
              title: Text(title),
              content: Container(child: content),
              actions: isActionButtonVisible
                  ? <Widget>[
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        isDefaultAction: true,
                        child: Text(
                          canelText,
                          style: TextStyle(color: colorPrimary),
                        ),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                          function!();
                        },
                        isDefaultAction: true,
                        child: Text(
                          actionText,
                          style: TextStyle(color: colorPrimary),
                        ),
                      ),
                    ]
                  : <Widget>[],
            ));
  else
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => new AlertDialog(
            title: Text(title),
            actions: isActionButtonVisible
                ? <Widget>[
                    TextButton(
                      child: Text(
                        canelText,
                        style: TextStyle(color: colorPrimary),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    TextButton(
                      child: Text(
                        actionText,
                        style: TextStyle(color: colorPrimary),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        function!();
                      },
                    ),
                  ]
                : <Widget>[],
            content: content));
}

successAlert(bool isImage, String fullImagePath, BuildContext context,
    String title, String image, String description) {
  CustomDialog(context,
      widget: !isImage
      ? Container(
              padding: 20.paddingAll(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0,
                          color: Colors.black.withOpacity(0.47))),
                  16.horizontalSpace(),
                  Image.asset(
                    image,
                    width: screenWidth(context),
                    height: 150,
                  ),
                  30.horizontalSpace(),
                  Text(
                    description,
                    style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.withOpacity(0.47)),
                    textAlign: TextAlign.center,
                  ),
                  30.horizontalSpace(),
                  CustomButton(context, height: 50, text: 'Ok', onTap: () {
                    Get.back();
                  }, width: screenWidth(context) / 2.8)
                ],
              ),
            )
          : Container(
              height: 290,
              padding: 10.paddingAll(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
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
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Padding(
                            padding: 3.paddingAll(),
                            child: Image.asset(Images.logoBlack)),
                      )),
                  CachedNetworkImage(
                    imageUrl: fullImagePath,
                    imageBuilder: (context, imageProvider) {
                      return categoryImage(imageProvider, screenWidth(context),
                          230, BoxShape.rectangle);
                    },
                    placeholder: (context, url) {
                      return Container(
                        width: screenWidth(context),
                        height: 230,
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return showPlaceholderImage(
                          image: Images.logoBlack,
                          width: screenWidth(context),
                          height: 230);
                    },
                  ),
                ],
              ),
            ));
}

Widget CustomCircleImageView(
    {String? image,
    bool isNetwork = false,
    File? file,
    double height = 40,
    double width = 40,
    Function? function,
    EdgeInsets margin = const EdgeInsets.all(8.0),
    bool isCircle = true}) {
  return GestureDetector(
    child: Container(
        margin: margin,
        width: width,
        height: height,
        child: file != null
            ? CircleAvatar(
                radius: 30.0,
                backgroundImage: FileImage(file),
                backgroundColor: Colors.transparent,
              )
            : SizedBox(),
        decoration: file == null
            ? new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover, image: new AssetImage(image!)))
            : BoxDecoration()),
  );
}

Widget CustomNetworkCircleImageView(
    {required String image,
    bool isNetwork = false,
    double height = 40,
    double width = 40,
    Function? function,
    EdgeInsets margin = const EdgeInsets.all(2.0),
    bool isCircle = true}) {
  return GestureDetector(
    /* onTap: () {

      function();
    },*/
    child: Container(
        margin: margin,
        width: width,
        height: height,
        child: isNetwork
            ? CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(image),
                backgroundColor: Colors.transparent,
              )
            : SizedBox(),
        decoration: !isNetwork
            ? new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover, image: new AssetImage(image)))
            : BoxDecoration()),
  );
}

CustomDialog(BuildContext context,
    {bool barrierDismissible = true,
    var isLoader = false,
    Widget widget = const Text('Pass sub widgets'),
    int durationmilliseconds = 200}) async {
  await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: barrierDismissible,
    barrierColor: textColor.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: durationmilliseconds),
    context: context,
    pageBuilder: (_, __, ___) {
      return isLoader
          ? widget
          : Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: getstatusBarHeight(context) * 2),
                child: Card(
                  child: widget,
                  margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

successAlertSecond(context, String successMsg, String from) {
  CustomDialog(context,
      widget: Container(
        padding: 20.paddingAll(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          /*  Text(Strings.appName,
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w500,
                    fontSize: 30.0,
                    color: Colors.black.withOpacity(0.47))),
            16.horizontalSpace(),*/

            SvgPicture.asset(
              Images.logoBlack,
              width: screenWidth(context),
              height: 150,
            ),
            30.horizontalSpace(),
            Text(
              successMsg,
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.withOpacity(0.47)),
              textAlign: TextAlign.center,
            ),
            30.horizontalSpace(),
            CustomButton(context, height: 50, text: 'Ok', onTap: () {
              hideKeyboard(context);
              Get.back();

              if(from==Strings.forget)
                LoginScreen().navigate(isInfinity: true);
else if(from=='registration')
                LoginScreen().navigate(isRemove: true);

            }, width: screenWidth(context) / 2.8)
          ],
        ),
      ));
}

Widget customCircleImageView(
    {String? image,
    bool isNetwork = false,
    File? file,
    double height = 40,
    double width = 40,
    Function? function,
    EdgeInsets margin = const EdgeInsets.all(8.0),
    bool isCircle = true}) {
  return GestureDetector(
    onTap: () {
      function!();
    },
    child: Container(
        margin: margin,
        width: width,
        height: height,
        child: file != null
            ? CircleAvatar(
                radius: 30.0,
                backgroundImage: FileImage(file),
                backgroundColor: Colors.transparent,
              )
            : SizedBox(),
        decoration: file == null
            ? new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover, image: new AssetImage(image!)))
            : BoxDecoration()),
  );
}

Widget CustomList<T>(
    {required Widget Function(T, int) child,
    @required List<T> list = const [],
    double itemSpace = 16,
    required bool shrinkWrap,
    ScrollController? scrollController,
    EdgeInsets padding = const EdgeInsets.all(0.0),
    Axis axis = Axis.vertical}) {
  return ListView.separated(
    padding: padding,
    controller: scrollController,
    shrinkWrap: shrinkWrap,
    clipBehavior: Clip.none,
    physics: BouncingScrollPhysics(),
    scrollDirection: axis,
    separatorBuilder: (contex, index) => SizedBox(
      width: axis == Axis.vertical ? 0 : itemSpace,
      height: axis == Axis.horizontal ? 0 : itemSpace,
    ),
    itemBuilder:
        (context, index) => //ViewWidget(snapshot.data.docments[index]),
            Container(child: child(list[index], index)),
    itemCount: list.length,
    //controller: listScrollController,
  );
}



Widget showDivider(
    {required BuildContext context,
    required double top,
    required Color color,
    required double width,
    required double height,
    required double thickness}) {

  return Container(
    margin: EdgeInsets.only(top: top),
    width: width,
    child: Padding(
      padding: 0.paddingAll(),
      child: Divider(
        height: height,
        thickness: thickness,
        color: color,
      ),
    ),
  );
}

Widget showTitle({
  required String title,
  required double size,
  required FontWeight weight,
  required int line,
}) {
  return Container(
    child: Padding(
      padding: EdgeInsets.only(top: 0, left: 6.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: showText(
              color: Colors.black,
              text: title,
              textSize: size,
              fontWeight: weight,
              maxlines: line)),
    ),
  );
}

class MyDottedSeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MyDottedSeparator({this.height = 1, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashWidth = 2.0;
          final dashHeight = height;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
          );
        },
      ),
    );
  }
}

Widget showScanHomeImage(BuildContext context) {
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
                  image: Images.scanImage2, height: 70, from: Strings.scan),
              20.verticalSpace(),
              showImage(
                  image: Images.homeImage2, height: 70, from: Strings.home),
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

Widget showScanImage(BuildContext context) {
  final double circleRadius = 70.0;
  return Stack(
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
          height: 90.0,
        ),
      ),
      showImage(
          image: Images.scanImage, height: 100, from: Strings.scan),


      showDivider(
          context: context,
          top: 120,
          color: Colors.white,
          width: screenWidth(context) / 2.5,
          height: 2,
          thickness: 4)
    ],
  );
}

showImage(
    {required String image, required double height, required String from}) {
  return GestureDetector(
    onTap: () {
      if (from == Strings.scan) {
        QrCode().navigate();

      }
      else if (from == Strings.addNote) {

      }
 else if (from == Strings.changePwd) {

      }


      else {
      // Get.reset();
        PlantAndOperationScreen().navigate(isInfinity: true);
      }
       },
    child: SvgPicture.asset(
      image,
      height: height,
      width: 50,
    ),
  );
}





Container showNotificationDrawerMenu({showLocation,required bool isShowNotification,required BuildContext context}) {
  return Container(
    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Row(
        children: [

          isShowNotification
              ? GestureDetector(
                  onTap: () {
                    NotificationScreen().navigate();
                  },
                  child: SvgPicture.asset(
                    Images.notification_red,
                    width: 25,
                    height: 25,
                  ))
              : Container(),
          10.verticalSpace(),
          GestureDetector(
            onTap: () {

              /*if(cameBy==Strings.drawer)
                Get.back();
              else*/
              DrawerScreen().navigate();

            },
            child: Icon(
              Icons.dehaze_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      )
    ]),
  );
}



MaterialButton showMaterialButton(
    {required double width,
    required double height,
    required double textSize,
    required Color color,
     Color? textColor,
    required bool showIcon,
      required String text,
      required Function onTap,}) {
  return MaterialButton(
      minWidth: width,
      height: height,
      color: color,
      child: new Text(text,
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: textSize, color: textColor==null?Colors.white:textColor)),
      onPressed: () {
        onTap();



      });
}



getScreenLength(BuildContext context){

  if(screenWidth(context)<400)
    return .87;

    return .89;

}

class MyBullet extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 5.0,
      width: 5.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}


Future<void> showLoadingDialog(
    BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => true,
          child: showLoading(),);
      });
}



Widget showLoading() {

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: LoadingBouncingGrid.circle(
      borderColor: Colors.white,
      borderSize: 3.0,
      size: 40.0,
      backgroundColor: colorPrimary,
      duration: Duration(milliseconds: 500),
    ),
  );
}



bool isImage(String  value) {

  var value2= value.contains(".jpg")||
      value.contains(".png")||
      value.contains(".webp")||
      value.contains(".jpeg");

  return value2;
}

isYoutubeVideo(String  value) {

  var value2= value.contains("youtu");
  return value2;
}

isPdf(String  value) {

  var value2= value.contains("pdf");
  return value2;
}


