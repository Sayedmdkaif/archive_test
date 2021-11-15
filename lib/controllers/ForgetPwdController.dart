import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class ForgetPwdController extends GetxController {
  var repo = ApiRepo();
  TextEditingController emailController = TextEditingController();

  Future<ApiCommonModal> forgetPasswordAPI() async {
    return await repo.forgetPasswordRepo(email: emailController.getValue());
  }

  Future<ApiCommonModal> verifyOTPAPI(
      {required String id, required String otp}) async {
    return await repo.verifyOTPRepo(id: id, otp: otp);
  }
}
