import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathTracker/presentations/customs/custom_raised_buttton.dart';
import 'package:pathTracker/presentations/customs/custom_text_field.dart';
import 'package:pathTracker/presentations/customs/otp_screen.dart';
import 'package:pathTracker/presentations/sign_in_page.dart';
import 'package:pathTracker/utils/string_values.dart';

class SignUp extends StatefulWidget {
  static const String routeName = "SignUp";
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _name;
  String _email;
  String _phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(StringValue.appTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFC4583D))),
        backgroundColor: Color(0xFFA1CDD2),
        iconTheme: IconThemeData(color: Color(0xFF305559)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30),
              vertical: ScreenUtil().setHeight(60)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // title signup
              Container(
                child: Text(
                  StringValue.signupWord,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[600],
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              // showing text field for name
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                child: CustomTextField(
                  labelText: StringValue.name,
                  borderRadius: 20,
                  // validator: (value) {
                  //   return null;
                  // },
                  // onSaved: (value) {
                  //   setState(() {
                  //     _name = value;
                  //   });
                  // },
                ),
              ),
              // showing text field for email
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                child: CustomTextField(
                  labelText: StringValue.email,
                  borderRadius: 20,
                  // validator: (value) {
                  //   return null;
                  // },
                  // onSaved: (value) {
                  //   setState(() {
                  //     _email = value;
                  //   });
                  // },
                ),
              ),
              // showing text field for phone
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                child: CustomTextField(
                  labelText: StringValue.phone,
                  borderRadius: 20,
                  // validator: (value) {
                  //   return null;
                  // },
                  // onSaved: (value) {
                  //   setState(() {
                  //     _phone = value;
                  //   });
                  // },
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              // raised button for [send otp]
              Container(
                child: CustomRaisedButton(
                  childText: StringValue.sendOTP,
                  onPressed: () {
                    Navigator.pushNamed(context, OtpScreen.routeName);
                  },
                  borderRadius: 30,
                  buttonColor: Colors.blueGrey[300],
                ),
              ),
              // already resgistered
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, SignIn.routeName);
                },
                child: Text(
                  StringValue.existingUser,
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
