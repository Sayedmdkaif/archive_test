import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:zacharchive_flutter/base/BaseRepository.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/base/network/ApiHitter.dart';
import 'package:zacharchive_flutter/modals/ApiCommonModal.dart';
import 'package:zacharchive_flutter/modals/ControlRoomModal.dart';
import 'package:zacharchive_flutter/modals/FilterChangeDescriptionModal.dart';
import 'package:zacharchive_flutter/modals/LockOutDetailModal.dart';
import 'package:zacharchive_flutter/modals/LoginModal.dart';
import 'package:zacharchive_flutter/modals/OperationModal.dart';
import 'package:zacharchive_flutter/modals/PlantCategoriesModal.dart';
import 'package:zacharchive_flutter/modals/PlantProductDetailModal2.dart';
import 'package:zacharchive_flutter/modals/PlantProductListModal.dart';
import 'package:zacharchive_flutter/modals/UserDetailModal.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';

class ApiRepo extends BaseRepository {


  Future<LoginModal> loginRepo({
    required String email,
    required String password,
  }) async {
    var formData = FormData();

    formData.fields.add(MapEntry('email', email));
    formData.fields.add(MapEntry('password', password));


    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.LOGIN,
        data: formData);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());


      if (apiResponse.status == "1") {
        return LoginModal.fromJson(userdata);
      } else {
        return LoginModal(status: '0',);
      }
    } catch (error) {
      try {
        return LoginModal(status: '400',);
      } catch (e) {
        return LoginModal(status: '400', );
      }
    }
  }


Future<ApiCommonModal> forgetPasswordRepo({
    required String email,}) async {
    var formData = FormData();

    formData.fields.add(MapEntry('email', email));


    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.FORGET_PASSWORD,
        data: formData);

    try {
      print('kaksdsdfasdfasdf'+apiResponse.msg!.toString());

      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());


      if (apiResponse.status == "1") {
        return ApiCommonModal.fromJson(userdata);
      } else {
        return ApiCommonModal(status: '0',);
      }
    } catch (error) {
      try {
        print('asdsd');
        return ApiCommonModal(status: '400',);
      } catch (e) {
        return ApiCommonModal(status: '400', );
      }
    }
  }



Future<ApiCommonModal> logOutUserRepo() async {
    var formData = FormData();

    var user = await getUser();
    print('kaittoken_'+'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.LOGOUT,
        headers: {'Authorization': 'Bearer ${user.data!.token!}'},
        data: formData);



    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return ApiCommonModal.fromJson(userdata);
      } else {
        return ApiCommonModal(status: '0',);
      }
    } catch (error) {
      try {
        return ApiCommonModal(status: '400',);
      } catch (e) {
        return ApiCommonModal(status: '400', );
      }
    }
  }


Future<ApiCommonModal> verifyOTPRepo({
    required String id, required String otp,}) async {

    var formData = FormData();
    formData.fields.add(MapEntry('id', id));
    formData.fields.add(MapEntry('otp', otp));


    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.VERIFY_OTP_FORGET_PASSWORD,
        data: formData);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());


      if (apiResponse.status == "1") {
        return ApiCommonModal.fromJson(userdata);
      } else {
        return ApiCommonModal(status: '0',);
      }
    } catch (error) {
      try {
        return ApiCommonModal(status: '400',);
      } catch (e) {
        return ApiCommonModal(status: '400', );
      }
    }
  }

//used in forget password
  Future<ApiCommonModal> updatePasswordRepo({
    required String id, required String password,}) async {
    var formData = FormData();

    formData.fields.add(MapEntry('id', id));
    formData.fields.add(MapEntry('password', password));


    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.UPDATE_PASSWORD,
        data: formData);

    try {
      //print('mmmm');
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());
      //print('kkkkk'+userdata.toString()+" "+(apiResponse.status == "1").toString());
    //  print('sallu'+ApiCommonModal.fromJson(userdata).toString());

      if (apiResponse.status == "1") {
        return ApiCommonModal.fromJson(userdata);
      } else {
        return ApiCommonModal(status: '0',);
      }
    } catch (error) {
      try {
        return ApiCommonModal(status: '400',);
      } catch (e) {
        return ApiCommonModal(status: '400', );
      }
    }
  }

  //used in profile dashboard
