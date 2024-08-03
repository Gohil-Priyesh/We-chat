// import 'dart:math';
import 'dart:ui';
// this dart:developer import is used to show log() if this is not imported then the math.dart log will be used ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:we_chat_app/Helper/dialogs.dart';
import 'package:we_chat_app/Home/home.dart';
import 'package:we_chat_app/api/apis.dart';
import 'package:we_chat_app/utils/imageString.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>
    with TickerProviderStateMixin {
  final logger = Logger();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller.forward() is used in the initState method to start the animation once when the widget is initialized.
    _controller.forward();
  }
  // Initialise animation controller
  late Animation animation;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  ));

  _handelGooglebtn(){
    // to only show the progress Indicator when the handelGooglebtn() is triggered and then removing it from the navigation stack
    Dialogs.showProgressIndicator(context);


    _signInWithGoogle().then((user) async {
      // i am using the pop after the google sign is executed
      Navigator.pop(context);

      if(user != null){
        logger.i('\nuser:${user?.user}'); // i don't know why it is showing error when i am try to show it as string
        logger.i('\nuserAdditionalInfo:${user.additionalUserInfo}');

        if((await APIs.userExists())){

          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home()));
        }else{
          // Make sure to correctly place the bracket when using .then((value){});
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home()));
          });
        }
      }
    });
  }
    Future<UserCredential?> _signInWithGoogle() async {
     try{
         //await InternetAddress.lookup('google.com');
       // Trigger the authentication flow
       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

       // Obtain the auth details from the request
       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

       // Create a new credential
       final credential = GoogleAuthProvider.credential(
         accessToken: googleAuth?.accessToken,
         idToken: googleAuth?.idToken,
       );

       // Once signed in, return the UserCredential
       // the APIs.auth is used for FirebaseAuth.Instance which is located in api folder apis file APIs class
       return await APIs.auth.signInWithCredential(credential);
     }catch(e){
       logger.e('\n_signInWithGoogle(): $e');
       // the Dialogs is a different class then default Dialog
       Dialogs.showSnackbar(context,'something went wrong check(Internet!)');
     }
     return null;

    }


  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5.sh,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _offsetAnimation,
                child: Container(alignment: Alignment.center,
                    width: 70.sw,
                    height: 50.sh,
                    child: Image(
                      image: AssetImage(bubbleimg),
                    )),
              )
              // message icon
             ,
              SizedBox(height: 10.sh),
            ],
          ),
          const Spacer(flex: 1,),
          Container(
            height: 6.h,
            width: 90.w,
            // google image button
            child: ElevatedButton.icon(
              icon: Image.asset(height:3.h,googleimg),
              iconAlignment: IconAlignment.start,
              style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 219, 255, 178))
            ),
              onPressed: () {
                _handelGooglebtn();

              },
              label: RichText(
                text: TextSpan(children: [
                  const TextSpan(text: 'Sign in ', style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w400)),
                  const TextSpan(text: 'with ',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w400)),
                  TextSpan(text: 'Google', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.black))
                ]
                ),
              ),
            ),
          ),
          // this sizedBox is use as padding from the bottom of the screen
          SizedBox(height: 20.sh,)
        ],
      ),
    ));
  }
}

