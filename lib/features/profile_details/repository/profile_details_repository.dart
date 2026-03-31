import 'package:dio/dio.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/core/services/app_services.dart';
import 'package:prosnap/features/profile_details/models/profile_details.dart';

class ProfileDetailsRepository {
  final ApiClient apiClient = AppServices.apiClient;

  getProfileDetails(userId) async {
    try {
      final Response response = await apiClient.dio.get("/profile/$userId");
      final raw = response.data['data'];
      return ProfileDetails.fromJson(raw);
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      logger.e(e);
    }
  }
}
