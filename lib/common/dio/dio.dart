import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:logger/logger.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final secureStorage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(secureStorage: secureStorage),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  // dio는 많은 기능을 제공하는데
  // 요청을 보내기 전, 응답이 애플리케이션에 도착에 위젯에 넘어가기전, 에러발생시
  // 이 interceptor가 사전 처리를 할 수 있음

  final FlutterSecureStorage secureStorage;

  // constructor
  CustomInterceptor({
    required this.secureStorage,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    // access 토큰 자동 적용
    // TODO: true 일때 따로 없을꺼라 if문 지워야함
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
    }
    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    options.headers.addAll({
      'Authorization': 'Bearer $accessToken',
    });

    // refresh 토큰 자동 적용
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
    }
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);

    options.headers.addAll({
      'Authorization-refresh': 'Bearer $refreshToken',
    });

    super.onRequest(options, handler);
  }

  void autoRefreshAccessToken({
    required DioException err,
    required ErrorInterceptorHandler handler,
  }) async {
    final dio = Dio();
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
    try {
      final resp = await dio.post(
        // TODO : API request path 변경
        'http://sample/auth/token',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );

      final accessToken = resp.data['accessToken'];
      await secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

      final options = err.requestOptions;

      options.headers.addAll({
        'authorization': 'Bearer $accessToken',
      });

      final response = await dio.fetch(options);

      return handler.resolve(response);
    } on DioException catch (error) {
      return handler.reject(error);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: 해더를 보고 토큰을 갱신시킨다.
    var logger = Logger();
    logger.i("onResponse");
    logger.i(response.headers, response.data);

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO: 토큰 오류시 로그인페이지로 보내고, 다시 로그인 시키면 알아서 서버에서 새로운 토큰을 준다. (강의6-5)
    // zeppy token에 문제있을 시 status code 401 반환
    var logger = Logger();
    logger.e(err);
    logger.e(err.response?.data);
    /*
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);

    // TODO <dio.dart> refresh token 없을 때 처리

    // kakao accessToken이 유효한지
    // 유효하지 않다면 kakao refreshToken으로 갱신시켜서 보내주고
    // kakao refreshToken의 유효기간이 1달남았다면 refreshToken갱신후 보내주기
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathAccessTokenRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathAccessTokenRefresh) {
      return autoRefreshAccessToken(err: err, handler: handler);
    }
    */
    super.onError(err, handler);
  }
}
