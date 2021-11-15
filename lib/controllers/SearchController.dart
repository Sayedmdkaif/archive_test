import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/PlantProductListModal.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class SearchController extends GetxController {
  var noDataFound = false.obs;
  var repo = ApiRepo();
  var loading = false.obs;

  Rx<PlantProductListModal> plantProductListOne = PlantProductListModal().obs;

  Rx<PlantProductListModal> plantProductListTwo = PlantProductListModal().obs;

  TextEditingController searchTextController = TextEditingController();


  var searchingText = ''.obs;



  void updateDataFound(bool value) {
    noDataFound.value = value;
  }


  Future fetchPlantProductListAPI({required String categoryId,required String url}) async {
    var dataResponse =
        await repo.fetchPlantProductListRepo(categoryId: categoryId,url: url);

    if (dataResponse.status == "1") {
      plantProductListOne.value = dataResponse;
      plantProductListTwo.value = dataResponse;


      plantProductListOne.refresh();
    } else
      noDataFound.value = true;

    return plantProductListOne;
  }

  void performFilter(String query) {
    List<Datum> results = <Datum>[];

    print('beforeSearch' + plantProductListOne.value.data!.length.toString());

      if (query.isEmpty)
      results = plantProductListOne.value.data!;
    else
      results = plantProductListOne.value.data!
          .where((a) =>
              a.name!.toUpperCase().contains(query.toUpperCase()) ||
              a.title!.toUpperCase().contains(query.toUpperCase()))
          .toList();

    print('afterSearch' + results.length.toString());

    PlantProductListModal list =
        PlantProductListModal(status: "1", data: results, message: "kaif");

    plantProductListTwo.value = list;

    plantProductListTwo.refresh();
  }
}
