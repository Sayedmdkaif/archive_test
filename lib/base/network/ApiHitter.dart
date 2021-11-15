import 'dart:math';

import 'package:zacharchive_flutter/common/Strings.dart';
import 'package:zacharchive_flutter/extensions/UtilExtensions.dart';

import 'package:dio/dio.dart';
import 'package:zacharchive_flutter/base/constants/ApiEndpoint.dart';
import 'package:zacharchive_flutter/screen/LoginScreen_2.dart';
import 'package:zacharchive_flutter/utils/UserRepository.dart';

import 'network_exceptions.dart';

class ApiHitter {
  static Dio? _dio;

  static Dio? getDio({String? baseUrl}) {
    if (_dio == null) {
      BaseOptions options = new BaseOptions(
        baseUrl: baseUrl == null ? ApiEndpoint.BASE_URL : baseUrl,
        connectTimeout: 30000,
        receiveTimeout: 30000,
      );
      return new Dio(options)
        ..interceptors.add(
            InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
          return handler.next(options);
        }, onResponse: (Response response, handler) {
          return handler.next(response); // continue
        }, onError: (DioError e, handler) async {
          if (e.response == null)
            return handler.next(e);
          else if (e.response!.statusCode == 401) {
            // "Session Expire Please Login".toast();
            removPrefrenceData(key: Strings.USER);
            LoginScreen().navigate(isInfinity: true);
          } else
            return handler.next(e);
        }));
    } else {
      return _dio;
    }
  }

  Future<ApiResponse> getApiResponse(String endPoint,
      {Map<String, dynamic>? headers}) async {
    try {
      Response response = await Dio().get(endPoint,
          options: Options(
            headers: headers,
          ));

      print('kaifRes' + response.toString());

      return ApiResponse("1", msg: response);
    } catch (error) {
      try {
        print('kaifErro' + error.toString());

        return ApiResponse("0",
            successStatus: NetworkExceptions.getErrorMessage(
                NetworkExceptions.getDioException(e)));
      } catch (e) {
        return ApiResponse("0",
            successStatus: NetworkExceptions.getErrorMessage(
                NetworkExceptions.getDioException(e)));
      }
    }
  }

  Future<ApiResponse> getFormApiResponse(String endPoint,
      {required FormData data,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? params}) async {
    try {
      var response = await getDio()!.post(endPoint,
          data: data,
          options: Options(
            headers: headers,
            contentType: "application/json",
          ));
      print('kaifRes' + response.toString());
      return ApiResponse("1", msg: response, successStatus: "Data Found");
    } catch (error) {
      try {
        print('errokaif' +
            NetworkExceptions.getErrorMessage(
                    NetworkExceptions.getDioException(e))
                .toString());
        return ApiResponse("0",
            successStatus: NetworkExceptions.getErrorMessage(
                NetworkExceptions.getDioException(e)));
      } catch (e) {
        return ApiResponse("0",
            successStatus: NetworkExceptions.getErrorMessage(
                NetworkExceptions.getDioException(e)));
      }
    }
  }

  Future<dynamic> getPostApiResponse(
    String endPoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await getDio()!.post(endPoint, data: data);

      return ApiResponse("1", msg: response, successStatus: "Data Found");
    } catch (error) {
      try {
        print('errokaif' + e.toString());
        return ApiResponse("0",
            successStatus: NetworkExceptions.getErrorMessage(
                NetworkExceptions.getDioException(e)));
      } catch (e) {
        return ApiResponse("0",
            successStatus: NetworkExceptions.getErrorMessage(
                NetworkExceptions.getDioException(e)));
      }
    }
  }
}

class ApiResponse {
  final String status;
  final String successStatus;
  final Response? msg;

  @override
  String toString() {
    return 'ApiResponse{status: $status, successStatus: $successStatus, msg: $msg}';
  }

  ApiResponse(this.status, {this.successStatus = "Success", this.msg});
}