Future<ApiCommonModal> updateProfilePasswordRepo({
    required String oldPassword, required String newPassword,}) async {
    var formData = FormData();

    print('oldPas'+oldPassword);
    print('newPassword'+newPassword);

    formData.fields.add(MapEntry('old_password', oldPassword));
    formData.fields.add(MapEntry('new_password', newPassword));

    var user = await getUser();
    print('kaittoken_'+'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
      ApiEndpoint.BASE_URL+ApiEndpoint.UPDATE_USER_PASSWORD,
      headers: {'Authorization': 'Bearer ${user.data!.token!}','Accept':"application/json"},
    data: formData);


    try {
      print('sallasdfasdu'+apiResponse.status);
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());
      print('sallu'+userdata.toString()+" "+apiResponse.status == "1".toString());

      if (apiResponse.status == "1") {
        return ApiCommonModal.fromJson(userdata);
      } else {
        return ApiCommonModal(status: '0',);
      }
    } catch (error) {
      try {
        return ApiCommonModal(status: '400',);
      } catch (e) {
        return ApiCommonModal(status: '400', );
      }
    }
  }


Future<ApiCommonModal> updateProfileRepo({
    required String name, required String phone, required String locationId,}) async {
    var formData = FormData();


    formData.fields.add(MapEntry('name', name));
    formData.fields.add(MapEntry('phone', phone));
    formData.fields.add(MapEntry('location_id', locationId));

    var user = await getUser();
    print('kaittoken_'+'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
      ApiEndpoint.BASE_URL+ApiEndpoint.UPDATE_USER_PROFILE,
      headers: {'Authorization': 'Bearer ${user.data!.token!}','Accept':"application/json"},
    data: formData);


    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return ApiCommonModal.fromJson(userdata);
      } else {
        return ApiCommonModal(status: '0',);
      }
    } catch (error) {
      try {
        return ApiCommonModal(status: '400',);
      } catch (e) {
        return ApiCommonModal(status: '400', );
      }
    }
  }


  Future<ApiCommonModal> registerRepo({
    required String id,
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    var formData = FormData();



    formData.fields.add(MapEntry('id', id));
    formData.fields.add(MapEntry('email', email));
    formData.fields.add(MapEntry('name', name));
    formData.fields.add(MapEntry('phone', phone));
    formData.fields.add(MapEntry('password', password));


    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.REGISTER,
        data: formData);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return ApiCommonModal.fromJson(userdata);
      } else {
        return ApiCommonModal(status: '0',);
      }
    } catch (error) {
      try {
        return ApiCommonModal(status: '400',);
      } catch (e) {
        return ApiCommonModal(status: '400', );
      }
    }
  }


