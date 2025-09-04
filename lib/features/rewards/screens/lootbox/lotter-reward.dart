import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mercle/constants/colors.dart';

class LotteryRewardScreen extends StatefulWidget {
  const LotteryRewardScreen({super.key});

  @override
  State<LotteryRewardScreen> createState() => _LotteryRewardScreenState();
}

class _LotteryRewardScreenState extends State<LotteryRewardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Icon(Icons.close, color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Divider(height: 1.h, color: Color(0xff888888)),
            SizedBox(height: 24.h),
            Text(
              'Good stuff, no cap!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontFamily: 'HandjetRegular',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24.h),
            Divider(height: 1.h, color: Color(0xff888888)),
            SizedBox(height: 35.h),
            Container(
              height: 254.h,
              width: 247.w,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage("")),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              child: Column(
                children: [
                  Divider(color: Colors.white),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: 'HandjetRegular',
                          fontWeight: FontWeight.w400,
                          height: 1.45.h,
                          letterSpacing: -0.20,
                        ),
                      ),
                      Text(
                        "Cosmos",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'GeistRegular',
                          fontWeight: FontWeight.w300,
                          height: 1.45.h,
                          letterSpacing: -0.16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: Colors.white),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item Obtained On',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: 'HandjetRegular',
                          fontWeight: FontWeight.w400,
                          height: 1.45.h,
                          letterSpacing: -0.20,
                        ),
                      ),
                      Text(
                        "12-12-25",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'GeistRegular',
                          fontWeight: FontWeight.w300,
                          height: 1.45.h,
                          letterSpacing: -0.16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: Colors.white),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: 'HandjetRegular',
                          fontWeight: FontWeight.w400,
                          height: 1.45.h,
                          letterSpacing: -0.20,
                        ),
                      ),
                      Text(
                        "Sticker",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'GeistRegular',
                          fontWeight: FontWeight.w300,
                          height: 1.45.h,
                          letterSpacing: -0.16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: Colors.white),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item Rarity',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: 'HandjetRegular',
                          fontWeight: FontWeight.w400,
                          height: 1.45.h,
                          letterSpacing: -0.20,
                        ),
                      ),
                      Text(
                        "Rare",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'GeistRegular',
                          fontWeight: FontWeight.w300,
                          height: 1.45.h,
                          letterSpacing: -0.16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: Colors.white),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
