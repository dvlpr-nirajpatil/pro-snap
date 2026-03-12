import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prosnap/core/services/location_service.dart';
import 'package:prosnap/features/create_post/controllers/create_post_controller.dart';
import 'package:prosnap/features/location_picker/models/location_address.dart';
import 'package:prosnap/features/location_picker/models/place.dart';
import 'package:prosnap/features/location_picker/repository/location_repository.dart';

class PickLocationController extends GetxController {
  final Completer<GoogleMapController> cameraController =
      Completer<GoogleMapController>();
  final LocationRepository repository = LocationRepository();

  RxString searchQuery = "".obs;
  final SearchController searchController = SearchController();

  RxList<Place> searchResults = <Place>[].obs;

  final LocationService locationService = Get.find<LocationService>();
  String? mapStyle;

  Position? position;

  Rx<LocationAddress> address = LocationAddress(country: "India").obs;

  @override
  onInit() {
    super.onInit();
    getCurrentPosition();
    _loadMapStyle();

    debounce(searchQuery, (value) {
      if (value.trim().isNotEmpty) {
        searchPlace();
      }
    }, time: Duration(milliseconds: 500));
  }

  Future<void> _loadMapStyle() async {
    mapStyle = await DefaultAssetBundle.of(
      Get.context!,
    ).loadString('assets/map_style_dark.json');

    final GoogleMapController controller = await cameraController.future;

    controller.setMapStyle(mapStyle);
  }

  getCurrentPosition() async {
    try {
      position = await locationService.getPosition();

      if (position != null) {
        address.value = await repository.getLocationAddress(
          lat: position!.latitude,
          lng: position!.longitude,
        );

        final GoogleMapController controller = await cameraController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position!.latitude, position!.longitude),
              zoom: 14.0,
            ),
          ),
        );
      }
    } catch (e) {}
  }

  updateAddress({lat, lng}) async {
    try {
      address.value = await repository.getLocationAddress(lat: lat, lng: lng);
    } catch (e) {}
  }

  moveToCurrentLocation() async {
    final GoogleMapController controller = await cameraController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position!.latitude, position!.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  selectAddress(placeId) async {
    try {
      final latLng = await repository.getLatLng(placeId);
      final GoogleMapController controller = await cameraController.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latLng['lat'], latLng['lng']),
            zoom: 16.0,
          ),
        ),
      );
    } catch (e) {}
  }

  searchPlace() async {
    try {
      searchResults.value = await repository.searchPlaces(searchQuery.value);
    } catch (e) {}
  }

  saveLocation() {
    address.value.lat = position?.latitude;
    address.value.lng = position?.longitude;
    Get.find<CreatePostController>().address.value = address.value;
  }
}
