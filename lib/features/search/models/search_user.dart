
class SearchUser {
  String? id;
  String? userName;
  String? email;
  dynamic profilePicture;
  bool? isVerified;
  String? name;

  SearchUser({this.id, this.userName, this.email, this.profilePicture, this.isVerified, this.name});

  SearchUser.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["userName"] is String) {
      userName = json["userName"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    profilePicture = json["profilePicture"];
    if(json["isVerified"] is bool) {
      isVerified = json["isVerified"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  static List<SearchUser> fromList(List<Map<String, dynamic>> list) {
    return list.map(SearchUser.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["userName"] = userName;
    _data["email"] = email;
    _data["profilePicture"] = profilePicture;
    _data["isVerified"] = isVerified;
    _data["name"] = name;
    return _data;
  }
}