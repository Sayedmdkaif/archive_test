import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:zacharchive_flutter/common/CommonWidgets.dart';
import 'package:zacharchive_flutter/common/Images.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';

class OpenPDF extends StatefulWidget {
  String link;

  OpenPDF(this.link);

  @override
  _OpenPDFState createState() => _OpenPDFState();
}

class _OpenPDFState extends State<OpenPDF> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          showTopWidget(),
          Expanded(
            child: Container(
                child: SfPdfViewer.network(
                    /*'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',*/
                    widget.link,
                    canShowPaginationDialog: true)),
          ),
        ],
      ),
    ));
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
                text: " PDF File",
                textSize: 20,
                fontWeight: FontWeight.w400,
                maxlines: 1)
          ],
        ),
      ),
    );
  }
}
