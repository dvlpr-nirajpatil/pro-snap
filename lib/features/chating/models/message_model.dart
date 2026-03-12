
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

  MessageModel({this.id, this.conversation, this.sender, this.text, this.image, this.status, this.deleted, this.createdAt, this.updatedAt, this.v});

  MessageModel.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["conversation"] is String) {
      conversation = json["conversation"];
    }
    if(json["sender"] is String) {
      sender = json["sender"];
    }
    if(json["text"] is String) {
      text = json["text"];
    }
    image = json["image"];
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["deleted"] is bool) {
      deleted = json["deleted"];
    }
    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if(json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
    if(json["__v"] is int) {
      v = json["__v"];
    }
  }

  static List<MessageModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(MessageModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["conversation"] = conversation;
    _data["sender"] = sender;
    _data["text"] = text;
    _data["image"] = image;
    _data["status"] = status;
    _data["deleted"] = deleted;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["__v"] = v;
    return _data;
  }
}