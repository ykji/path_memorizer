import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  // final TextStyle textStyle;
  // final Function onSaved;
  // final Function validator;
  final String labelText;
  // final Widget icon;
  final int borderRadius;

  CustomTextField(
      {this.controller,
      // this.textStyle,
      // this.onSaved,
      // this.validator,
      this.labelText,
      // this.icon,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(ScreenUtil().setWidth(borderRadius)),
        ),
      ),
    );
  }
}
