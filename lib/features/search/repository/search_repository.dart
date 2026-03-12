import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:prosnap/core/global/globals.dart';
import 'package:prosnap/core/network/api_client.dart';

class SearchRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  searchUsers(query) async {
    try {
      final Response response = await apiClient.dio.get(
        "/search/users?q=$query",
      );

      return response.data;
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  getSearchFeed({page = 1}) async {
    try {
      final Response response = await apiClient.dio.get(
        "/search/feed?page=$page&limit=21",
      );
      return response.data;
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
