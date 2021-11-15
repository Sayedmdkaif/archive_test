import 'dart:io';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/controllers/SearchedDescriptionController.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/screen/SearchedDescription_9.dart';
import 'package:zacharchive_flutter/utils/Theme.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  // Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _allowedCamera = false;

  //QrCodeController qrCodeController = Get.put(QrCodeController());
  SearchedDescriptionController searchedDescriptionController =
  Get.put(SearchedDescriptionController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestWritePermission();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    try {
      super.reassemble();
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    } catch (e) {
      print('KaifException_Reseemble');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            showTopWidget(),
            Expanded(flex: 8, child: _buildQrView(context)),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.bgImage), fit: BoxFit.cover)),
                child: GetX<SearchedDescriptionController>(
                    builder: (searchedDescriptionController) {
                      return Padding(
                        padding: 5.paddingAll(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (searchedDescriptionController.barCode.isNotEmpty)
                              Text(
                                'Barcode Type: ${searchedDescriptionController.barCodeFormat}   \nData: ${searchedDescriptionController.barCode}',
                                maxLines: 2,
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              )
                            else
                              Text('Scan a code',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                            15.horizontalSpace(),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(3),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          await controller?.toggleFlash();
                                          setState(() {});
                                        },
                                        child: FutureBuilder(
                                          future: controller?.getFlashStatus(),
                                          builder: (context, snapshot) {
                                            //  print('flash'+
                                            String snapValue = "false";

                                            if (snapshot.data != null)
                                              snapValue = snapshot.data.toString();

                                            return Text(
                                              'Flash: ${snapValue == "false" ? "Off" : "On"}',
                                              style: TextStyle(color: darkBlue),
                                            );
                                          },
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(3),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await controller?.pauseCamera();
                                      },
                                      child: Text(
                                        'Pause',
                                        style: TextStyle(color: darkBlue),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(3),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await controller?.resumeCamera();
                                      },
                                      child: Text(
                                        'Resume',
                                        style: TextStyle(color: darkBlue),
                                      ),
                                    ),
                                  ),
                                )

                                /* Container(
                                margin: EdgeInsets.all(8),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await controller?.flipCamera();
                                      setState(() {});
                                    },
                                    child: FutureBuilder(
                                      future: controller?.getCameraInfo(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return Text(
                                              'Camera facing ${describeEnum(snapshot.data!)}',style: TextStyle(color: darkBlue),);
                                        } else {
                                          return Text('loading');
                                        }
                                      },
                                    )),
                              )*/
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            )
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
                text: " QR Scanner",
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }

  requestWritePermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _allowedCamera = true;
      });
    } else {
      _allowedCamera = false;
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
    }
  }

  Widget _buildQrView(BuildContext context) {
    try {
      // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
      var scanArea = (MediaQuery.of(context).size.width < 400 ||
          MediaQuery.of(context).size.height < 400)
          ? 250.0
          : 300.0;
      // To ensure the Scanner view is properly sizes after rotation
      // we need to listen for Flutter SizeChanged notification and update controller

      if (_allowedCamera)
        return QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
        );
      else
        return Container(
          color: Colors.black87,
        );
    } catch (e) {
      print('KaifException_buildQrViewCreate');
      return Container(
        color: Colors.black87,
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    try {
      setState(() {
        this.controller = controller;
      });

      //qrController.controller=controller;

      controller.scannedDataStream.listen((scanData) {
        /*  setState(() {
          result = scanData;
        });*/

        searchedDescriptionController.barCodeFormat.value =
            describeEnum(scanData.format);
        searchedDescriptionController.barCode.value = scanData.code!;

        callBarCodeFetchDataAPI();

        print('kaifData' + scanData.code!.toString());
      });
    } catch (e) {
      print('KaifException_onQRViewCreated');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void callBarCodeFetchDataAPI() {
    SearchedDescription(null, Strings.qrCode, "1").navigate();
  }
}
