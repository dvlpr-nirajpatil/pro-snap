import 'package:dio/dio.dart';
import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/core/services/app_services.dart';
import 'package:prosnap/features/chating/models/chat_details_model.dart';

class ChatRepository {
  final ApiClient apiClient = AppServices.apiClient;

  getMessages(conversationId) async {
    try {
      final Response response = await apiClient.dio.get(
        "/message/$conversationId",
      );
      return response.data;
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      rethrow;
    }
  }

  getChatDetails(conversationId) async {
    try {
      final Response response = await apiClient.dio.get(
        "/message/$conversationId/details",
      );
      return ChatDetailsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      rethrow;
    }
  }

  sendMessage({
    required String conversationId,
    required String text,
    dynamic image,
  }) async {
    try {
      final payload = {
        "conversationId": conversationId,
        "text": text,
        "image": image,
      };
      final Response response = await apiClient.dio.post(
        "/message",
        data: payload,
      );
      return response.data;
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      rethrow;
    }
  }
}
