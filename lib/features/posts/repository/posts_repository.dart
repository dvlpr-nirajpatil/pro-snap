import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';

import 'package:prosnap/core/network/api_client.dart';
import 'package:prosnap/features/posts/models/post_comment.dart';

class PostsRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<void> likePost(String postId) async {
    try {
      await apiClient.dio.post("/post/$postId/like");
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      await apiClient.dio.delete("/post/$postId/like");
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  Future<PostComment?> commentPost({
    required String postId,
    required String comment,
    String? parentCommentId,
  }) async {
    try {
      final payload = {
        "text": comment,
        if (parentCommentId != null && parentCommentId.isNotEmpty)
          "parentCommentId": parentCommentId,
      };
      final response = await apiClient.dio.post(
        "/post/$postId/comment",
        data: payload,
      );
      final rawComment =
          response.data['data']?['comment'] ?? response.data['data'];
      if (rawComment is Map<String, dynamic>) {
        return PostComment.fromJson(rawComment);
      }
      if (rawComment is Map) {
        return PostComment.fromJson(Map<String, dynamic>.from(rawComment));
      }
      return null;
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  Future<List<PostComment>> getPostComments({required String postId}) async {
    try {
      final response = await apiClient.dio.get("/post/$postId/comments");
      final rawComments =
          response.data['data']?['comments'] ?? response.data['data'];
      if (rawComments is List) {
        return rawComments
            .whereType<Map>()
            .map((e) => PostComment.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  deleteComment({commentId}) async {
    try {
      await apiClient.dio.delete("/post/comment/$commentId");
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  getLikes({postId}) async {
    try {
      await apiClient.dio.delete("/post/$postId/likes");
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }
}
