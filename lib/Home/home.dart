import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:we_chat_app/Helper/dialogs.dart';
import 'package:we_chat_app/Home/profileScreen.dart';
import 'package:we_chat_app/Models/message_model.dart';
import 'package:we_chat_app/Models/users_model.dart';
import 'package:we_chat_app/api/apis.dart';
import 'package:we_chat_app/custom_widgets/Custom_appBar.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/utils/strings.dart';
import 'package:we_chat_app/widgets/chat_user_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();

    /// for updating user active status according to lifecycle events
    /// resume -> active or online
    /// pause ->  inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message){
      MyApp.logger.i('Message $message');
      /// this if condition is user because if the user logout of application then the active status will remain online so to prevent this issue we used this if condition
      /// that if currentUser is null then don't execute this condition if it is != null then only execute this conditions
      if(APIs.auth.currentUser != null){
        if (message.toString().contains('resume'))APIs.updateActiveStatus(true);
        if (message.toString().contains('pause'))APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });

  }

  // for storing all users
  List<usersModel> _list = [];
  // for storing search items
  final List<usersModel> _SearchList = [];
  // for storing search status
  bool _isSearching = false;

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onWillPop(bool didPop) async {
    if (didPop) {
      return;
    }

    if (_isSearching) {
      setState(() {
        // _isSearching = false;
        _isSearching = !_isSearching;
      });
      return Future.value(false);
    }
    final bool shouldPop = await _showBackDialog() ?? false;
    if (context.mounted && shouldPop) {
      Navigator.pop(context);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvoked: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppbar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 3,
            shadowColor: Colors.black54,
            leading: Icon(CupertinoIcons.home),
            actions: [
              // if the searching is on then it uses the clear_circled icon and if the searching process is not happening then it will show the search icon
              // this can be achieved with the help of Ternary operator
              IconButton(
                  onPressed: () {
                    setState(() {
                      // this statement makes the condition of the _isSearching opposite of whatever it is lets say if ture then it make it to false and visa versa
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    // i am passing the list because the list has all the data of the user
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profilescreen(
                            user: APIs.me,
                          ),
                        ));
                  },
                  icon: Icon(Icons.more_vert))
            ],
            // this textField is used for searching the users
            title: _isSearching
                ? TextField(
                    style: TextStyle(fontSize: 17, letterSpacing: 1),
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name , Email...',
                    ),
                    onChanged: (val) {
                      _SearchList.clear();
                      for (var i in _list) {
                        if (i.name!.toLowerCase().contains(val.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
                          _SearchList.add(i);
                          setState(() {});
                        }
                      }
                    })
                : Text(title),
          ),
          // floating Action Button for search
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 10),

            /// floatingActionButton
            child: FloatingActionButton(
              onPressed: () async {
                _addChatUserDialog();
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),
          // I Cannot use the ListView inside the Colum
            /// get id of only known users
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  // return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:

                final userIds = snapshot.data?.docs.map((e) => e.id).toList() ?? [];
                if (userIds.isEmpty) {
                  return Center(
                    child: Text(
                      'No connections found!',
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }

              /// get only those users who's id's are provided
             return StreamBuilder(

                // this switch case checks that is the streamBuilder is waiting for the data from the 'users' then show the progressIndicator
                // then when the connection is active then the data will be stored in the list form the data variable which use snapshot.data.docs;
                  stream: APIs.getallUsers(userIds),

                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        // return Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                      // if the connection is done then execute  the below code
                        final data = snapshot.data?.docs;
                        // if i don't use e.data then i will throw an error
                        // the list will only get the instance of usersModel from this map. after getting the instance of the usersModel we set the data to the car widget in the ChatUserCard class
                        _list = data
                            ?.map((e) => usersModel.fromJson(e.data()))
                            .toList() ??
                            [];

                        // if the list have the data then show the data with the help of card
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            // this physics is use to make the list view bounce when the scrolling ends
                            physics: BouncingScrollPhysics(),
                            itemCount:
                            _isSearching ? _SearchList.length : _list.length,
                            itemBuilder: (context, index) {
                              return ChatUserCard(
                                user: _isSearching
                                    ? _SearchList[index]
                                    : _list[index],
                              );
                              // return Text('Name: ${_list[index]}');
                            },
                          );
                          // if the data is not present in the list then show the text message
                        } else {
                          return Center(
                              child: Text(
                                'No connections found!',
                                style: TextStyle(fontSize: 25),
                              ));
                        }
                    }
                  }
              );
            }
          },)
        ),
      ),
    );
  }
  void _addChatUserDialog(){
    String email = '';

    showDialog(context: context, builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.only(left: 5.w,right: 5.w,top: 3.h,bottom: 1.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.h)),
      title: Row(
        children: [
          Icon(Icons.person_add,size: 23.sp,),
          SizedBox(width: 2.w,),
          Text('Add User')
        ],
      ),
      content: TextFormField(
        maxLines: null,
        // this onChange is used to change the msg value to a new value. given by the user
        onChanged: (value) => email= value,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email,color: Colors.lightBlueAccent,),
            hintText: 'Email Id',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.w))),
      ),
      actions: [
        MaterialButton(
          padding:EdgeInsets.only(top: 3.h),
          onPressed: (){
            Navigator.pop(context);
          },child: Text('Cancel',style: TextStyle(fontSize: 16.sp,color:Colors.lightBlueAccent),),),

        /// add User button
        MaterialButton(
          padding: EdgeInsets.only(top: 3.h),
          onPressed: () async {
            if(email.isNotEmpty) {
              await APIs.addChaatUser(email).then((value){
                if(!value){
                  Dialogs.showSnackbar(context, 'User does not Exist!');
                }
              });
            }
            /// i have to use Navigator.pop(context) below the showSnackbar or else the showSnackaber wont get the context
            /// because the screen is poped from the stack.
            Navigator.pop(context);
          },child: Text('Add',style: TextStyle(fontSize: 16.sp,color: Colors.lightBlueAccent),
        ),
        )
      ],
    ),
    );
  }
}