Future<UserDetailModal> getUserDetailsFromLinkRepo({
    required String link,
  }) async {

    ApiResponse apiResponse = await apiHitter.getApiResponse(
       link
    );


    try {
     print('getUserDetailsFromLinkRepo'+apiResponse.msg.toString());
      Map<String, dynamic> userdata = json.decode(apiResponse.msg.toString());
     // print('fetchNotificationsRepo' + userdata.toString());

      if (apiResponse.status == "1") {
        return UserDetailModal.fromJson(userdata);
      } else {
        return UserDetailModal(status: '0',message: "Failed");
      }
    } catch (error) {
      try {
        print('errorget11'+error.toString());
        return UserDetailModal(status: '400',message: "Failed");
      } catch (e) {
        print('errorget'+e.toString());

        return UserDetailModal(status: '400',message: "Failed");
      }
    }
  }


  Future<PlantCategoriesModal> fetchPlantCategoriesRepo() async {

    var user = await getUser();
    print('kaittoken_'+'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.PLANT_CATEGORIES,
        headers: {'Authorization': 'Bearer ${user.data!.token!}','Accept':"application/json"},);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return PlantCategoriesModal.fromJson(userdata);
      } else {
        return PlantCategoriesModal(status: '0',);
      }
    } catch (error) {
      try {
        return PlantCategoriesModal(status: '400',);
      } catch (e) {
        return PlantCategoriesModal(status: '400', );
      }
    }
  }


  Future<PlantProductListModal> fetchPlantProductListRepo({required String categoryId,required String url}) async {

    var user = await getUser();
    print('kaittoken_'+'Bearer ${user!.data!.token!}');
    print('urlkkkk'+url);

    ApiResponse apiResponse = await apiHitter.getApiResponse(
      /*  ApiEndpoint.BASE_URL+ApiEndpoint.PLANT_PRODUCT_LIST+"/"+categoryId,*/
      url,
        headers: {'Authorization': 'Bearer ${user.data!.token!}'},);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());


      if (apiResponse.status == "1") {
        return PlantProductListModal.fromJson(userdata);
      } else {
        return PlantProductListModal(status: '0',);
      }
    } catch (error) {
      print('bbbbb');
      try {
        return PlantProductListModal(status: '400',);
      } catch (e) {
        return PlantProductListModal(status: '400', );
      }
    }
  }


