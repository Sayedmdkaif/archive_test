
import 'package:flutter/cupertino.dart';

import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';

import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/modals/LoginModal.dart';
import 'package:zacharchive_flutter/modals/PlantCategoriesModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class LoginController extends GetxController {
  var repo = ApiRepo();

  var passwordVisible=true.obs;
  var isChecked=false.obs;
  Rx<PlantCategoriesModal> plantCategoriesList = PlantCategoriesModal().obs;
  var noDataFound=false.obs;
  var loading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<LoginModal> loginAPI() async {
    return await repo.loginRepo(email: emailController.getValue(), password: passwordController.getValue());
  }

  Future<ApiCommonModal> logOutUserAPI() async {
    return await repo.logOutUserRepo();
  }


}
