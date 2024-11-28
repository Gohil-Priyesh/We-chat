import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:we_chat_app/Helper/my_date_util.dart';
import 'package:we_chat_app/Home/chat_screen.dart';
import 'package:we_chat_app/Models/message_model.dart';
import 'package:we_chat_app/Models/users_model.dart';
import 'package:we_chat_app/api/apis.dart';
import 'package:we_chat_app/widgets/dialogs/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  // i am importing the usersModel in this class for setting the data to the card Widget.
  // this user is the object of the userModel class.
  final usersModel user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  /// last message info(if null -> no message)
  message_model? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // color: Colors.blue.shade100,
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: InkWell(
          onTap: () {
            // the widget.user is referring to the above created user
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    user: widget.user,
                  ),
                ));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessages(widget.user),
            builder: (context, snapshot) {
              /// this data variable has the data from the snapshot from the docs
              /// this is having the null value at first;
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => message_model.fromJson(e.data())).toList() ??
                      [];

              /// to check if data is not equal to null and dat exist in the docs then this if() statement is executed
              if (list.isNotEmpty) {
                _message = list[0];
              }
              return ListTile(
                // leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
                leading: InkWell(
                  onTap: (){
                    // for showing user profile
                    showDialog(context: context, builder: (context) => ProfileDialog(user:widget.user,),);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.h),
                    child: CachedNetworkImage(
                      // the BoxFit.fill,cover is ued to make the image fit whit the given height and weight parameter if not use then it will not make the image circular as easily.
                      fit: BoxFit.cover,
                      height: 15.h,
                      width: 14.9.w,
                      imageUrl: widget.user.image.toString(),
                       placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                ),
                // setting the title in the ListTile
                title: Text(widget.user.name.toString()),
                // the maxLine is used to limit the subtitle to only one line
                /// last message showing in subtitle
                subtitle: Text(
                  // if the type of message is image then show 'image' in subtitle or else show the msg in the subtitle
                  _message != null ?
                      _message!.type == Type.image ? 'image'
                          :
                          // if the last msg is present in the chat then show last msg or else show users about in subtitle
                       _message!.msg.toString()
                      : widget.user.about.toString(),
                  maxLines: 1,
                ),

                /// show nothing when no message is sent
                trailing: _message == null
                    ? null
                    : _message!.read!.isEmpty &&
                            _message!.fromid != APIs.user.uid
                //ternary operator
                    ?

                        /// show for unread message
                        Container(
                            width: 4.w,
                            height: 2.h,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          )
                // else condition for the ternary operator
                        :

                        /// message read time
                        Text(
                            MyDateUtil.getLastMessageTime(
                                context: context,
                                time: _message!.sent.toString()),
                            style: TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
