import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/PlantCategoriesModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class PlantScreenController extends GetxController {
  var repo = ApiRepo();
  var noDataFound=false.obs;
  var loading = false.obs;


  Rx<PlantCategoriesModal> plantCategoriesList = PlantCategoriesModal().obs;


  @override
  Future<void> onInit() async { // called immediately after the widget is allocated memory
    super.onInit();
    print('initCalledKaif');
    loading.value=true;
    await fetchPlantCategoriesAPI();
      loading.value=false;
  }



  Future<PlantCategoriesModal> fetchPlantCategoriesAPI() async {
    print('fetchCalled');
    var dataResponse = await repo.fetchPlantCategoriesRepo();

    print('fetchCalled22');

    if(dataResponse.status=="1")
      this.plantCategoriesList.value = dataResponse;
    else {
      plantCategoriesList.value.status=null;
      plantCategoriesList.value.status="0";
      plantCategoriesList.value.data?.clear();
      noDataFound.value = true;
    }

    return dataResponse;


  }
}
