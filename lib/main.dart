import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathTracker/presentations/sign_in_page.dart';
import 'package:pathTracker/presentations/sign_up_screen.dart';
import 'package:pathTracker/presentations/splash_page.dart';
import 'package:pathTracker/utils/string_values.dart';
import 'presentations/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  double defaultHeight = 812;
  double defaultWidth = 370;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(defaultWidth, defaultHeight),
      allowFontScaling: true,
      child: MaterialApp(
        title: StringValue.appTitle,
        //home: SplashPage(),
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.dark(),
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: SplashPage.routeName,
        routes: {
          SplashPage.routeName: (BuildContext context) => SplashPage(),
          HomePage.routeName: (BuildContext context) => HomePage(),
          SignIn.routeName: (BuildContext context) => SignIn(),
          SignUp.routeName: (BuildContext context) => SignUp(),
        },
      ),
    );
  }
}
