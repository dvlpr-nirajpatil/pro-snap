import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:prosnap/core/network/api_client.dart';

class CreatePostRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  uploadImages(List<String> images) async {
    try {
      final FormData formData = FormData();

      for (String path in images) {
        formData.files.add(
          MapEntry("images", await MultipartFile.fromFile(path)),
        );
      }

      final Response response = await apiClient.dio.post(
        "/upload/multiple",
        data: formData,
      );

      return response.data['data'];
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  createPost({caption, required List media, location}) async {
    try {
      final payload = {
        "caption": caption,
        "media": media,
        "location": location,
      };

      await apiClient.dio.post("/post/", data: payload);
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }
}
