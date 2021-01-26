import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathTracker/presentations/homepage.dart';
import 'package:pathTracker/presentations/sign_in_page.dart';
import 'package:pathTracker/utils/string_values.dart';
import 'package:pathTracker/utils/styles.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = "SplashPage";
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timerFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Styles.splash_bg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ScreenUtil().setHeight(160)),
              // app logo
              Icon(
                Icons.location_on_sharp,
                color: Colors.lightBlue[600],
                size: ScreenUtil().setHeight(100),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              // app name
              Text(
                StringValue.appTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(42),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              // splash text
              Text(
                StringValue.splashTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: ScreenUtil().setSp(28),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: ScreenUtil().setHeight(60)),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  timerFunction() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, SignIn.routeName);
    });
  }
}
