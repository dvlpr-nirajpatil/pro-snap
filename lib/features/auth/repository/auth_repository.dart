import 'package:dio/dio.dart';
import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/core/services/app_services.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/core/services/notification_service.dart';
import 'package:prosnap/core/services/tokens.dart';
import 'package:prosnap/locator.dart';

class AuthRepository {
  final ApiClient apiClient = sl.get<ApiClient>();

  signUp({required String email, required String password}) async {
    try {
      final payload = {
        "email": email,
        "password": password,
        "deviceId": "s-1",
        "deviceType": "mobile",
      };

      final Response response = await apiClient.dio.post(
        "/auth/sign-up",
        data: payload,
      );

      final String accessToken = response.data['data']['accessToken'];
      final String refreshToken = response.data['data']['refreshToken'];
      final userDetails = response.data['data']['user'];

      await Future.wait([
        CurrentUser().save(userDetails),
        Tokens.save(accessToken: accessToken, refreshToken: refreshToken),
      ]);
      final fcmToken = NotificationService.fcmToken;

      if (fcmToken != null) {
        storeFcmToken();
      }
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  signIn({required String email, required String password}) async {
    try {
      final payload = {
        "email": email,
        "password": password,
        "deviceId": "s-1",
        "deviceType": "mobile",
      };

      final Response response = await apiClient.dio.post(
        "/auth/sign-in",
        data: payload,
      );

      final String accessToken = response.data['data']['accessToken'];
      final String refreshToken = response.data['data']['refreshToken'];
      final userDetails = response.data['data']['user'];

      await Future.wait([
        CurrentUser().save(userDetails),
        Tokens.save(accessToken: accessToken, refreshToken: refreshToken),
      ]);

      final fcmToken = NotificationService.fcmToken;

      if (fcmToken != null) {
        storeFcmToken();
      }
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  refreshToken() async {
    try {
      final payload = {"refreshToken": await Tokens.refreshToken};

      final Response response = await apiClient.dio.post(
        "/auth/refresh-token",
        data: payload,
      );

      final accessToken = response.data['data']['accessToken'];
      final refreshToken = response.data['data']['refreshToken'];
      await Tokens.save(accessToken: accessToken, refreshToken: refreshToken);

      final fcmToken = NotificationService.fcmToken;

      if (fcmToken != null) {
        storeFcmToken();
      }
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  getCurrentUserDetails() async {
    try {
      final Response response = await apiClient.dio.get("/auth/me");
      final user = response.data['data']['user'];
      await CurrentUser().save(user);
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  signOut() async {
    try {
      await apiClient.dio.get("/auth/sign-out");
      await Tokens.clear();
      await CurrentUser().delete();
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  storeFcmToken() async {
    try {
      final payload = {"fcmToken": NotificationService.fcmToken};
      await apiClient.dio.post("/auth/fcm-token", data: payload);
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      rethrow;
    }
  }
}
