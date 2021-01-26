import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pathTracker/presentations/homepage.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:pathTracker/utils/string_values.dart';

class OtpScreen extends StatefulWidget {
  static const String routeName = "OtpScreen";
  final String phone;
  OtpScreen({this.phone});
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _verificationCode;
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(StringValue.appTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // color: Color(0xFFC4583D),
            )),
        // backgroundColor: Color(0xFFA1CDD2),
        iconTheme: IconThemeData(
          color: Color(0xFF305559),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(30),
              horizontal: ScreenUtil().setWidth(20)),
          child: Column(
            children: [
              // otp title
              Container(
                child: Text(
                  StringValue.otpVerify,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Divider(thickness: ScreenUtil().setHeight(1)),
              SizedBox(height: ScreenUtil().setHeight(25)),
              // text enter code
              Container(
                child: RichText(
                  text: TextSpan(
                    text: StringValue.enterCode,
                    children: [
                      TextSpan(
                        text: "+91${widget.phone}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ],
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(14)),
              // otp entry field
              Container(
                child: PinEntryTextField(
                  fontSize: ScreenUtil().setSp(22),
                  fields: 6,
                  showFieldAsBox: true,
                  onSubmit: (String pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                        if (value.user != null) {
                          Navigator.pushReplacementNamed(
                              context, HomePage.routeName);
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      _scaffoldkey.currentState.showSnackBar(
                        SnackBar(content: Text("Invalid OTP")),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(25)),
              // resend button
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringValue.noCode,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil().setSp(15)),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(5)),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        StringValue.resendWord,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loginUser() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("verification compl");
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            print("user logged in");
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verification failed");
        print(e.message);
      },
      codeSent: (String verificationID, int resendToken) {
        print(" codesent");
        setState(() {
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        print("codeAutoRetrievalTimeout");
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: Duration(seconds: 30),
    );
  }
}
