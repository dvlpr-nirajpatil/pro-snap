import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:prosnap/core/network/api_client.dart';

class ConversationRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

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
