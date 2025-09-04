import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mercle/constants/colors.dart';
import 'package:mercle/features/rewards/screens/points-history/point-historymodel.dart';
import 'package:mercle/services/rewards-service.dart';
import 'package:intl/intl.dart';
import 'package:number_formatter/number_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointsHistoryScreen extends StatefulWidget {
  static const String routeName = "/points-history";
  const PointsHistoryScreen({super.key});

  @override
  State<PointsHistoryScreen> createState() => _PointsHistoryScreenState();
}

class _PointsHistoryScreenState extends State<PointsHistoryScreen> {
  int _userPoints = 0;
  @override
  void initState() {
    super.initState();
    _loadCachedPoints();
    _fetchPointHistory();
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

  List<PointHistoryModel> _pointHistory = [];
  bool _isLoading = true;

  Future<void> _fetchPointHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<PointHistoryModel> history = await RewardsService()
          .getUserPointHistory(context: context, limit: 20);

      setState(() {
        _pointHistory = history;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load point history: $error')),
      );
    }
  }

  Future<void> _refreshPointHistory() async {
    await _fetchPointHistory();
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

  // Helper method to format datetime
  String _formatDate(String datetime) {
    try {
      DateTime dateTime = DateTime.parse(datetime);
      final DateFormat formatter = DateFormat('h:mm a d MMMM yyyy');
      return formatter.format(dateTime);
    } catch (e) {
      return datetime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
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

        centerTitle: false,
        title: Text(
          'Points History',
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
              ? SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 28.h),
                    Divider(height: 1.h, color: Color(0xff888888)),
                    SizedBox(height: 48.h),
                    Padding(
                      padding: EdgeInsets.only(left: 24.w, right: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 28.h,
                                width: 28.h,
                                child: SvgPicture.asset(
                                  "assets/images/points.svg",
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '${formatNumber(_userPoints)} Points',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontFamily: 'HandjetRegular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'All Points',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontFamily: 'HandjetRegular',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48.h),
                    Divider(height: 1.h, color: Color(0xff888888)),
                    SizedBox(height: 20.h),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _pointHistory.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Column(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 24.w,
                                      right: 24.w,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _pointHistory[index].event,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontFamily: 'GeistRegular',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              _formatDate(
                                                _pointHistory[index].datetime,
                                              ),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xFF6C6C6C),
                                                fontSize: 16.sp,
                                                fontFamily: 'GeistRegular',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "+${_pointHistory[index].points.toString()}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 34.sp,
                                            fontFamily: 'HandjetRegular',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Divider(height: 1.h, color: Color(0xff888888)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
              : Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
