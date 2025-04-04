import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomizeUIButton extends StatelessWidget {
  String text;
  double? height;
  double? width;
  CustomizeUIButton({super.key, required this.text,this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height ??  65.h,
      width: width ?? 289.w,
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(6.r)),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
