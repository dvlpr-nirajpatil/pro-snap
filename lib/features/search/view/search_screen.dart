import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosnap/core/consts/colours.dart';
import 'package:prosnap/core/consts/fonts.dart';
import 'package:prosnap/features/profile_details/views/profile_details_screen.dart';
import 'package:prosnap/features/search/models/search_user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final List<SearchUser> searchResults = [];
  final List<String> exploreGrid = List.generate(18, (_) => '');
  bool isSearching = false;

  Widget verticalSpace(double h) => SizedBox(height: h.h);
  Widget horizontalSpace(double w) => SizedBox(width: w.w);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.primary,
      body: SafeArea(
        child: Column(
          children: [
            verticalSpace(15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colours.white, width: 0.6),
                ),
                child: TextField(
                  controller: searchController,
                  cursorColor: Colours.white,
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                    color: Colours.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isSearching = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search people, posts, #hashtags',
                    hintStyle: TextStyle(
                      fontFamily: Fonts.light,
                      color: Colours.grey,
                      fontSize: 13.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colours.white.withOpacity(0.8),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            verticalSpace(20),
            Expanded(
              child: isSearching ? _buildSearchResults() : _buildExploreGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreGrid() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
      ),
      itemCount: exploreGrid.length,
      itemBuilder: (context, index) {
        return Container(color: Colours.divider);
      },
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return Center(
        child: Text(
          'Search callbacks are now static.',
          style: TextStyle(
            fontFamily: Fonts.light,
            fontSize: 14.sp,
            color: Colours.white.withOpacity(0.7),
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        _sectionTitle('People'),
        verticalSpace(10),
        ...List.generate(
          searchResults.length,
          (index) => _buildUserResult(searchResults[index]),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: Fonts.semiBold,
        fontSize: 14.sp,
        color: Colours.white,
      ),
    );
  }

  Widget _buildUserResult(SearchUser user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileDetailsScreen(userId: user.id ?? ''),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: Colours.divider,
              child: user.profilePicture == null
                  ? Text(user.name?[0].toUpperCase() ?? 'U')
                  : CachedNetworkImage(
                      imageUrl: user.profilePicture,
                      fit: BoxFit.cover,
                    ),
            ),
            horizontalSpace(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName ?? 'No Username',
                  style: TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: 14.sp,
                    color: Colours.white,
                  ),
                ),
                Text(
                  user.name ?? 'No Name',
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 12.sp,
                    color: Colours.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
