
class ProfileDetails {
  String? id;
  String? userName;
  String? name;
  String? email;
  String? bio;
  dynamic profilePicture;
  bool? isVerified;
  String? accountType;
  Counts? counts;
  List<Posts>? posts;

  ProfileDetails({this.id, this.userName, this.name, this.email, this.bio, this.profilePicture, this.isVerified, this.accountType, this.counts, this.posts});

  ProfileDetails.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["userName"] is String) {
      userName = json["userName"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["bio"] is String) {
      bio = json["bio"];
    }
    profilePicture = json["profilePicture"];
    if(json["isVerified"] is bool) {
      isVerified = json["isVerified"];
    }
    if(json["accountType"] is String) {
      accountType = json["accountType"];
    }
    if(json["counts"] is Map) {
      counts = json["counts"] == null ? null : Counts.fromJson(json["counts"]);
    }
    if(json["posts"] is List) {
      posts = json["posts"] == null ? null : (json["posts"] as List).map((e) => Posts.fromJson(e)).toList();
    }
  }

  static List<ProfileDetails> fromList(List<Map<String, dynamic>> list) {
    return list.map(ProfileDetails.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["userName"] = userName;
    _data["name"] = name;
    _data["email"] = email;
    _data["bio"] = bio;
    _data["profilePicture"] = profilePicture;
    _data["isVerified"] = isVerified;
    _data["accountType"] = accountType;
    if(counts != null) {
      _data["counts"] = counts?.toJson();
    }
    if(posts != null) {
      _data["posts"] = posts?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Posts {
  String? id;
  String? caption;
  List<Media>? media;
  dynamic location;
  int? likesCount;
  int? commentsCount;
  String? createdAt;

  Posts({this.id, this.caption, this.media, this.location, this.likesCount, this.commentsCount, this.createdAt});

  Posts.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["caption"] is String) {
      caption = json["caption"];
    }
    if(json["media"] is List) {
      media = json["media"] == null ? null : (json["media"] as List).map((e) => Media.fromJson(e)).toList();
    }
    location = json["location"];
    if(json["likesCount"] is int) {
      likesCount = json["likesCount"];
    }
    if(json["commentsCount"] is int) {
      commentsCount = json["commentsCount"];
    }
    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
  }

  static List<Posts> fromList(List<Map<String, dynamic>> list) {
    return list.map(Posts.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["caption"] = caption;
    if(media != null) {
      _data["media"] = media?.map((e) => e.toJson()).toList();
    }
    _data["location"] = location;
    _data["likesCount"] = likesCount;
    _data["commentsCount"] = commentsCount;
    _data["createdAt"] = createdAt;
    return _data;
  }
}

class Media {
  String? url;
  String? type;
  String? id;

  Media({this.url, this.type, this.id});

  Media.fromJson(Map<String, dynamic> json) {
    if(json["url"] is String) {
      url = json["url"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["_id"] is String) {
      id = json["_id"];
    }
  }

  static List<Media> fromList(List<Map<String, dynamic>> list) {
    return list.map(Media.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["url"] = url;
    _data["type"] = type;
    _data["_id"] = id;
    return _data;
  }
}

class Counts {
  int? posts;
  int? followers;
  int? following;

  Counts({this.posts, this.followers, this.following});

  Counts.fromJson(Map<String, dynamic> json) {
    if(json["posts"] is int) {
      posts = json["posts"];
    }
    if(json["followers"] is int) {
      followers = json["followers"];
    }
    if(json["following"] is int) {
      following = json["following"];
    }
  }

  static List<Counts> fromList(List<Map<String, dynamic>> list) {
    return list.map(Counts.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["posts"] = posts;
    _data["followers"] = followers;
    _data["following"] = following;
    return _data;
  }
}