import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:we_chat_app/Helper/dialogs.dart';
import 'package:we_chat_app/Home/auth/login.dart';
import 'package:we_chat_app/Models/users_model.dart';
import 'package:we_chat_app/api/apis.dart';
import 'package:we_chat_app/custom_widgets/Custom_TextStyle.dart';
import 'package:we_chat_app/custom_widgets/Custom_appBar.dart';
import 'package:we_chat_app/custom_widgets/Custom_txt.dart';
import 'package:we_chat_app/main.dart';

class Profilescreen extends StatefulWidget {
  final usersModel  user;
  const Profilescreen({super.key, required this.user});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      // by using this GestureDetector i can hide the keyboard when user tap anywhere on the screen
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
          // when i make resizeToAvoidBottomInset: property to true the bottomNavigation button cums up with the keyboard
          // when i set it to false it stays at its original position and gets overlapped by the keyboard
          resizeToAvoidBottomInset: false,
          floatingActionButton:FloatingActionButton.extended(
                backgroundColor: Colors.red.shade400,
                onPressed: ()async{

                  Dialogs.showProgressIndicator(context);
                  /// for making the user active status offline when he logsOut of application
                  await APIs.updateActiveStatus(false);

                  /// SignOut from application
                  await APIs.auth.signOut().then((value) async {
                    await GoogleSignIn().signOut().then((value){
                      /// for removing the progress dialog indicator from the stack
                      Navigator.pop(context);
                      /// now it will pop the home screen from the stack
                      Navigator.pop(context);
                      /// re initialising the Apis.auth  or else it will store the old data and we would not be able to login again in app
                      APIs.auth = FirebaseAuth.instance;

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
                    });
                  });

                },
                label:Text('Logout'),
                icon: Icon(Icons.logout_outlined),
          ),
          appBar: CustomAppbar(
            title: Text('Profile Screen'),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                     Padding(
                       padding: EdgeInsets.only(top: 10.sh),
                       child: Stack(
                         children: [
                           // i am using ternary operator hear
                           _image != null ?
                               // local image
                           ClipRRect(
                             borderRadius: BorderRadius.circular(22.sh),
                             child: Image.file(
                               File(_image!),
                               fit: BoxFit.cover,
                               height: 22.sh,
                               width: 46.sw,
                             ),
                           ) :
                               // else image from server
                           ClipRRect(
                             borderRadius: BorderRadius.circular(22.sh),
                             child: CachedNetworkImage(
                               fit: BoxFit.cover,
                               height: 22.sh,
                               width: 46.sw,
                               imageUrl: widget.user.image.toString(),
                               // placeholder: (context, url) => CircularProgressIndicator(),
                               errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person),),
                             ),
                           ),
                           Positioned(
                             bottom: 0,
                             right: 0,
                             child: MaterialButton(
                               elevation: 1,
                               shape: CircleBorder(),
                               color: Colors.white,
                               onPressed: (){
                                 _shoBottomSheet();
                               },
                               child: Icon(Icons.edit,color: Colors.blueAccent,),
                             ),
                           )
                         ]
                       ),
                     ),
                    SizedBox(
                      height: 2.sh,
                    ),
                    Text(widget.user.email.toString(),style: TextStyle(color: Colors.black54,fontSize: 20),),
                    SizedBox(
                      height: 2.sh,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 2.sw,right: 2.sw),
                      child: TextFormField(
                        // the initialValuse is use to provide the initial value to the text form field
                        initialValue: widget.user.name,
                        onSaved: (val) =>APIs.me.name=val ?? " ",
                        validator: (val)=> val != null && val.isNotEmpty ? null :'Required field',
                        decoration: InputDecoration(

                          // focusColor: Colors.lightBlueAccent,
                          focusColor: Colors.lightBlueAccent,
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          fillColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.person,),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: "UserName",
                          label: Text('Name'),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    Padding(
                      padding:  EdgeInsets.only(left: 2.sw,right: 2.sw),
                      child: TextFormField(
                        // the initialValuse is use to provide the initial value to the text form field
                        initialValue: widget.user.about,
                        onSaved: (val) =>APIs.me.about= val ?? " ",
                        validator: (val)=> val != null && val.isNotEmpty ? null :'Required field',
                        decoration: InputDecoration(
                          // focusColor: Colors.lightBlueAccent,
                          focusColor: Colors.lightBlueAccent,
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          fillColor: Colors.lightBlueAccent,
                          prefixIcon: Icon(Icons.info_outline,),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: "About",
                          label: Text('About'),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h,),

                    ElevatedButton.icon(
                      // for some reason this both method are not working
                      //style: ButtonStyle(minimumSize: WidgetStatePropertyAll(Size(10.sw,5.sh))),
                      // style:ElevatedButton.styleFrom(minimumSize: Size(15.sw, 5.sh)),
                      onPressed: (){
                        // the validator function is used for validating the user entry
                       // the _formKey.currentState!.save(); is used to save the change made by the user
                      //  APIs.updateUserInfo(); is used to update user info into our database

                        if(_formKey.currentState!.validate());
                        MyApp.logger.i('inside validator');
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value){
                          Dialogs.showSnackbar(context, 'Updated-Successfully');
                        });
                      },
                      icon: Icon(Icons.edit,),
                      label: Text('Update'),
                    ),
                    SizedBox(height: 3.sh,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _shoBottomSheet(){
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20))),
      context: context,
      builder: (context) {
      return ListView(
        shrinkWrap: true,
       children: [

         Padding(
           padding: EdgeInsets.only(top: 3.h,bottom: 2.h),
             child: const Text('Pick Profile Picture',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),textAlign:TextAlign.center,)),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             ElevatedButton(
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.white,
                 fixedSize: Size(33.sw, 16.sh)
               ),
                 onPressed: () async {
                   final ImagePicker picker = ImagePicker();
                   // pick an image
                   // imageQuality is use just to save some server space  it is not necessary
                   final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                   if(image != null){
                     MyApp.logger.i('image path: ${image.path} -- MimeType: ${image.mimeType}');
                     setState(() {
                       _image = image.path;
                     });
                     // for updating the profile picture in our database
                     APIs.updateProfilePicture(File(_image!));
                     // for removing the bottom sheet after picking the image
                     Navigator.pop(context);
                   }
                 }, child: Image.asset('assets/images/add_image.png')),
             SizedBox(width: 8.sw,),
             ElevatedButton(
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     fixedSize: Size(33.sw, 16.sh)
                 ), onPressed: ()async{
                   final ImagePicker picker = ImagePicker();
                   // pick an image
                   // imageQuality is use just to save some server space  it is not necessary
                   final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                   if(image != null){
                     MyApp.logger.i('image path: ${image.path}');
                     setState(() {
                       _image = image.path;
                     });
                     // for updating the profile picture in our database
                     APIs.updateProfilePicture(File(_image!));
                     // for removing the bottom sheet after picking the image
                     Navigator.pop(context);
                   }
             }, child: Image.asset('assets/images/camera.png')),
           ],
         ),
         SizedBox(height: 3.sh,)
       ],
      );
    },
    );
  }
}
