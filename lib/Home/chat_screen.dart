import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' as foundation;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:we_chat_app/Helper/my_date_util.dart';
import 'package:we_chat_app/Home/view_profileScreen.dart';
import 'package:we_chat_app/Models/message_model.dart';
import 'package:we_chat_app/Models/users_model.dart';
import 'package:we_chat_app/api/apis.dart';
import 'package:we_chat_app/custom_widgets/Custom_appBar.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final usersModel user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _txtController = TextEditingController();

  /// this _list store all the data from the Message_model
  List<message_model> _list = [];

  /// for storing of showing or hiding emoji
  bool _showEmoji = false;

  /// this is used for showing a progress bar when uploading multiple images if uploading is true then show progress bar or else don't
  bool _isUploading = false;

  /// this is the function used in PopScope
  void _onWillPop(bool didPop) async {
    if (didPop) {
      return;
    }
    if (_showEmoji) {
      setState(() {
        // _isSearching = false;
        _showEmoji = !_showEmoji;
      });
      // this future value is necessary because popScope takes void future function
      return Future.value(false);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
    // this future value is necessary because popScope takes void future function
    return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvoked: _onWillPop,
          child: Scaffold(
            appBar: CustomAppbar(
              automaticallyImplyLeading: false,
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: Colors.white),
              flexibleSpace: appBar(),
            ),
            backgroundColor: Color.fromARGB(255, 221, 245, 255),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(

                      /// this switch case checks that is the streamBuilder is waiting for the data from the 'users' then show the progressIndicator
                      /// then when the connection is active then the data will be stored in the list form the data variable which use snapshot.data.docs;
                      stream: APIs.getallMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return SizedBox();
                          case ConnectionState.active:
                          case ConnectionState.done:

                            /// if the connection is done then execute  the below code
                            final data = snapshot.data?.docs;
                            // if i don't use e.data then i will throw an error
                            // the list will only get the instance of usersModel from this map. after getting the instance of the usersModel we set the data to the car widget in the ChatUserCard class
                            _list = data
                                    ?.map((e) => message_model.fromJson(e.data()))
                                    .toList() ??
                                [];

                            /// if the list have the data then show the data with the help of card
                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                /// i make the reverse ture because the list is set to .orderBy('sent', descending: true) in Api.getallMessages
                                /// function so the list which i get is upSide down so using the reverse: true make it inverted again
                                reverse: true,
                                /// this physics is use to make the list view bounce when the scrolling ends
                                physics: BouncingScrollPhysics(),
                                itemCount: _list.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                },
                              );

                              /// if the data is not present in the list then show the text message
                            } else {
                              return Center(
                                  child: Text(
                                'Say Hi!👋',
                                style: TextStyle(fontSize: 25),
                              ));
                            }
                        }
                      }),
                ),
                  if(_isUploading)
                  Align(
                    alignment: Alignment.centerRight,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical:1.h, horizontal:3.w),
                        child: CircularProgressIndicator(strokeWidth: 2,),
                      )
                  ),


                /// it is equal to his _chatInput(),
                /// this is the text input field of my main chat screen
                _MessageInputField(),

                if (_showEmoji)
                  SizedBox(
                    height: 30.h,

                    /// for using  Emoji
                    child: EmojiPicker(
                      textEditingController: _txtController,
                      config: Config(
                        bgColor: Color.fromARGB(255, 221, 245, 255),
                        columns: 8,
                        checkPlatformCompatibility: true,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // appBar()
  Widget appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfileScreen(user: widget.user),));
      },
      child: StreamBuilder(stream: APIs.getUsersInfo(widget.user),builder: (context, snapshot) {
        /// this data variable has the data from the snapshot from the docs
        /// this is having the null value at first;
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => usersModel.fromJson(e.data())).toList() ??
                [];

        return  Row(
          children: [
            /*IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),*/
            // for showing user image
            Padding(
              padding: EdgeInsets.only(top: .5.sh, bottom: .5, left: 12.sw),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.h),
                /// this CachedNetworkImage is use to show image in our app i have imported an package for this.
                child: CachedNetworkImage(
                  // the BoxFit.fill is sued to make the image fit whit the given height and weight parameter if not use then it will not make the image circular as easily.
                  fit: BoxFit.fill,
                  height: 5.sh,
                  width: 10.5.sw,
                  imageUrl: list.isNotEmpty ? list[0].image.toString() : widget.user.image.toString(),
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 1.5.sh,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // for showing user name
                Text(
                  list.isNotEmpty ? list[0].name.toString() :
                  widget.user.name.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: .25.sh,
                ),
                // for showing user about
                Text(list.isNotEmpty ?
                    list[0].isOnline! ? 'online':
                MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive.toString()) :
                MyDateUtil.getLastActiveTime(context: context, lastActive:  widget.user.lastActive.toString()),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.black87),
                )
              ],
            )
          ],
        );
      },
      ),
    );
  }

  /// text input field for my chat screen
  Widget _MessageInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: .5),
      child: Row(children: [
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(()=>_showEmoji = !_showEmoji);
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                    )),
                Expanded(
                    child: TextField(
                  controller: _txtController,
                  /// this two Keyboard type and maxLine is use to make the textField expand according to the text when multiple lines are inserted
                  keyboardType: TextInputType.multiline,
                  onTap: (){
                    /// if the text field is taped and the emojis are open then hide emoji picker by making it false
                   if(_showEmoji)setState(()=> _showEmoji = !_showEmoji);
                  },
                  maxLines: null,
                  decoration: InputDecoration(

                      /// this makes the text field borderless
                      border: InputBorder.none,
                      hintText: 'Message',
                      hintStyle: TextStyle(
                        color: Colors.lightBlueAccent,
                      )),
                )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // pick an image
                      // imageQuality is use just to save some server space  it is not necessary
                      /// my multiImages is = his images; this is for picking Multiple images
                      final List<XFile> multiImages = await picker.pickMultiImage(imageQuality: 70);
                      /// uploading and sending image one by one
                      for (var i in  multiImages){
                        MyApp.logger.i('ImagePath${i.path}');
                        setState(()=> _isUploading=true);
                        await APIs.sendChatImage(widget.user,File(i.path));
                        setState(()=> _isUploading=false);
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                    )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // pick an image
                      // imageQuality is use just to save some server space  it is not necessary
                      final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
                      if(image != null){
                        MyApp.logger.i('image path: ${image.path}');
                        setState(()=> _isUploading=true);

                        // for updating the profile picture in our database
                        await APIs.sendChatImage(widget.user,File(image.path));
                        setState(()=> _isUploading=false);
                      }
                      },
                    icon: const Icon(
                      CupertinoIcons.camera_fill,
                    )),
                SizedBox(
                  width: 2.sw,
                )
              ],
            ),
          ),
        ),
        MaterialButton(
          height: 5.sh,
          color: Colors.greenAccent,
          minWidth: 0,
          shape: CircleBorder(),
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 3.sh,
          ),
          onPressed: () {
            if (_txtController.text.isNotEmpty) {
              if(_list.isEmpty){
                /// on first message (add user to my_users collection of chat users)
                APIs.sendFirstMessage(widget.user, _txtController.text, Type.text);
              }else {
                // the Type is defined to text because we pass text data hear from our controller
                APIs.sendMessages(widget.user, _txtController.text, Type.text);
              }
              _txtController.text = '';
            }
          },
        )
      ]),
    );
  }
}
