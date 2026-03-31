import 'package:dio/dio.dart';
import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/core/services/app_services.dart';

class HomeRepository {
  final ApiClient apiClient = AppServices.apiClient;

  getFeed({page = 1}) async {
    try {
      final Response response = await apiClient.dio.get("/feed/?page=$page");
      return response.data;
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }
}