Future<OperationModal> fetchOpeationHeavyTaskSubCategoryRepo({required String categoryId}) async {

    var user = await getUser();
    print('kaittoken_'+'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.FETCH_OPERATION_SUB_CATEGORY+"/"+categoryId,
        headers: {'Authorization': 'Bearer ${user.data!.token!}'},);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());


      if (apiResponse.status == "1") {
        return OperationModal.fromJson(userdata);
      } else {
        return OperationModal(status: '0',);
      }
    } catch (error) {
      try {
        return OperationModal(status: '400',);
      } catch (e) {
        return OperationModal(status: '400', );
      }
    }
  }


  Future<PlantProductDetailModal2> fetchProductDetailsForPlantRepo({required String categoryId}) async {
    var user = await getUser();
    print('kaittoken_'+'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.FETCH_PRODUCT_DETAILS_FOR_PLANT222+"/"+categoryId,
        headers: {'Authorization': 'Bearer ${user.data!.token!}'},);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return PlantProductDetailModal2.fromJson(userdata);
      } else {
        return PlantProductDetailModal2(status: '0',);
      }
    } catch (error) {
      try {
        return PlantProductDetailModal2(status: '400',);
      } catch (e) {
        return PlantProductDetailModal2(status: '400', );
      }
    }
  }


  Future<LockOutDetailModal> fetchLockoutDetailsRepo({required String productId,required String from}) async {

    var user = await getUser();
    print('kaittoken_'+'Bearer ${user!.data!.token!}');
    var formData = FormData();
      formData.fields.add(MapEntry('from', from));
      formData.fields.add(MapEntry('product_id', productId));


    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
        ApiEndpoint.BASE_URL+ApiEndpoint.FETCH_LOCKOUT_DETAILS,
      data:formData,
        headers: {'Authorization': 'Bearer ${user.data!.token!}'},);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return LockOutDetailModal.fromJson(userdata);
      } else {
        return LockOutDetailModal(status: '0',);
      }
    } catch (error) {
      try {
        return LockOutDetailModal(status: '400',);
      } catch (e) {
        return LockOutDetailModal(status: '400', );
      }
    }
  }


  Future<ApiCommonModal> updateUserLocationRepo({
    required String locationId,
  }) async {
    var formData = FormData();

    formData.fields.add(MapEntry('location_id', locationId));

    var user = await getUser();
    print('kaittoken_' + 'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getFormApiResponse(
        ApiEndpoint.BASE_URL + ApiEndpoint.UPDATE_USER_LOCATION,
        headers: {
          'Authorization': 'Bearer ${user.data!.token!}',
          'Accept': "application/json"
        },
        data: formData);

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return ApiCommonModal.fromJson(userdata);
      } else {
        return ApiCommonModal(
          status: '0',
        );
      }
    } catch (error) {
      try {
        return ApiCommonModal(
          status: '400',
        );
      } catch (e) {
        return ApiCommonModal(
          status: '400',
        );
      }
    }
  }




  FormData maplistImages(List<String> postMediaImage) {
    var formData = FormData();
    postMediaImage.forEach((e) async {
      if (e != null && e.isNotEmpty)
     {
       print('ImageFilePath_'+e);
       print('ImageFileName_'+basename(e));
       formData.files.add(MapEntry("image_list[]", await MultipartFile.fromFile(e, filename: basename(e))));
     }

    });


    return formData;
  }

  FormData maplistVideos(List<String> postMediaImage2) {
    var formData2 = FormData();
    postMediaImage2.forEach((e1) async {
      if (e1 != null && e1.isNotEmpty)
      {
        print('VIdeoFilePath_'+e1);
        print('VIdeoFileName_'+basename(e1));
        formData2.files.add(MapEntry("video_list[]", await MultipartFile.fromFile(e1, filename: basename(e1))));
      }

    });


    return formData2;
  }


  Future<OperationModal> fetchOperationRepo() async {
    var user = await getUser();
    print('kaittoken_' + 'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getApiResponse(
      ApiEndpoint.BASE_URL + ApiEndpoint.FETCH_OPERATION_SUB_CATEGORY+"/0",
      headers: {
        'Authorization': 'Bearer ${user.data!.token!}',
        'Accept': "application/json"
      },
    );

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return OperationModal.fromJson(userdata);
      } else {
        return OperationModal(
          status: '0',
        );
      }
    } catch (error) {
      try {
        return OperationModal(
          status: '400',
        );
      } catch (e) {
        return OperationModal(
          status: '400',
        );
      }
    }
  }


  Future<ControlRoomModal> fetchControlRoomProductDetailsRepo({    required String productId,}) async {
    var user = await getUser();
    print('kaittoken_' + 'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getApiResponse(
      ApiEndpoint.BASE_URL + ApiEndpoint.FETCH_CONTROL_ROOM_PRODUCT_DETAILS+"/"+productId,
      headers: {
        'Authorization': 'Bearer ${user.data!.token!}',
        'Accept': "application/json"
      },
    );

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return ControlRoomModal.fromJson(userdata);
      } else {
        return ControlRoomModal(
          status: '0',
        );
      }
    } catch (error) {
      try {
        return ControlRoomModal(
          status: '400',
        );
      } catch (e) {
        return ControlRoomModal(
          status: '400',
        );
      }
    }
  }
  Future<FilterChangeDescriptionModal> fetchProductDetailsForFilterChangeRepo({    required String categoryId,}) async {
    var user = await getUser();
    print('kaittoken_' + 'Bearer ${user!.data!.token!}');

    ApiResponse apiResponse = await apiHitter.getApiResponse(
      ApiEndpoint.BASE_URL + ApiEndpoint.FETCH_PRODUCT_DETAILS_FOR_FILTER_CHANGE+"/"+categoryId,
      headers: {
        'Authorization': 'Bearer ${user.data!.token!}',
        'Accept': "application/json"
      },
    );

    try {
      Map<String, dynamic> userdata = json.decode(apiResponse.msg!.toString());

      if (apiResponse.status == "1") {
        return FilterChangeDescriptionModal.fromJson(userdata);
      } else {
        return FilterChangeDescriptionModal(
          status: '0',
        );
      }
    } catch (error) {
      try {
        return FilterChangeDescriptionModal(
          status: '400',
        );
      } catch (e) {
        return FilterChangeDescriptionModal(
          status: '400',
        );
      }
    }
  }

}