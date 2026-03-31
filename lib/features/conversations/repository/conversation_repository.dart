import 'package:dio/dio.dart';
import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/core/services/app_services.dart';

class ConversationRepository {
  final ApiClient apiClient = AppServices.apiClient;

  createConversation({required String receiverId}) async {
    try {
      final payload = {"receiverId": receiverId};
      final Response response = await apiClient.dio.post(
        "/conversation",
        data: payload,
      );
      return response.data['data']['conversationId'];
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      rethrow;
    }
  }

  getConversation() async {
    try {
      final Response response = await apiClient.dio.get("/conversation");
      return response.data;
    } on DioException catch (e) {
      throw e.error as Exception;
    } catch (e) {
      rethrow;
    }
  }
}
