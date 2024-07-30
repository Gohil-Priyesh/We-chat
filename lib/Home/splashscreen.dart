
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:we_chat_app/Home/auth/login.dart';
import 'package:we_chat_app/Home/home.dart';
import 'package:we_chat_app/api/apis.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds:  2),(){
      /// exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      /// for checking if the user is logged in then move to the home screen or else show the login screen.
      if(FirebaseAuth.instance.currentUser != null ){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
      }
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 25.h,
          width: 25.w,
          child: Image(image: AssetImage('assets/images/chat_bubble.png'),),
        ),
      ),
    );
  }
}
