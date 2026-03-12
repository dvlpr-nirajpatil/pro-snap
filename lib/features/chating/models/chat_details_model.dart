
class ChatDetailsModel {
  String? conversationId;
  Opponent? opponent;
  LastMessage? lastMessage;
  String? createdAt;
  String? updatedAt;

  ChatDetailsModel({this.conversationId, this.opponent, this.lastMessage, this.createdAt, this.updatedAt});

  ChatDetailsModel.fromJson(Map<String, dynamic> json) {
    if(json["conversationId"] is String) {
      conversationId = json["conversationId"];
    }
    if(json["opponent"] is Map) {
      opponent = json["opponent"] == null ? null : Opponent.fromJson(json["opponent"]);
    }
    if(json["lastMessage"] is Map) {
      lastMessage = json["lastMessage"] == null ? null : LastMessage.fromJson(json["lastMessage"]);
    }
    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if(json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
  }

  static List<ChatDetailsModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ChatDetailsModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["conversationId"] = conversationId;
    if(opponent != null) {
      _data["opponent"] = opponent?.toJson();
    }
    if(lastMessage != null) {
      _data["lastMessage"] = lastMessage?.toJson();
    }
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class LastMessage {
  String? text;
  dynamic image;
  String? createdAt;

  LastMessage({this.text, this.image, this.createdAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    if(json["text"] is String) {
      text = json["text"];
    }
    image = json["image"];
    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
  }

  static List<LastMessage> fromList(List<Map<String, dynamic>> list) {
    return list.map(LastMessage.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["text"] = text;
    _data["image"] = image;
    _data["createdAt"] = createdAt;
    return _data;
  }
}

class Opponent {
  String? id;
  String? userName;
  String? name;
  dynamic profilePicture;
  bool? isVerified;

  Opponent({this.id, this.userName, this.name, this.profilePicture, this.isVerified});

  Opponent.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["userName"] is String) {
      userName = json["userName"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    profilePicture = json["profilePicture"];
    if(json["isVerified"] is bool) {
      isVerified = json["isVerified"];
    }
  }

  static List<Opponent> fromList(List<Map<String, dynamic>> list) {
    return list.map(Opponent.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["userName"] = userName;
    _data["name"] = name;
    _data["profilePicture"] = profilePicture;
    _data["isVerified"] = isVerified;
    return _data;
  }
}