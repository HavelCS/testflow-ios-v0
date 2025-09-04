import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mercle/constants/utils.dart';
import 'package:mercle/models/daily_scan_model.dart';
import 'package:mercle/services/rewards-service.dart';

class DailyStreakWidget extends StatefulWidget {
  const DailyStreakWidget({super.key});

  @override
  State<DailyStreakWidget> createState() => _DailyStreakWidgetState();
}

class _DailyStreakWidgetState extends State<DailyStreakWidget> {
  List<DailyScanModel> scanData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDailyScanData();
  }

  void fetchDailyScanData() async {
    try {
      List<DailyScanModel> data = await RewardsService().getDailyScanLast5(
        context: context,
      );

      setState(() {
        scanData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Failed to load scan data');
      print('Error fetching daily scan data: $e');
    }
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return 'TODAY';
      }

      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr.split('-').skip(1).join('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 80.h,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.w,
          ),
        ),
      );
    }

    if (scanData.isEmpty) {
      return Container(
        height: 80.h,
        child: Center(
          child: Text(
            'No scan data available',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            scanData.asMap().entries.map((entry) {
              int index = entry.key;
              DailyScanModel scan = entry.value;
              bool isToday = formatDate(scan.date) == 'TODAY';

              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circle with connecting line
                    Row(
                      children: [
                        // Left line
                        if (index != 0)
                          Expanded(
                            child: Container(
                              height: 2.h,
                              color: Colors.grey[600],
                            ),
                          ),

                        // Circle
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                scan.scannedState
                                    ? Colors.white
                                    : Colors.transparent,
                            border: Border.all(
                              color: isToday ? Colors.white : Colors.grey[600]!,
                              width: isToday ? 3.w : 2.w,
                            ),
                          ),
                          child:
                              scan.scannedState
                                  ? Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 16.sp,
                                  )
                                  : null,
                        ),

                        // Right line
                        if (index != scanData.length - 1)
                          Expanded(
                            child: Container(
                              height: 2.h,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Date label
                    Text(
                      formatDate(scan.date),
                      style: TextStyle(
                        color: isToday ? Colors.white : Colors.grey[400],
                        fontSize: 10.sp,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
