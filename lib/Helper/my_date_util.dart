
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class MyDateUtil{
  /// this function is used to convert the time format
  /// this {} bracket are use to show the suggestion to the user
  static String getFormatedTime({required BuildContext context,required String time}){
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
  /// for getting formated time for send and read message
  static String getMessageTime({required BuildContext context, required String time}){
  final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  final DateTime now = DateTime.now();

  final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
  if(now.day == sent.day && now.month == sent.month && now.year == sent.year){
    return formattedTime;
  }
  return now.year == sent.year
      ? '${formattedTime} - ${sent.day} ${_getMonth(sent)}'
      : '${formattedTime} - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  static String getLastMessageTime({required BuildContext context,  required String time, bool showYear = false}){
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now  = DateTime.now();
    if(now.day == sent.day && now.month == sent.month && now.year == sent.year){
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return showYear ? '${sent.day} ${_getMonth(sent)} ${sent.year} ' : '${sent.day} ${_getMonth(sent)}';
  }
  /// get formated last active time of our user in chat screen
  static String getLastActiveTime({required BuildContext context,required String lastActive}){
      final int i = int.tryParse(lastActive) ?? -1;

      /// if Time is not available then return the below statement
      if(i== -1) return 'last active not available';

      DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
      DateTime now = DateTime.now();

      String formattedTime = TimeOfDay.fromDateTime(time).format(context);
      if(time.day == now.day &&
          time.month == now.month &&
          time.year == now.year
      ){
        return 'Last seen today $formattedTime';
      }
      if((now.difference(time).inHours/24).round()==1){
        return 'Last seen yesterday $formattedTime';
      }
      String month = _getMonth(time);
      return 'Last seen on ${time.day} $month on $formattedTime';
  }
  static String _getMonth(DateTime date){
    switch (date.month){
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}