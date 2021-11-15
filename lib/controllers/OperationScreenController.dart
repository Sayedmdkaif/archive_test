import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/OperationModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class OperationScreenController extends GetxController {
  var repo = ApiRepo();
  var noDataFound=false.obs;
  var loading = false.obs;

  Rx<OperationModal> operationCategoriesList = OperationModal().obs;

  @override
  Future<void> onInit() async { // called immediately after the widget is allocated memory
    super.onInit();
    loading.value=true;
    await fetchOperationCategoriesAPI();
    loading.value=false;
  }

  Future<OperationModal> fetchOperationCategoriesAPI() async {
    var dataResponse = await repo.fetchOperationRepo();

    if(dataResponse.status=="1")
      this.operationCategoriesList.value = dataResponse;
    else {
      operationCategoriesList.value.status=null;
      operationCategoriesList.value.status="0";
      operationCategoriesList.value.data?.clear();
      noDataFound.value = true;
    }
    return dataResponse;
  }
}
