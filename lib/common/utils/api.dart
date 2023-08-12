import 'package:dio/dio.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:logger/logger.dart';

String getApi(API apiType) {
  String api = BASE_URL;
  api += apiMap[apiType]!;
  return api;
}

commonResponseResult(Response<dynamic> response, Function successCallback) {
  try {
    var logger = Logger();
    switch (response.statusCode) {
      case 200:
        return successCallback();
      case 404:
        logger.e('ERROR: 서버에 404 에러가 있습니다.');
        return response.data;
      default:
        logger.e('ERROR: 서버의 API 호출에 실패했습니다.');
        throw Exception('서버의 API 호출에 실패했습니다.');
    }
  } on DioException catch (error) {
    if (error.response != null) {
      throw Exception('${error.response!.data['errorMessage']}');
    }
    throw Exception('서버 요청에 실패했습니다.');
  }
}
