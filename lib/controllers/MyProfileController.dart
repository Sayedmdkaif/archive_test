import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class MyProfileController extends GetxController {
  var edited = false.obs;
  var repo = ApiRepo();
  Rx<TextStyle> dropDownTextStyle2 = TextStyle(color: Colors.black).obs;
  Rx<TextStyle> dropDownTextStyle1 = TextStyle(color: Colors.grey).obs;

  var color = Colors.white.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var locationList=[].obs;
  var changeLocationStatus=0.obs;

  var selectedLocations = Strings.selectLocation.obs;
  var selectedLocationId = ''.obs;

  Future<ApiCommonModal> updateProfileAPI({
    required String name,
    required String phone,
  }) async {
    return await repo.updateProfileRepo(name: name, phone: phone,locationId:selectedLocationId.value);
  }
}
