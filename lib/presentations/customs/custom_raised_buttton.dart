import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRaisedButton extends StatelessWidget {
  final int borderRadius;
  final String childText;
  final VoidCallback onPressed;
  final Color textColor;
  final Color buttonColor;
  final int paddingVertical;
  final int paddingHorizontal;
  final int textSize;

  CustomRaisedButton({
    @required this.childText,
    @required this.onPressed,
    this.borderRadius = 20,
    this.textColor = Colors.white,
    this.buttonColor = Colors.black,
    this.paddingVertical = 10,
    this.paddingHorizontal = 20,
    this.textSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: buttonColor,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ScreenUtil().setWidth(borderRadius))),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(paddingVertical),
          horizontal: ScreenUtil().setWidth(paddingHorizontal)),
      child: Text(
        childText,
        style: TextStyle(
          color: textColor,
          fontSize: ScreenUtil().setSp(textSize),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
