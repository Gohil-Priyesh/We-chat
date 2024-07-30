import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:we_chat_app/Helper/dialogs.dart';
import 'package:we_chat_app/Helper/my_date_util.dart';
import 'package:we_chat_app/Models/message_model.dart';
import 'package:we_chat_app/api/apis.dart';
import 'package:we_chat_app/main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final message_model message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromid;
    return InkWell(
      onLongPress: () {
        _shoBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  Widget _blueMessage() {
    /// update last read message if sender and receiver are different
    if (widget.message.read!.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      MyApp.logger.i('message read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2.h),
                  topRight: Radius.circular(2.h),
                  bottomRight: Radius.circular(2.h)),
              color: Color.fromARGB(255, 221, 245, 255),
            ),

            /// if the message is of type image then padding should b 2.w else if is a text message then it should be 3.w
            padding:
                EdgeInsets.all(widget.message.type == Type.image ? 2.w : 3.w),
            margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.5.w),

            /// ternary operator if the user input is text then show tex and if user input is image then show image
            /// this is done by using the enum name Type which is create in message_model to use multiple input base on the Type
            child: widget.message.type == Type.text
                ?

                /// for showing text in the chat
                Text(
                    widget.message.msg.toString(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        letterSpacing: 4.sp),
                  )

                /// for showing image in the chat
                : ClipRRect(
                    borderRadius: BorderRadius.circular(1.h),
                    child: CachedNetworkImage(
                      // the BoxFit.fill is sued to make the image fit whit the given height and weight parameter if not use then it will not make the image circular as easily.
                      fit: BoxFit.fill,
                      // this are not use it is use to resize the image according to our need
                      // height: 30.sh,
                      // width: 50.sw,
                      imageUrl: widget.message.msg.toString(),
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70.h,
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 3.w),
          child: Text(
            MyDateUtil.getFormatedTime(
                context: context, time: widget.message.sent.toString()),
            style: TextStyle(fontSize: 15.sp, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// message content
        Row(
          children: [
            SizedBox(width: 2.w),

            /// icon for double ticks.
            if (widget.message.read!.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                size: 2.h,
              ),
            SizedBox(
              width: 0.5.w,
            ),

            /// text which shows sent time.
            Text(
              MyDateUtil.getFormatedTime(
                  context: context, time: widget.message.sent.toString()),
              style: TextStyle(fontSize: 15.sp, color: Colors.black54),
            ),
          ],
        ),

        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreen),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2.h),
                  topRight: Radius.circular(2.h),
                  bottomLeft: Radius.circular(2.h)),
              color: Color.fromARGB(255, 218, 255, 176),
            ),

            /// if the message is of type image then padding should b 2.w else if is a text message then it should be 3.w
            padding:
                EdgeInsets.all(widget.message.type == Type.image ? 2.w : 3.w),
            margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.5.w),
            child: widget.message.type == Type.text
                ?

                /// for showing text in the chat
                Text(
                    widget.message.msg.toString(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        letterSpacing: 4.sp),
                  )

                /// for showing image in the chat
                : ClipRRect(
                    borderRadius: BorderRadius.circular(1.h),
                    child: CachedNetworkImage(
                      // the BoxFit.fill is sued to make the image fit whit the given height and weight parameter if not use then it will not make the image circular as easily.
                      fit: BoxFit.fill,
                      // this are not use it is use to resize the image according to our need
                      // height: 30.sh,
                      // width: 50.sw,
                      imageUrl: widget.message.msg.toString(),
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70.h,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// bottom sheet for modifying message details
  void _shoBottomSheet(bool isMe) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            /// for showing a small divider
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 38.w),
              height: 8.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.h),
                color: Colors.grey,
              ),
            ),

            widget.message.type == Type.text
            /// Copy text
                ? _OptionItem(
                    icon: Icon(
                      Icons.copy_all_rounded,
                      size: 22.sp,
                    ),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(
                              text: widget.message.msg.toString()))
                          .then((value) {
                        /// for hiding bottom sheet when the uer press the button
                        Navigator.pop(context);
                        MyApp.logger.e('Text copied');
                        Dialogs.showSnackbar(context, 'Text copied');
                      });
                    })
                   /// Save Image
                : _OptionItem(
                    icon: Icon(
                      Icons.download_rounded,
                      size: 22.sp,
                    ),
                    name: 'Save Image',
                    onTap: () async {
                      try{MyApp.logger.i('image URl: ${widget.message.msg}');
                      await GallerySaver.saveImage(widget.message.msg.toString(),albumName: 'WeChat').then((success) {
                        Navigator.pop(context);
                        if(success != null && success){
                          Dialogs.showSnackbar(context, 'image saved');
                        }
                      });}
                      catch(e){
                        MyApp.logger.e('Error while saving image $e');
                          }
                    }),

            if (isMe)
              Divider(
                indent: 3.w,
                endIndent: 3.w,
                color: Colors.black45,
              ),
            if (widget.message.type == Type.text && isMe)
              /// Edit
              _OptionItem(
                  icon: Icon(
                    Icons.edit,
                    size: 22.sp,
                  ),
                  name: 'Edit',
                  onTap: () {
                    /// i have to use pop(context) before the _showMessageUpdateDiaglog();
                    /// or else the show dialog will be called then immediately will be pop from the stack and the dialog will not show.
                    Navigator.pop(context);
                      _showMessageUpdateDiaglog();

                  }),
            /// Delete
            if (isMe)
              _OptionItem(
                  icon: Icon(
                    Icons.delete_forever,
                    size: 22.sp,
                    color: Colors.red,
                  ),
                  name: 'Delete',
                  onTap: () async {
                   await APIs.deleteMessage(widget.message).then((value){
                     Navigator.pop(context);
                   });
                  }),
            Divider(
              indent: 3.w,
              endIndent: 3.w,
              color: Colors.black45,
            ),
            /// Send At
            _OptionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  size: 22.sp,
                ),
                name:
                    'Send At : ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent.toString())}',
                onTap: () {}),
            /// Not seen yet
            _OptionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  size: 22.sp,
                  color: Colors.greenAccent,
                ),
                name: widget.message.read!.isEmpty
                    ? 'Read At : Not seen yet'
                    : 'Read At : ${MyDateUtil.getMessageTime(context: context, time: widget.message.read.toString())}',
                onTap: () {}),
          ],
        );
      },
    );
  }
  void _showMessageUpdateDiaglog(){
    String updatedMsg = widget.message.msg.toString();

    showDialog(context: context, builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.only(left: 5.w,right: 5.w,top: 3.h,bottom: 1.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.h)),
      title: Row(
        children: [
          Icon(Icons.message,size: 23.sp,),
          SizedBox(width: 2.w,),
          Text('Update Messag')
        ],
      ),
      content: TextFormField(
        maxLines: null,
        // this onChange is used to change the msg value to a new value. given by the user
        onChanged: (value) => updatedMsg = value,
        initialValue: updatedMsg,
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.w))),
      ),
      actions: [
        MaterialButton(
          padding:EdgeInsets.only(top: 3.h),
        onPressed: (){
          Navigator.pop(context);
        },child: Text('Cancel',style: TextStyle(fontSize: 16.sp,color:Colors.lightBlueAccent),),),

        MaterialButton(
          padding: EdgeInsets.only(top: 3.h),
          onPressed: (){
          Navigator.pop(context);
          APIs.updateMessage(widget.message, updatedMsg);
        },child: Text('Update',style: TextStyle(fontSize: 16.sp,color: Colors.lightBlueAccent),),)

      ],
    ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, top: 2.h, bottom: 2.h),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: TextStyle(
                  fontSize: 15.sp, color: Colors.black54, letterSpacing: 3.sp),
            ))
          ],
        ),
      ),
    );
  }
}

