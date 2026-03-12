import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/features/profile_details/models/profile_details.dart';

class ProfileDetailsRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

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
