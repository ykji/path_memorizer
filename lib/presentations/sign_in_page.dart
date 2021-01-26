import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathTracker/presentations/customs/custom_raised_buttton.dart';
import 'package:pathTracker/presentations/customs/custom_text_field.dart';
import 'package:pathTracker/presentations/customs/otp_screen.dart';
import 'package:pathTracker/presentations/sign_up_screen.dart';
import 'package:pathTracker/utils/string_values.dart';

class SignIn extends StatefulWidget {
  static const String routeName = "SignIn";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController phoneController=TextEditingController();
  String _phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(StringValue.appTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        // iconTheme: IconThemeData(color: Color(0xFF305559)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(80),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // title signin
              Container(
                child: Text(
                  StringValue.signinWord,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              // showing text field for phone
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                child: CustomTextField(
                  controller: phoneController,
                  labelText: StringValue.phone,
                  borderRadius: 20,
                  // validator: (value) {
                  //   if (value == "") print("Field cant be empty");
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
              CustomRaisedButton(
                childText: StringValue.sendOTP,
                onPressed: () {
                  if (phoneController.text != "") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            OtpScreen(phone: phoneController.text)));
                  } else {
                    print("cant be empty");
                  }
                },
                borderRadius: 30,
                buttonColor: Colors.blue[200],
              ),
              // already resgistered
              FlatButton(
                onPressed: () {
                  //Navigator.pushReplacementNamed(context, SignUp.routeName);
                },
                child: Text(
                  StringValue.newUser,
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
