import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/ControlRoomModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class ControlRoomController extends GetxController {
  var repo = ApiRepo();
  var noDataFound = false.obs;
  var loading = false.obs;

  Rx<ControlRoomModal> controlRoomListData = ControlRoomModal().obs;

  Future<ControlRoomModal> fetchControlRoomProductDetailsAPI({
    required String productId,
  }) async {
    var dataResponse =
        await repo.fetchControlRoomProductDetailsRepo(productId: productId);

    if (dataResponse.status == "1")
      this.controlRoomListData.value = dataResponse;
    else
      noDataFound.value = true;

    return dataResponse;
  }
}
