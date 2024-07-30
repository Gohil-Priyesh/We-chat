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
import 'package:we_chat_app/Helper/my_date_util.dart';
import 'package:we_chat_app/Home/auth/login.dart';
import 'package:we_chat_app/Models/users_model.dart';
import 'package:we_chat_app/api/apis.dart';
import 'package:we_chat_app/custom_widgets/Custom_TextStyle.dart';
import 'package:we_chat_app/custom_widgets/Custom_appBar.dart';
import 'package:we_chat_app/custom_widgets/Custom_txt.dart';
import 'package:we_chat_app/main.dart';

/// ViewProfileScreen for to view profile of user
class ViewProfileScreen extends StatefulWidget {
  final usersModel user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      // by using this GestureDetector i can hide the keyboard when user tap anywhere on the screen
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // when i make resizeToAvoidBottomInset: property to true the bottomNavigation button cums up with the keyboard
          // when i set it to false it stays at its original position and gets overlapped by the keyboard
          resizeToAvoidBottomInset: false,
          appBar: CustomAppbar(
            title: Text(widget.user.name.toString()),
          ),

          /// for showing Joined date
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Joined on: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5.sh,
              ),
              Text(
                MyDateUtil.getLastMessageTime(
                    context: context,
                    time: widget.user.createdAt.toString(),
                    showYear: true),
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(2.w),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.sh,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22.sh),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 22.sh,
                          width: 46.sw,
                          imageUrl: widget.user.image.toString(),
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.sh,
                    ),
                    Text(
                      widget.user.email.toString(),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'About: ',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.sh,
                        ),
                        Text(
                          widget.user.about.toString(),
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.sh,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
