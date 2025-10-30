import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? fgColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.bgColor,
    required this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        textStyle: TextStyle(fontSize: 15.sp),
      ),
      child: Text(label),
    );
  }
}
