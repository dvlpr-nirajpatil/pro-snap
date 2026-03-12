
class Place {
  String? description;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;

  Place({this.description, this.matchedSubstrings, this.placeId, this.reference, this.structuredFormatting, this.terms, this.types});

  Place.fromJson(Map<String, dynamic> json) {
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["matched_substrings"] is List) {
      matchedSubstrings = json["matched_substrings"] == null ? null : (json["matched_substrings"] as List).map((e) => MatchedSubstrings.fromJson(e)).toList();
    }
    if(json["place_id"] is String) {
      placeId = json["place_id"];
    }
    if(json["reference"] is String) {
      reference = json["reference"];
    }
    if(json["structured_formatting"] is Map) {
      structuredFormatting = json["structured_formatting"] == null ? null : StructuredFormatting.fromJson(json["structured_formatting"]);
    }
    if(json["terms"] is List) {
      terms = json["terms"] == null ? null : (json["terms"] as List).map((e) => Terms.fromJson(e)).toList();
    }
    if(json["types"] is List) {
      types = json["types"] == null ? null : List<String>.from(json["types"]);
    }
  }

  static List<Place> fromList(List<Map<String, dynamic>> list) {
    return list.map(Place.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["description"] = description;
    if(matchedSubstrings != null) {
      _data["matched_substrings"] = matchedSubstrings?.map((e) => e.toJson()).toList();
    }
    _data["place_id"] = placeId;
    _data["reference"] = reference;
    if(structuredFormatting != null) {
      _data["structured_formatting"] = structuredFormatting?.toJson();
    }
    if(terms != null) {
      _data["terms"] = terms?.map((e) => e.toJson()).toList();
    }
    if(types != null) {
      _data["types"] = types;
    }
    return _data;
  }
}

class Terms {
  int? offset;
  String? value;

  Terms({this.offset, this.value});

  Terms.fromJson(Map<String, dynamic> json) {
    if(json["offset"] is int) {
      offset = json["offset"];
    }
    if(json["value"] is String) {
      value = json["value"];
    }
  }

  static List<Terms> fromList(List<Map<String, dynamic>> list) {
    return list.map(Terms.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["offset"] = offset;
    _data["value"] = value;
    return _data;
  }
}

class StructuredFormatting {
  String? mainText;
  List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings;
  String? secondaryText;

  StructuredFormatting({this.mainText, this.mainTextMatchedSubstrings, this.secondaryText});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    if(json["main_text"] is String) {
      mainText = json["main_text"];
    }
    if(json["main_text_matched_substrings"] is List) {
      mainTextMatchedSubstrings = json["main_text_matched_substrings"] == null ? null : (json["main_text_matched_substrings"] as List).map((e) => MainTextMatchedSubstrings.fromJson(e)).toList();
    }
    if(json["secondary_text"] is String) {
      secondaryText = json["secondary_text"];
    }
  }

  static List<StructuredFormatting> fromList(List<Map<String, dynamic>> list) {
    return list.map(StructuredFormatting.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["main_text"] = mainText;
    if(mainTextMatchedSubstrings != null) {
      _data["main_text_matched_substrings"] = mainTextMatchedSubstrings?.map((e) => e.toJson()).toList();
    }
    _data["secondary_text"] = secondaryText;
    return _data;
  }
}

class MainTextMatchedSubstrings {
  int? length;
  int? offset;

  MainTextMatchedSubstrings({this.length, this.offset});

  MainTextMatchedSubstrings.fromJson(Map<String, dynamic> json) {
    if(json["length"] is int) {
      length = json["length"];
    }
    if(json["offset"] is int) {
      offset = json["offset"];
    }
  }

  static List<MainTextMatchedSubstrings> fromList(List<Map<String, dynamic>> list) {
    return list.map(MainTextMatchedSubstrings.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["length"] = length;
    _data["offset"] = offset;
    return _data;
  }
}

class MatchedSubstrings {
  int? length;
  int? offset;

  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    if(json["length"] is int) {
      length = json["length"];
    }
    if(json["offset"] is int) {
      offset = json["offset"];
    }
  }

  static List<MatchedSubstrings> fromList(List<Map<String, dynamic>> list) {
    return list.map(MatchedSubstrings.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["length"] = length;
    _data["offset"] = offset;
    return _data;
  }
}