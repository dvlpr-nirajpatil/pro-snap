import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';

import 'package:prosnap/core/network/api_client.dart';

class PostsRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  likePost(postId) async {
    try {
      await apiClient.dio.post("/post/$postId/like");
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  deletePost(postId) async {
    try {
      await apiClient.dio.delete("/post/$postId/like");
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  commentPost({postId, comment, parentComment}) async {
    try {
      final payload = {"text": comment, "parentCommentId": parentComment};
      await apiClient.dio.post("/post/$postId/comment", data: payload);
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  getPostComments({postId}) async {
    try {
      await apiClient.dio.get("/post/$postId/comments");
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
