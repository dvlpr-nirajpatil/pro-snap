import 'package:dio/dio.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/core/services/current_user.dart';
import 'package:prosnap/locator.dart';

class ProfileSetupRepository {
  final ApiClient apiClient = sl.get<ApiClient>();

  saveUserDetails({
    required String name,
    required String userName,
    required String gender,
    required String dob,
    required String bio,
    String? profilePicture,
  }) async {
    try {
      final payload = {
        "name": name,
        "userName": userName,
        "bio": bio,
        "gender": gender,
        "dob": dob,
        "profilePicture": profilePicture,
      };

      final Response response = await apiClient.dio.patch(
        "/registration/profile",
        data: payload,
      );
      final userDetails = response.data['data'];
      CurrentUser().save(userDetails);
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  uploadProfilePicture(imagePath) async {
    try {
      final FormData formData = FormData();

      formData.files.add(
        MapEntry("image", await MultipartFile.fromFile(imagePath)),
      );

      final Response response = await apiClient.dio.post(
        "/upload/single",
        data: formData,
      );

      return response.data['data']['url'];
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
