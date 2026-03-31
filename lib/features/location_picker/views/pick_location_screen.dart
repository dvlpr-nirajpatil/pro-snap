import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/location_picker/models/place.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4,
  );

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  Widget verticalSpace(double h) => SizedBox(height: h.h);

  final TextEditingController searchController = TextEditingController();
  final List<Place> searchResults = [];
  String currentAddress = 'India';
  CameraPosition? cameraPosition;

  void _moveToCurrentLocation() {}

  void _saveLocation() {
    Navigator.pop(context, currentAddress);
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
            onCameraIdle: () {},
            initialCameraPosition: PickLocationScreen.initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {},
          ),
          Positioned(
            right: 20,
            bottom: 150,
            child: IconButton.filled(
              onPressed: _moveToCurrentLocation,
              icon: const Icon(Icons.gps_fixed),
            ),
          ),
          Center(
            child: Icon(Icons.location_on, size: 42.sp, color: Colours.white),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
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
                        'Pick Location',
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
                                  hintText: 'Search location...',
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: const BoxDecoration(
                color: Colours.primary,
                border: Border(
                  top: BorderSide(color: Colours.divider, width: 0.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colours.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          currentAddress,
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 14.sp,
                            color: Colours.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(20),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _saveLocation,
                      child: Text(
                        'SAVE LOCATION',
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

  void _openSearchSheet(BuildContext context) {
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
                Container(
                  width: 45.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colours.divider,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Search Location',
                  style: TextStyle(
                    fontFamily: Fonts.semiBold,
                    fontSize: 16.sp,
                    color: Colours.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 20.h),
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
                            controller: searchController,
                            cursorColor: Colours.white,
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              fontSize: 14.sp,
                              color: Colours.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search city, area...',
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
                const Divider(color: Colours.divider),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: searchResults.length,
                    itemBuilder: (_, index) {
                      final Place place = searchResults[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            currentAddress = place.description ?? currentAddress;
                          });
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
                                      place.terms?.first.value ?? 'No',
                                      style: TextStyle(
                                        fontFamily: Fonts.medium,
                                        fontSize: 14.sp,
                                        color: Colours.white,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      place.description ?? '',
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
              ],
            );
          },
        );
      },
    );
  }
}
