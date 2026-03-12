import 'package:dio/dio.dart';
import 'package:prosnap/core/network/auth_interceptor.dart';
import 'package:prosnap/core/network/logger_intercepter.dart';
import 'error_interceptor.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://inordinately-serous-maryann.ngrok-free.dev/api/v1",
        connectTimeout: const Duration(seconds: 200),
        receiveTimeout: const Duration(seconds: 200),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.addAll([
      LoggerInterceptor(),
      AuthInterceptor(),
      ErrorInterceptor(dio),
    ]);
  }
}
