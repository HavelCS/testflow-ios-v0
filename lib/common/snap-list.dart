import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mercle/constants/colors.dart';

// Alternative version with actual images
class CustomListViewWithImages extends StatefulWidget {
  final List<String> imageUrls;

  const CustomListViewWithImages({Key? key, required this.imageUrls})
    : super(key: key);

  @override
  State<CustomListViewWithImages> createState() =>
      _CustomListViewWithImagesState();
}

class _CustomListViewWithImagesState extends State<CustomListViewWithImages> {
  late ScrollController _scrollController;
  double _currentOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _currentOffset = _scrollController.offset;
      });
    });
  }

  // Calculate if an item should be considered "center" based on scroll position
  bool _isCenter(int index) {
    double itemWidth = 120.w + 44.w; // width + margin
    double centerItemWidth = 208.w + 44.w; // center width + margin
    double screenCenter = MediaQuery.of(context).size.width / 2;

    // Calculate the position of this item
    double itemPosition = (index * itemWidth) - _currentOffset;
    double itemCenter = itemPosition + (itemWidth / 2);

    // Check if this item is closest to screen center
    double distanceFromCenter = (itemCenter - screenCenter).abs();

    // Find the closest item to center
    int closestIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < widget.imageUrls.length; i++) {
      double iPosition = (i * itemWidth) - _currentOffset;
      double iCenter = iPosition + (itemWidth / 2);
      double iDistance = (iCenter - screenCenter).abs();

      if (iDistance < minDistance) {
        minDistance = iDistance;
        closestIndex = i;
      }
    }

    return index == closestIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: Center(
        child: SizedBox(
          height: 246.h,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              bool isCenter = _isCenter(index);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                curve: Curves.easeInOut,
                width: isCenter ? 208.w : 120.w,
                height: isCenter ? 246.h : 54.h,
                margin: EdgeInsets.only(left: 0.w, right: 20),
                child: SvgPicture.asset("assets/images/points.svg"),
              );
            },
          ),
        ),
      ),
    );
  }
}
