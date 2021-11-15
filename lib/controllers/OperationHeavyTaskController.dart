import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/OperationModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class OperationHeavyTaskController extends GetxController {
  var repo = ApiRepo();
  var noDataFound=false.obs;
  var loading = false.obs;


  Rx<OperationModal> operationSubCategoryList = OperationModal().obs;



  Future<OperationModal> fetchOpeationHeavyTaskSubCategoryAPI({required String categoryId}) async {
    var dataResponse = await repo.fetchOpeationHeavyTaskSubCategoryRepo(categoryId: categoryId);



    if(dataResponse.status=="1")
      this.operationSubCategoryList.value = dataResponse;
    else
      noDataFound.value=true;

    return dataResponse;
  }
}
