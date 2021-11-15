
import 'package:get/get.dart';
import 'package:zacharchive_flutter/modals/NotesModal.dart';
import 'package:zacharchive_flutter/modals/PlantProductDetailModal2.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';

class SearchedDescriptionController extends GetxController {
  var noDataFound = false.obs;
  var repo = ApiRepo();
  var loading = false.obs;

  var barCodeFormat="".obs;
  var barCode="".obs;
 var selectedTabIndx=0.obs;

  RxList<NotesModal> notesList = <NotesModal>[].obs;
  //var isEngineSelected=true.obs;
  //var isCompressorSelected=false.obs;
  Rx<PlantProductDetailModal2> plantProductLisDetails = PlantProductDetailModal2().obs;
  List<NotesModal> list=[];
  List<Note> originalNotesList=[];

  var searchingText=''.obs;

  void updateDataFound(bool value) {
    noDataFound.value = value;
  }

  Future<PlantProductDetailModal2> fetchProductDetailsForPlantAPI({required String categoryId}) async {
    PlantProductDetailModal2 dataResponse = await repo.fetchProductDetailsForPlantRepo(categoryId: categoryId);

    print('dataRes'+dataResponse.status!);


    List<Note> newNotesList=[];

    originalNotesList.clear();
    originalNotesList.addAll(dataResponse.data!.notes!);

    if(dataResponse.data!.notes!.length>5) {

      for (int i = 0; i < 6; i++)
        newNotesList.add(dataResponse.data!.notes![i]);

      dataResponse.data!.notes=newNotesList;

    }


      plantProductLisDetails.value = dataResponse;

    return dataResponse;
  }
  void fetchSearchAPI() async {


    var modal=NotesModal(isNew:true,title:" Lorem ipsum  Lorem ipsum", name:"User Name",time: "(10.30 AM 30 Aug, 2021)",image: "https://i.picsum.photos/id/531/536/354.jpg?hmac=qjs0KEj1K79Jc1raGC-Q2H-gpJpi012SUYBU-o1Jyqc",description: "In publishing and graphic design, Lorem ipsum In publishing and graphic design, Lorem ipsum");
    var modal2=NotesModal(isNew:false,title:" Lorem ipsum  Lorem ipsum", name:"User Name",time: "(10.30 AM 30 Aug, 2021)",image: "https://i.picsum.photos/id/531/536/354.jpg?hmac=qjs0KEj1K79Jc1raGC-Q2H-gpJpi012SUYBU-o1Jyqc",description: "In publishing and graphic design, Lorem ipsum In publishing and graphic design, Lorem ipsum");


    list.clear();


    list.add(modal);
    list.add(modal2);
    list.add(modal2);



    notesList.addAll(list);

  }
}
