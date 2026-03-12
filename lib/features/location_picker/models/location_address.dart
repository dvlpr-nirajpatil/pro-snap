class LocationAddress {
  String? area;
  String? city;
  String? state;
  String? country;
  String? pincode;
  double? lat;
  double? lng;

  get formatAddresss => "$area, $city, $state, $country, $pincode";

  LocationAddress({
    this.area,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.lat,
    this.lng,
  });

  LocationAddress.fromJson(Map<String, dynamic> json) {
    if (json["area"] is String) {
      area = json["area"];
    }
    if (json["city"] is String) {
      city = json["city"];
    }
    if (json["state"] is String) {
      state = json["state"];
    }
    if (json["country"] is String) {
      country = json["country"];
    }
    if (json["pincode"] is String) {
      pincode = json["pincode"];
    }
  }

  static List<LocationAddress> fromList(List<Map<String, dynamic>> list) {
    return list.map(LocationAddress.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["area"] = area;
    _data["city"] = city;
    _data["state"] = state;
    _data["country"] = country;
    _data["pincode"] = pincode;
    _data["lat"] = lat;
    _data["lng"] = lng;
    return _data;
  }
}
