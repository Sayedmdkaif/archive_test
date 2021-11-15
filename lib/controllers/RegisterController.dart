import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/modals/UserDetailModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';

class RegisterController extends GetxController {
  var color = Colors.white.obs;
  var repo = ApiRepo();

  var oldPasswordVisible = true.obs;
  var passwordVisible = true.obs;
  var cPasswordVisible = true.obs;
  var isChecked = false.obs;
  var passwordValue = ''.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  Future<ApiCommonModal> registerAPI({required String id}) async {
    return await repo.registerRepo(
        id: id,
        email: emailController.getValue(),
        name: nameController.getValue(),
        phone: phoneController.getValue(),
        password: passwordController.getValue());
  }

  Future<UserDetailModal> getUserDetailsFromLinkAPI(
      {required String link}) async {
    print('linkkaif' + link);
    return await repo.getUserDetailsFromLinkRepo(
      link: link,
    );
  }

  Future<ApiCommonModal> updatePasswordAPI({ required String id}) async {
    return await repo.updatePasswordRepo(id: id,password: passwordController.getValue());
  }



  Future<ApiCommonModal> updateProfilePasswordAPI() async {
    return await repo.updateProfilePasswordRepo(oldPassword: oldPasswordController.getValue(),newPassword: cPasswordController.getValue());
  }

}
