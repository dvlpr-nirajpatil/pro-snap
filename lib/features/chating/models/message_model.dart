class MessageModel {
  String? id;
  String? conversation;
  String? sender;
  String? text;
  dynamic image;
  String? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? v;

  MessageModel({
    this.id,
    this.conversation,
    this.sender,
    this.text,
    this.image,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    if (json["_id"] is String) {
      id = json["_id"];
    }
    if (json["conversation"] is String) {
      conversation = json["conversation"];
    }
    if (json["sender"] is String) {
      sender = json["sender"];
    } else if (json["sender"] is Map) {
      final senderData = json["sender"] as Map;
      final senderId = senderData["_id"] ?? senderData["id"];
      if (senderId != null) {
        sender = senderId.toString();
      }
    }
    if (json["text"] is String) {
      text = json["text"];
    }
    image = json["image"];
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["deleted"] is bool) {
      deleted = json["deleted"];
    }
    if (json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if (json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
    if (json["__v"] is int) {
      v = json["__v"];
    }
  }

  static List<MessageModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(MessageModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data["conversation"] = conversation;
    data["sender"] = sender;
    data["text"] = text;
    data["image"] = image;
    data["status"] = status;
    data["deleted"] = deleted;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    data["__v"] = v;
    return data;
  }
}
