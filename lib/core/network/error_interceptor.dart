import 'package:dio/dio.dart';
import 'package:prosnap/core/network/logger_intercepter.dart';
import 'package:prosnap/core/services/app_services.dart';
import 'package:prosnap/core/services/socket_service.dart';
import 'package:prosnap/core/services/tokens.dart';

import 'api_exception.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._dio);

  final Dio _dio;
  Future<void>? _refreshFuture;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRefreshToken(err)) {
      try {
        await (_refreshFuture ??= _refreshToken());

        final newAccessToken = Tokens.accessToken;
        if (newAccessToken == null || newAccessToken.isEmpty) {
          throw const ApiException(
            message: 'Session expired. Please sign in again.',
            statusCode: 401,
          );
        }

        final retryOptions = err.requestOptions.copyWith(
          headers: {
            ...err.requestOptions.headers,
            'Authorization': 'Bearer $newAccessToken',
          },
          extra: {...err.requestOptions.extra, '_retry': true},
        );

        final response = await _dio.fetch<dynamic>(retryOptions);
        handler.resolve(response);
        return;
      } on DioException catch (retryError) {
        _rejectMappedError(retryError, handler);
        return;
      } on ApiException catch (apiError) {
        handler.reject(
          DioException(requestOptions: err.requestOptions, error: apiError),
        );
        return;
      } finally {
        _refreshFuture = null;
      }
    }

    _rejectMappedError(err, handler);
  }

  bool _shouldRefreshToken(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final message =
        data is Map<String, dynamic> ? data['message']?.toString() : null;
    final isRetry = err.requestOptions.extra['_retry'] == true;
    final isRefreshCall = err.requestOptions.path.contains('/auth/refresh-token');

    return statusCode == 401 &&
        message == 'Access token expired' &&
        !isRetry &&
        !isRefreshCall;
  }

  Future<void> _refreshToken() async {
    final refreshToken = await Tokens.refreshToken;

    if (refreshToken == null || refreshToken.isEmpty) {
      throw const ApiException(
        message: 'Session expired. Please sign in again.',
        statusCode: 401,
      );
    }

    try {
      final Dio refreshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          connectTimeout: _dio.options.connectTimeout,
          receiveTimeout: _dio.options.receiveTimeout,
          sendTimeout: _dio.options.sendTimeout,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      refreshDio.interceptors.add(LoggerInterceptor());

      final response = await refreshDio.post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      final accessToken = response.data['data']['accessToken'] as String?;
      final nextRefreshToken = response.data['data']['refreshToken'] as String?;

      if (accessToken == null ||
          accessToken.isEmpty ||
          nextRefreshToken == null ||
          nextRefreshToken.isEmpty) {
        throw const ApiException(
          message: 'Session expired. Please sign in again.',
          statusCode: 401,
        );
      }

      await Tokens.save(
        accessToken: accessToken,
        refreshToken: nextRefreshToken,
      );

      final SocketService socket = AppServices.socketService;
      socket.disconnect();
      socket.connect(Tokens.accessToken);
    } on DioException catch (e) {
      await Tokens.clear();

      final data = e.response?.data;
      final message =
          data is Map<String, dynamic>
              ? data['message']?.toString() ??
                  'Session expired. Please sign in again.'
              : 'Session expired. Please sign in again.';

      throw ApiException(message: message, statusCode: 401);
    }
  }

  void _rejectMappedError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NoInternetException(),
        ),
      );
      return;
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const ApiException(
            message: 'Connection timeout. Please try again.',
            statusCode: 408,
          ),
        ),
      );
      return;
    }

    if (err.response != null) {
      final data = err.response?.data;

      if (data is Map<String, dynamic>) {
        final status = data['status'] ?? err.response?.statusCode ?? 500;
        final message = data['message'] ?? 'Something went wrong';

        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ApiException(
              message: message.toString(),
              statusCode: status is int ? status : err.response?.statusCode,
            ),
          ),
        );
        return;
      }
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: const ApiException(
          message: 'Unexpected error occurred',
          statusCode: 500,
        ),
      ),
    );
  }
}
