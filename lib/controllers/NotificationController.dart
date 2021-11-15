
import 'package:get/get.dart';
import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/modals/NotificationModal.dart';

class NotificationController extends GetxController {
  var noDataFound = false.obs;
  var loading = false.obs;

  RxList<NotificationModal> notificatinList = <NotificationModal>[].obs;

  void updateDataFound(bool value) {
    noDataFound.value = value;
  }

  Future<NotificationModal?> fetchNotification() async {

    var modal=NotificationModal(title: Strings.dummy,time: "1 hour ago");
    List<NotificationModal> list=[];

    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);
    list.add(modal);

    notificatinList.addAll(list);


  }
}
