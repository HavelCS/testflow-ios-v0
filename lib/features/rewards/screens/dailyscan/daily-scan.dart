import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mercle/constants/colors.dart';
import 'package:mercle/services/rewards-service.dart';
import 'package:mercle/widgets/daily_streak_widget.dart';

class DailyScan extends StatefulWidget {
  static const String routeName = '/daily-scan';
  const DailyScan({super.key});

  @override
  State<DailyScan> createState() => _DailyScanState();
}

class _DailyScanState extends State<DailyScan> {
  int _streak = 0;
  DateTime _nextScanAt = DateTime.now();
  bool todayScanned = false;
  bool _isLoading = true;
  Timer? _timer;
  String _timeRemaining = '00hr : 00m : 00s';

  @override
  void initState() {
    super.initState();
    _fetchDailyScans();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Important: Cancel timer to prevent memory leaks
    super.dispose();
  }

  Future<void> _fetchDailyScans() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call your API function
      Map<String, dynamic> result = await RewardsService().getDailyScans(
        context: context,
      );

      setState(() {
        _streak = result['streak'];
        _nextScanAt = result['nextScanAt'];
        todayScanned = result['todayScanned'];
        _isLoading = false;
      });

      // Start the countdown timer after getting the data
      _startTimer();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load daily scans: $error')),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeRemaining();
    });

    // Update immediately
    _updateTimeRemaining();
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    if (_nextScanAt.isAfter(now)) {
      final difference = _nextScanAt.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;

      setState(() {
        _timeRemaining =
            '${hours.toString().padLeft(2, '0')}hr : ${minutes.toString().padLeft(2, '0')}m : ${seconds.toString().padLeft(2, '0')}s';
      });
    } else {
      setState(() {
        _timeRemaining = 'Available now';
      });
      _timer?.cancel(); // Stop timer when time is up
    }
  }

  Future<void> _refreshDailyScans() async {
    _timer?.cancel(); // Cancel timer during refresh
    await _fetchDailyScans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: SvgPicture.asset(
              "assets/images/arrowback.svg",
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Daily Scans',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'HandjetRegular',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      body:
          _isLoading == false
              ? Column(
                children: [
                  SizedBox(height: 28.h),
                  Padding(
                    padding: EdgeInsets.only(left: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _streak.toString(),
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
                          'Scan Streak',
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
                        SizedBox(height: 13.h),
                        Text(
                          'Keep up your daily scans to build your streak and earn extra points for consistency.',
                          style: TextStyle(
                            color: const Color(0xFF6C6C6C),
                            fontSize: 14.sp,
                            fontFamily: 'GeistRegular',
                            fontWeight: FontWeight.w400,
                            height: 1.45.h,
                            letterSpacing: -0.14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 71.h),
                  Container(child: DailyStreakWidget()),
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.only(left: 24.w, right: 24.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            todayScanned == false
                                ? InkWell(
                                  onTap: () {
                                    //* Implement daily scan function
                                  },
                                  child: Container(
                                    height: 54.h,
                                    width: 161.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'Scan Now',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF040414),
                                        fontSize: 16.sp,
                                        fontFamily: 'GeistRegular',
                                        fontWeight: FontWeight.w400,
                                        height: 1.12.h,
                                      ),
                                    ),
                                  ),
                                )
                                : Container(
                                  height: 54.h,
                                  width: 161.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xff616161),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    'Scan Now',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF040414),
                                      fontSize: 16.sp,
                                      fontFamily: 'GeistRegular',
                                      fontWeight: FontWeight.w400,
                                      height: 1.12.h,
                                    ),
                                  ),
                                ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Next scan available in',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF6C6C6C),
                                    fontSize: 14.sp,
                                    fontFamily: 'GeistRegular',
                                    fontWeight: FontWeight.w400,
                                    height: 1.45.h,
                                    letterSpacing: -0.14,
                                  ),
                                ),
                                Text(
                                  _timeRemaining,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32.h,
                                    fontFamily: 'HandjetRegular',
                                    fontWeight: FontWeight.w300,
                                    height: 1.45.h,
                                    letterSpacing: -0.32.w,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 72.h),
                        SizedBox(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Beta Notice',
                                  style: TextStyle(
                                    color: const Color(0xFF6C6C6C),
                                    fontSize: 14.sp,
                                    fontFamily: 'GeistRegular',
                                    fontWeight: FontWeight.w600,
                                    height: 1.45.h,
                                    letterSpacing: -0.14,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '\nWhile we’re in beta, your scan data is temporarily stored to help train our models. Once mainnet launches, no raw data will ever be stored with us.\n\nBy scanning daily, you consent to this temporary storage. All beta data will be deleted before mainnet goes live.',
                                  style: TextStyle(
                                    color: const Color(0xFF6C6C6C),
                                    fontSize: 14.sp,
                                    fontFamily: 'GeistRegular',
                                    fontWeight: FontWeight.w400,
                                    height: 1.45.h,
                                    letterSpacing: -0.14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
