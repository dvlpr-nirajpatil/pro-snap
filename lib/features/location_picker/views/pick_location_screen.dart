import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/location_picker/controllers/pick_location_controller.dart';
import 'package:prosnap/features/location_picker/models/location_address.dart';
import 'package:prosnap/features/location_picker/models/place.dart';

class PickLocationScreen extends StatefulWidget {
  PickLocationScreen({super.key});

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4,
  );

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  Widget verticalSpace(double h) => SizedBox(height: h.h);

  late final PickLocationController locationController;

  CameraPosition? cameraPosition;

  @override
  void initState() {
    super.initState();

    locationController = Get.put(PickLocationController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: Stack(
        children: [
          GoogleMap(
            onCameraMove: (position) {
              cameraPosition = position;
            },
            onCameraIdle: () {
              if (cameraPosition != null) {
                locationController.updateAddress(
                  lat: cameraPosition!.target.latitude,
                  lng: cameraPosition!.target.longitude,
                );
              }
            },
            style: locationController.mapStyle,
            initialCameraPosition: PickLocationScreen.initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              locationController.cameraController.complete(controller);
            },
          ),
          Positioned(
            right: 20,
            bottom: 150,
            child: IconButton.filled(
              onPressed: () {
                locationController.moveToCurrentLocation();
              },
              icon: Icon(Icons.gps_fixed),
            ),
          ),

          /// CENTER PIN
          Center(
            child: Icon(Icons.location_on, size: 42.sp, color: Colours.white),
          ),

          /// TOP BAR + SEARCH
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
                  /// Back Button Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colours.white,
                          size: 18.sp,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Pick Location",
                        style: TextStyle(
                          fontFamily: Fonts.semiBold,
                          fontSize: 16.sp,
                          letterSpacing: 1,
                          color: Colours.white,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: 18.w),
                    ],
                  ),

                  verticalSpace(20),

                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colours.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colours.white, width: 0.6),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colours.white.withOpacity(0.8),
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _openSearchSheet(context),
                            child: AbsorbPointer(
                              child: TextField(
                                cursorColor: Colours.white,
                                style: TextStyle(
                                  fontFamily: Fonts.medium,
                                  fontSize: 14.sp,
                                  color: Colours.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search location...",
                                  hintStyle: TextStyle(
                                    fontFamily: Fonts.light,
                                    color: Colours.grey,
                                    fontSize: 13.sp,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM LOCATION INFO + SAVE
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colours.primary,
                border: Border(
                  top: BorderSide(color: Colours.divider, width: 0.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Selected Location Name
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colours.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Obx(
                          () =>
                              locationController.address.value.city == null
                                  ? Text(
                                    "India",
                                    style: TextStyle(
                                      fontFamily: Fonts.medium,
                                      fontSize: 14.sp,
                                      color: Colours.white,
                                    ),
                                  )
                                  : Text(
                                    locationController
                                        .address
                                        .value
                                        .formatAddresss,
                                    style: TextStyle(
                                      fontFamily: Fonts.medium,
                                      fontSize: 14.sp,
                                      color: Colours.white,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),

                  verticalSpace(20),

                  /// Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        locationController.saveLocation();
                        Get.back();
                      },
                      child: Text(
                        "SAVE LOCATION",
                        style: TextStyle(
                          fontFamily: Fonts.semiBold,
                          fontSize: 14.sp,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _openSearchSheet(BuildContext context) {
  final locationController = Get.find<PickLocationController>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colours.primary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              SizedBox(height: 12.h),

              /// Drag Handle
              Container(
                width: 45.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colours.divider,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              SizedBox(height: 20.h),

              /// Title
              Text(
                "Search Location",
                style: TextStyle(
                  fontFamily: Fonts.semiBold,
                  fontSize: 16.sp,
                  color: Colours.white,
                  letterSpacing: 1,
                ),
              ),

              SizedBox(height: 20.h),

              /// Search Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colours.white, width: 0.6),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colours.white.withOpacity(0.8)),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            locationController.searchQuery.value = value;
                          },
                          controller: locationController.searchController,
                          cursorColor: Colours.white,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 14.sp,
                            color: Colours.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search city, area...",
                            hintStyle: TextStyle(
                              fontFamily: Fonts.light,
                              color: Colours.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Divider(color: Colours.divider),

              /// RESULTS LIST
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: locationController.searchResults.length,
                    itemBuilder: (_, index) {
                      final Place place =
                          locationController.searchResults[index];

                      return InkWell(
                        onTap: () async {
                          await locationController.selectAddress(place.placeId);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colours.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.terms?.first.value ?? "No",
                                      style: TextStyle(
                                        fontFamily: Fonts.medium,
                                        fontSize: 14.sp,
                                        color: Colours.white,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      place.description ?? "",
                                      style: TextStyle(
                                        fontFamily: Fonts.light,
                                        fontSize: 12.sp,
                                        color: Colours.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
