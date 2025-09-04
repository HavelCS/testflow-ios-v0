import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mercle/common/custom-appbar.dart';
import 'package:mercle/constants/colors.dart';
import 'package:mercle/constants/utils.dart';
import 'package:mercle/features/rewards/screens/dailyscan/daily-scan.dart';
import 'package:mercle/providers/user_provider.dart';
import 'package:mercle/services/rewards-service.dart';
import 'package:mercle/widgets/daily_streak_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_formatter/number_formatter.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(),
            SizedBox(height: 19.h),
            Divider(height: 1.h, color: Color(0xff888888)),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.only(left: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatNumber(_userPoints),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 100.sp,
                          fontFamily: 'HandjetRegular',
                          fontWeight: FontWeight.w500,
                          height: 0.77,
                          letterSpacing: -1,
                        ),
                      ),
                      SvgPicture.asset("assets/images/points.svg"),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Points Collected',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF6C6C6C),
                      fontSize: 16.sp,
                      fontFamily: 'GeistRegular',
                      fontWeight: FontWeight.w400,
                      height: 1.45.h,
                      letterSpacing: -0.16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 146.h),
            Divider(height: 1.h, color: Color(0xff888888)),
            SizedBox(height: 29.h),
            // Daily Scans
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, DailyScan.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Scans',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: 'HandjetRegular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SvgPicture.asset("assets/images/arrowlong.svg"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 29.h),
            //tracker
            Container(child: DailyStreakWidget()),
            SizedBox(height: 29.h),
            Divider(height: 1.h, color: Color(0xff888888)),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/loot-boxes");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lootboxes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: 'HandjetRegular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SvgPicture.asset("assets/images/arrowlong.svg"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Divider(height: 1.h, color: Color(0xff888888)),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/mkey-decor");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'mKey Decor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: 'HandjetRegular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SvgPicture.asset("assets/images/arrowlong.svg"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Divider(height: 1.h, color: Color(0xff888888)),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/points-history");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Points History',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: 'HandjetRegular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SvgPicture.asset("assets/images/arrowlong.svg"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Divider(height: 1.h, color: Color(0xff888888)),
          ],
        ),
      ),
    );
  }
}
