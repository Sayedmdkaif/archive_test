
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/modals/LockOutDetailModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class LockOutController extends GetxController {

  var repo = ApiRepo();

  var selectedTitle=''.obs;
  var selectedImage=''.obs;
  var selectedImageCaption=''.obs;
  var selectedDataIndex=-1.obs;
  var noDataFound = false.obs;
  Rx<LockOutDetailModal> lockOutDetailsData = LockOutDetailModal().obs;


  Future<LockOutDetailModal> fetchLockoutDetailsAPI({required String productId,required String from}) async {
    LockOutDetailModal dataResponse = await repo.fetchLockoutDetailsRepo(productId: productId,from: from);

    if (dataResponse.status == "1") {
      selectedTitle.value =dataResponse.data![0].title!;
      selectedImage.value =dataResponse.data![0].image!;
      selectedImageCaption.value =dataResponse.data![0].caption!;
      selectedDataIndex = 0;
    }
    else
      noDataFound.value = true;

    lockOutDetailsData.value=dataResponse;

    return dataResponse;

  }




}
