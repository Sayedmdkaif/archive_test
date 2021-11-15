
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class LocationController extends GetxController {
  var locationList=[].obs;

  var selectedLocationId = ''.obs;

var location='Location'.obs;
var name='userName'.obs;


  var repo = ApiRepo();

  Future<ApiCommonModal> updateUserLocationAPI() async {
    return await repo.updateUserLocationRepo(locationId: selectedLocationId.value);
  }




}
