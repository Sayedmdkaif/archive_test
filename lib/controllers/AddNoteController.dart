import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';
import 'package:zacharchive_flutter/repo/ApiRepo.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';

class AddNoteController extends GetxController {
  var repo = ApiRepo();
  TextEditingController ytLinkController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  RxList<File> imageList = <File>[].obs;
  List<String> images = [];

  var addNoteApiRes = false.obs;

  List<String> youtubeURLS = [];
  List<YoutubePlayerController> youtubeList = <YoutubePlayerController>[].obs;

  List<Container> videoWidget = <Container>[].obs;
  List<String> videos = [];
  RxList<File> videoList = <File>[].obs;

  var color = Colors.white.obs;

  Future<String> addProductNotesAPI(
      {required String productId, required String from}) async {
    var user = await getUser();

    var uri = Uri.parse(ApiEndpoint.BASE_URL + ApiEndpoint.ADD_PRODUCT_NOTES);

    var request = new http.MultipartRequest("POST", uri);

    for (var file in imageList) {
      String fileName = file.path.split("/").last;
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));

      var length = await file.length(); //imageFile is your image file

      var multipartFileSign = new http.MultipartFile(
          'image_list[]', stream, length,
          filename: fileName);

      request.files.add(multipartFileSign);
    }

    for (var file in videoList) {
      String fileName = file.path.split("/").last;
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));

      var length = await file.length(); //imageFile is your image file

      var multipartFileSign = new http.MultipartFile(
          'video_list[]', stream, length,
          filename: fileName);

      request.files.add(multipartFileSign);
    }

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${user!.data!.token!}"
    }; //

    request.headers.addAll(headers);

    request.fields['from'] = from;
    request.fields['product_id'] = productId;
    request.fields['notes'] = noteController.getValue();
    request.fields['title'] = titleController.getValue();
    request.fields['youtube_urls'] =
        youtubeURLS.toString().substring(1, youtubeURLS.toString().length - 1);

    var status = "";

    await request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        var jsonMap = json.decode(response.body);
        print('APiRes' + jsonMap.toString());
        print('uploadingStatus' + jsonMap["status"].toString());

        status = jsonMap["status"].toString();
      });
    }).catchError((err) {
      print('error : ' + err.toString());
    }).whenComplete(() {
      print('whenCalled' + status);
    });

    await Future.delayed(Duration(milliseconds: 300));

    print('finalRes' + status);
    return status;
  }
}
