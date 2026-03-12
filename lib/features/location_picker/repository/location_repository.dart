import 'package:dio/dio.dart';
import 'package:prosnap/core/network/error_interceptor.dart';
import 'package:prosnap/core/network/logger_intercepter.dart';
import 'package:prosnap/features/location_picker/models/location_address.dart';
import 'package:prosnap/features/location_picker/models/place.dart';

class LocationRepository {
  late final Dio dio;
  final String apiKey = "AIzaSyDdd65dYKO4IjI_t7YWlokc9JGDIRwxbUU";

  LocationRepository() {
    dio = Dio();
    dio.interceptors.addAll([LoggerInterceptor(), ErrorInterceptor(Dio())]);
  }

  Future<LocationAddress> getLocationAddress({
    required double lat,
    required double lng,
  }) async {
    try {
      final Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/geocode/json",
        queryParameters: {"latlng": "$lat,$lng", "key": apiKey},
      );

      final data = response.data;

      if (data["status"] != "OK") {
        throw Exception("Failed to fetch address");
      }

      final components = data["results"][0]["address_components"] as List;

      String? area;
      String? city;
      String? state;
      String? country;
      String? pincode;

      for (var component in components) {
        final types = component["types"] as List;

        if (types.contains("sublocality") || types.contains("neighborhood")) {
          area = component["long_name"];
        }

        if (types.contains("locality")) {
          city = component["long_name"];
        }

        if (types.contains("administrative_area_level_1")) {
          state = component["long_name"];
        }

        if (types.contains("country")) {
          country = component["long_name"];
        }

        if (types.contains("postal_code")) {
          pincode = component["long_name"];
        }
      }

      return LocationAddress.fromJson({
        "area": area,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
      });
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  searchPlaces(query) async {
    try {
      final Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey",
      );
      final List places = response.data['predictions'];

      return places.map((e) => Place.fromJson(e)).toList();
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }

  getLatLng(placeId) async {
    try {
      final Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey",
      );
      return response.data['result']['geometry']['location'];
    } on DioException catch (e) {
      throw e.error as Exception;
    }
  }
}
