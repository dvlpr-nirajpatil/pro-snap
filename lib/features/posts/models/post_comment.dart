class PostComment {
  final String id;
  final String text;
  final String? parentCommentId;
  final String? createdAt;
  final CommentUser? user;

  const PostComment({
    required this.id,
    required this.text,
    this.parentCommentId,
    this.createdAt,
    this.user,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    final parentComment = json["parentCommentId"];
    return PostComment(
      id: (json["_id"] ?? json["id"] ?? "").toString(),
      text: (json["text"] ?? json["comment"] ?? "").toString(),
      parentCommentId:
          parentComment is Map
              ? (parentComment["_id"] ?? parentComment["id"])?.toString()
              : parentComment?.toString(),
      createdAt: json["createdAt"]?.toString(),
      user: CommentUser.fromPossibleJson(
        json["userId"] ?? json["user"] ?? json["author"],
      ),
    );
  }
}

class CommentUser {
  final String id;
  final String userName;
  final String name;
  final String profilePicture;

  const CommentUser({
    required this.id,
    required this.userName,
    required this.name,
    required this.profilePicture,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: (json["_id"] ?? json["id"] ?? "").toString(),
      userName: (json["userName"] ?? json["username"] ?? "").toString(),
      name: (json["name"] ?? "").toString(),
      profilePicture: (json["profilePicture"] ?? "").toString(),
    );
  }

  static CommentUser? fromPossibleJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return CommentUser.fromJson(json);
    }
    if (json is Map) {
      return CommentUser.fromJson(Map<String, dynamic>.from(json));
    }
    return null;
  }
}
