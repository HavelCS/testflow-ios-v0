import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:mercle/common/snap-list.dart';
import 'package:mercle/constants/colors.dart';
import 'package:mercle/constants/utils.dart';
import 'package:mercle/features/rewards/screens/lootbox/bytypemodel.dart';
import 'package:mercle/services/rewards-service.dart';

class LootBoxes extends StatefulWidget {
  static const String routeName = '/loot-boxes';
  const LootBoxes({super.key});

  @override
  State<LootBoxes> createState() => _LootBoxesState();
}

class _LootBoxesState extends State<LootBoxes> {
  @override
  void initState() {
    super.initState();
    fetchLootBoxData();
  }

  int _index = 0;
  int mars = 0;
  int saturn = 0;
  int jupiter = 0;
  List<String> types = [];
  bool _isLoading = true;

  int getCountForType(String type) {
    switch (type) {
      case 'Mars':
        return mars;
      case 'Saturn':
        return saturn;
      case 'Jupiter':
        return jupiter;
      default:
        return 0;
    }
  }

  void fetchLootBoxData() async {
    try {
      ByTypeModel? byTypeData = await RewardsService().getByTypeData(
        context: context,
      );

      setState(() {
        if (byTypeData != null) {
          mars = byTypeData.mars;
          saturn = byTypeData.saturn;
          jupiter = byTypeData.jupiter;

          // Clear types list first
          types.clear();

          if (mars > 0) {
            types.add("Mars");
          }
          if (saturn > 0) {
            types.add("Saturn");
          }
          if (jupiter > 0) {
            types.add("Jupiter");
          }

          print(
            'Loaded lootbox counts - Mars: $mars, Saturn: $saturn, Jupiter: $jupiter',
          );
        } else {
          // Handle null case - set all to zero
          mars = 0;
          saturn = 0;
          jupiter = 0;
          types.clear();
          print('No lootbox data received');
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Failed to load lootbox data: ${e.toString()}');
      print('Error fetching loot box data: $e');
    }
  }

  void showCustomBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: 400.h, maxHeight: 732.h),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                SizedBox(
                  width: 280.w,
                  child: Text(
                    'What’s inside the lootbox?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 44.sp,
                      fontFamily: 'HandjetRegular',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Decrypting possible rewards',
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
                SizedBox(height: 28.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 24.w, right: 24.w),
                    child: GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.6,
                        crossAxisSpacing: 12.w,

                        mainAxisSpacing: 12.h,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 102.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1.w,
                              color: Color(0xff888888),
                            ),
                          ),

                          child: Row(
                            children: [
                              Container(width: 66.w, color: Colors.black),
                              SizedBox(width: 10.w),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 12.h,
                                  bottom: 12.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/tag.svg",
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          'Cosmos',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontFamily: 'Handjet',
                                            fontWeight: FontWeight.w400,
                                            height: 1.45.h,
                                            letterSpacing: -0.14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/sticker.svg",
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          'Sticker',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontFamily: 'Handjet',
                                            fontWeight: FontWeight.w400,
                                            height: 1.45.h,
                                            letterSpacing: -0.14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/rarity.svg",
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          'Ultra Rare',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontFamily: 'Handjet',
                                            fontWeight: FontWeight.w400,
                                            height: 1.45.h,
                                            letterSpacing: -0.14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
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
          'Lootboxes',
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
              ? types.length > 0
                  ? SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 71.h),
                          Text(
                            'Lootbox collection',
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
                          SizedBox(height: 8.h),
                          Text(
                            types.isNotEmpty ? types[_index] : 'No boxes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 100.sp,
                              fontFamily: 'HandjetRegular',
                              fontWeight: FontWeight.w500,
                              height: 0.77.h,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: 28.h),
                          Text(
                            types.isNotEmpty
                                ? '${getCountForType(types[_index])} x (available)'
                                : '0 x (available)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontFamily: 'HandjetRegular',
                              fontWeight: FontWeight.w300,
                              height: 1.h,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'TAP THE BOX TO OPEN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0x996C6C6C),
                              fontSize: 12.sp,
                              fontFamily: 'GeistRegular',
                              fontWeight: FontWeight.w400,
                              height: 1.45.h,
                              letterSpacing: 0.12,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          InkWell(
                            onTap: () {
                              showCustomBottomSheet();
                            },
                            child: Container(
                              height: 53.h,
                              width: 246.w,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.r),
                                color: Color(0xff454545).withOpacity(0.40),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info, color: Colors.white),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'What’s inside the box?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontFamily: 'HandjetRegular',
                                      fontWeight: FontWeight.w400,
                                      height: 1.45.h,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Container(
                            height: 246.h,
                            child: PageView.builder(
                              itemCount: types.length,
                              onPageChanged: (int index) {
                                setState(() {
                                  _index = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // Handle tap event
                                    },
                                    child: Container(
                                      height: 246.h,
                                      width: 250.w,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          types[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.sp,
                                            fontFamily: 'HandjetRegular',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : Center(child: Text("No lootboxes found"))
              : Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
