import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mercle/constants/colors.dart';
import 'package:mercle/features/rewards/screens/mkey-decor/mKeyDecor-model.dart';
import 'package:mercle/services/rewards-service.dart';

class MkeyDecor extends StatefulWidget {
  static const String routeName = "/mkey-decor";
  const MkeyDecor({super.key});

  @override
  State<MkeyDecor> createState() => _MkeyDecorState();
}

class _MkeyDecorState extends State<MkeyDecor> {
  List<MkeyDecorModel> _stickers = [];
  List<MkeyDecorModel> _charms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStickersCharms();
  }

  Future<void> _fetchStickersCharms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<MkeyDecorModel> stickers = await RewardsService().getUserStickers(
        context: context,
      );
      List<MkeyDecorModel> charms = await RewardsService().getUserCharms(
        context: context,
      );

      setState(() {
        _stickers = stickers;
        _charms = charms;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load stickers: $error')),
      );
    }
  }

  void showCustomBottomSheet(
    BuildContext context,
    String imageUrl,
    String name,
    String rarity,
    String obtainedOn,
    String itemType,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 732.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Container(
                height: 225.h,
                width: 219.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140.h,
                      width: 179.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(imageUrl)),
                      ),
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.39.sp,
                        fontFamily: 'GeistRegular',
                        fontWeight: FontWeight.w300,
                        height: 1.45.h,
                        letterSpacing: -0.17,
                      ),
                    ),
                    Text(
                      rarity,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.74.sp,
                        fontFamily: 'HandjetRegular',
                        fontWeight: FontWeight.w300,

                        letterSpacing: -0.22,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36.sp,
                  fontFamily: 'HandjetRegular',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                child: Column(
                  children: [
                    Divider(color: Color(0xff888888)),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Item Obtained',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontFamily: 'HandjetRegular',
                            fontWeight: FontWeight.w400,
                            height: 1.45.h,
                            letterSpacing: -0.20,
                          ),
                        ),
                        Text(
                          obtainedOn,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
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
                    Divider(color: Color(0xff888888)),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Item Type',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontFamily: 'HandjetRegular',
                            fontWeight: FontWeight.w400,
                            height: 1.45.h,
                            letterSpacing: -0.20,
                          ),
                        ),
                        Text(
                          itemType,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
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
                    Divider(color: Color(0xff888888)),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Item Rarity',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontFamily: 'HandjetRegular',
                            fontWeight: FontWeight.w400,
                            height: 1.45.h,
                            letterSpacing: -0.20,
                          ),
                        ),
                        Text(
                          rarity,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
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
                    Divider(color: Color(0xff888888)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
          'mKey Decor',
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
              ? _stickers.length > 0 && _charms.length > 0
                  ? Column(
                    children: [
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.only(left: 24.w, right: 24.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Stickers',
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
                      SizedBox(height: 12.h),
                      Container(
                        height: 201,

                        child: ListView.builder(
                          itemCount: _stickers.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showCustomBottomSheet(
                                  context,
                                  _stickers[index].imageUrl,
                                  _stickers[index].name,
                                  _stickers[index].rarity,
                                  "${_stickers[index].obtainedAt.day.toString().padLeft(2, '0')}-${_stickers[index].obtainedAt.month.toString().padLeft(2, '0')}-${_stickers[index].obtainedAt.year}",
                                  "Sticker",
                                );
                              },
                              child: Container(
                                height: 201.h,
                                width: 202.w,
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(color: Color(0xff888888)),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 111.h,
                                      width: 113.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            _stickers[index].imageUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _stickers[index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: 'GeistRegular',
                                        fontWeight: FontWeight.w300,
                                        height: 1.45.h,
                                        letterSpacing: -0.16,
                                      ),
                                    ),
                                    Text(
                                      _stickers[index].rarity,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: 'HandjetRegular',
                                        fontWeight: FontWeight.w300,
                                        height: 1.45.h,
                                        letterSpacing: -0.16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.only(left: 24.w, right: 24.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Charms',
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
                      SizedBox(height: 12.h),
                      Container(
                        height: 201,

                        child: ListView.builder(
                          itemCount: _charms.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showCustomBottomSheet(
                                  context,
                                  _charms[index].imageUrl,
                                  _charms[index].name,
                                  _charms[index].rarity,
                                  "${_charms[index].obtainedAt.day.toString().padLeft(2, '0')}-${_charms[index].obtainedAt.month.toString().padLeft(2, '0')}-${_charms[index].obtainedAt.year}",
                                  "Charm",
                                );
                              },
                              child: Container(
                                height: 201.h,
                                width: 202.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(color: Color(0xff888888)),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 111.h,
                                      width: 113.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            _charms[index].imageUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _charms[index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: 'GeistRegular',
                                        fontWeight: FontWeight.w300,
                                        height: 1.45.h,
                                        letterSpacing: -0.16,
                                      ),
                                    ),
                                    Text(
                                      _charms[index].rarity,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontFamily: 'HandjetRegular',
                                        fontWeight: FontWeight.w300,
                                        height: 1.45.h,
                                        letterSpacing: -0.16,
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
                  )
                  : Center(
                    child: Text(
                      'No stickers and charms found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: 'HandjetRegular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
              : Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
