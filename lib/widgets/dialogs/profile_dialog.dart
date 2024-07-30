


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:we_chat_app/Home/view_profileScreen.dart';
import 'package:we_chat_app/Models/users_model.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final usersModel user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:EdgeInsets.zero ,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.h)),
      content: SizedBox(
        width: 60.w,
        height: 35.h,
        child: Stack(
          children: [
            /// user profile picture
            Positioned(
              top: 6.h,left: 10.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.h),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 23.h,
                  width: 49.w,
                  imageUrl: user.image.toString(),
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            /// user name
            Positioned(top: 1.h,left: 3.w, width: 55.w,
                child: Text(user.name.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize:18.sp),)),
            /// info button
            Positioned(right: 1.w,
                child: IconButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewProfileScreen(user: user),));
                }, icon: Icon(CupertinoIcons.info_circle,size: 21.sp,)))
          ],
        ),
      ),
    );
  }
}
