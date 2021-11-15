import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/FilterChangeDescriptionModal.dart';
import 'package:zacharchive_flutter/modals/PlantProductDetailModal2.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class FilterDescriptionController extends GetxController {
  var noDataFound = false.obs;
  var repo = ApiRepo();
  var loading = false.obs;
  List<Note> originalNotesList = [];

  Rx<FilterChangeDescriptionModal> productLisDetailsList =
      FilterChangeDescriptionModal().obs;

  void updateDataFound(bool value) {
    noDataFound.value = value;
  }

  Future<FilterChangeDescriptionModal> fetchProductDetailsForFilterChangeAPI(
      {required String categoryId}) async {
    FilterChangeDescriptionModal dataResponse = await repo
        .fetchProductDetailsForFilterChangeRepo(categoryId: categoryId);

    List<Note> newNotesList = [];

    originalNotesList.clear();
    originalNotesList.addAll(dataResponse.data!.notes!);

    if (dataResponse.data!.notes!.length > 5) {
      for (int i = 0; i < 6; i++)
        newNotesList.add(dataResponse.data!.notes![i]);

      dataResponse.data!.notes = newNotesList;
    }

    productLisDetailsList.value = dataResponse;

    return dataResponse;
  }
}
