
import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';

import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/modals/LoginModal.dart';
import 'package:zacharchive_flutter/modals/PlantCategoriesModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class QrCodeController extends GetxController {
  var repo = ApiRepo();

  var passwordVisible=true.obs;

  var barCodeFormat="".obs;
  var barCode="".obs;


  Future<ApiCommonModal> logOutUserAPI() async {
    return await repo.logOutUserRepo();
  }






}
