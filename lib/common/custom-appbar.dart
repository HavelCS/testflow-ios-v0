import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mercle/services/rewards-service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_formatter/number_formatter.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  int _userPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadCachedPoints();
    _fetchUserPoints();
  }

  Future<void> _loadCachedPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedPoints = prefs.getInt('user_points');
    final lastFetch = prefs.getInt('last_points_fetch');
    final now = DateTime.now().millisecondsSinceEpoch;

    // Use cached data if it's less than 5 minutes old
    if (cachedPoints != null &&
        lastFetch != null &&
        (now - lastFetch) < 300000) {
      setState(() {
        _userPoints = cachedPoints;
      });
    } else {
      _fetchUserPoints();
    }
  }

  Future<void> _fetchUserPoints() async {
    int points = await RewardsService().getUserPoints(context: context);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('user_points', points);
    await prefs.setInt(
      'last_points_fetch',
      DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _userPoints = points;
    });
  }

  // Add refresh functionality
  Future<void> _refreshPoints() async {
    await _fetchUserPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 27.w, right: 27.w, top: 70.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 89.6,
            height: 16.h,
            child: SvgPicture.asset("assets/images/logo.svg"),
          ),
          Row(
            children: [
              Container(
                height: 26.h,
                width: 70.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x33909090),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 14.h,
                      width: 14.w,
                      child: SvgPicture.asset("assets/images/points.svg"),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      formatNumber(_userPoints),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'GeistRegular',
                        fontWeight: FontWeight.w400,
                        height: 1.45.h,
                        letterSpacing: 0.42,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                height: 36.h,
                width: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://plus.unsplash.com/premium_photo-1755612016361-ac40fcd724e3?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    ),

                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
