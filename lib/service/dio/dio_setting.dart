import 'dart:async';
import "package:dio/dio.dart";
import 'package:flutter/foundation.dart';


class DioSettings {
  DioSettings() {
    unawaited(setup());
  }

  Dio dio = Dio(
    BaseOptions(
      contentType: "application/json",
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<void> setup() async {
    final Interceptors interceptors = dio.interceptors;
    interceptors.clear();

    final LogInterceptor loginterceptor = LogInterceptor(
      requestBody: true,
      responseBody: true,
    );

    final QueuedInterceptorsWrapper headerInterceptors =
        QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) =>
          handler.next(options),
      onError: (DioException error, ErrorInterceptorHandler handler) {
        handler.next(error);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) =>
          handler.next(response),
    );
    interceptors.addAll([if (kDebugMode) loginterceptor, headerInterceptors]);
  }
}
/* 
  Bu yapı, projende HTTP isteklerini daha kontrollü,
  loglanabilir ve esnek bir şekilde yönetmeni 
  sağlıyor. Özellikle hata ayıklama aşamalarında 
  çok yardımcı olur ve isteklerin yapısı üzerinde
  çeşitli işlemler yapmanı sağlar.
 */