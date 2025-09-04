import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mercle/constants/colors.dart';
import 'package:mercle/features/rewards/screens/lootbox/lottery.dart';

class OpenLootBox extends StatefulWidget {
  const OpenLootBox({super.key});

  @override
  State<OpenLootBox> createState() => _OpenLootBoxState();
}

class _OpenLootBoxState extends State<OpenLootBox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              'Opening Lootbox',
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
              height: 129.h,
              width: 109.w,
              child: SvgPicture.asset("assets/images/lootbox1.svg"),
            ),
            SvgPicture.asset("assets/images/radial2.svg"),
            SizedBox(height: 25.h),
            Text(
              'Decrypting...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontFamily: 'HandjetRegular',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
            Container(),
            SizedBox(height: 34.h),
            Text(
              'Let’s see what your presence pulls in',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFB9B9B9),
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
    );
  }
}
