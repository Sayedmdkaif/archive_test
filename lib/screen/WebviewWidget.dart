import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/utils/Util.dart';

class WebviewWidget extends StatefulWidget {

  @override
  _WebviewWidgetState createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {
  String html = ApiEndpoint.TERMS_AND_CONDITION;

  double webViewHeight = 0.0;
  late WebViewController _webViewController;
  var isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            showTopWidget(),
            Container(
              height: screenHeight(context) * .8,
              padding: 12.paddingAll(),
              color: Colors.white,
              child: Stack(
                children: [
                  WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _webViewController = webViewController;
                    },
                    onWebResourceError: (error) {
                      "${error.description}".toast();
                    },
                    onPageFinished: (some) async {
                      if (_webViewController != null) {
                        webViewHeight = double.tryParse(
                          await _webViewController.evaluateJavascript(
                              "document.documentElement.scrollHeight;"),
                        )!;
                        isLoaded = true;
                        setState(() {});
                      }
                    },
                    initialUrl: html,
                  ),
                  Positioned.fill(
                    child: Visibility(
                        visible: !isLoaded,
                        child: Center(child: CircularProgressIndicator())),
                  )
                ],
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
                text: Strings.termsCondition,
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }
}
