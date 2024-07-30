import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:we_chat_app/Models/message_model.dart';
import 'package:we_chat_app/Models/users_model.dart';
import 'package:we_chat_app/main.dart';
import 'package:we_chat_app/widgets/chat_user_card.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing the cloud Firestore Database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for using firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // Now We want to create the user when the user signIn so first we check if the user exist or not if the use exist then return true and do nothing else create  new user
  // this getter method hep me not repeat the auth.currentUser and just use the user getter method
  // if i don't specify the return type User after the static keyword then it will not show me the suggestions in the CreateUser method and anywhere else
  static User get user => auth.currentUser!;

  /// for firebase messaging (push Notification)
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  /// for getting firebase message token
  static Future<void> getFirebaseMessagingToken() async {
    await fmessaging.requestPermission();

    /// the t means Token
    await fmessaging.getToken().then((t) {
      if (t != null) {
        me.pushToke = t;
        MyApp.logger.i('Push_Toke: $t}');
      }
    });
  }

  // for storing getSelfInfo user info
  // this is an object not a variable
  // an object of class usersModel
  static late usersModel me;

  /// for checking if the user exist or not
  static Future<bool> userExists() async {
    // the .get() is use to get the uid rest of the line is referencing the uid from the auth in the Collection 'users'
    // the .exists will check if the user exist or not and then return the bool value to the function
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  /// for checking if the user exist or not
  static Future<bool> addChaatUser(String email) async {
    // the .get() is use to get the uid rest of the line is referencing the uid from the auth in the Collection 'users'
    // the .exists will check if the user exist or not and then return the bool value to the function
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      /// user exist
      /// if the email matches then create a new collection named my_users in which create a doc
      /// i have to use  the .set method if i don't then the dock wont be created
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      /// user doesNot exist.
      return false;
    }
  }

  /// this method is used in the init state in HomePage for storing user data
  static Future<void> getSelfInfo() async {
    // the .get() is use to get the uid rest of the line is referencing the uid from the auth in the Collection 'users'
    // the .exists will check if the user exist or not and then return the bool value to the function
    // when i am trying the .then function i have to add the external parenthesis .then((user)()) <= this ones
    (await firestore.collection('users').doc(user.uid).get().then((user) async {
      // the if else condition is use to che if the user exist then store the user data else create a new user and then store its data.
      if (user.exists) {
        me = usersModel.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        /// this execute when the app is opened; for setting user status to active.
        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    }));
  }

// Creating a new User when SignIn for the first time
  // for creating the user we use the usersModel in the Models directory
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ChatUser = usersModel(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: 'he i am using we chat',
      createdAt: time,
      image: user.photoURL.toString(),
      isOnline: false,
      lastActive: time,
      pushToke: ' ',
    );
    // the .set() is used to set the user data by using the .toJson() method from the usersModel int the firestor.collection which is named 'users'
    // by using the uid provided by the Firebase Authentication which is defined above in this class
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(ChatUser.toJson());
  }

  // for getting id of known users from fireStore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    // the .where method is used to not show our current user who is using the app by using the user.uid
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // her the 'users' is name of my collection on FireStore database
  // for getting all the users from the firebase
  // the return type is derived from hovering over the snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getallUsers(
      List<String> userIds) {
    MyApp.logger.i('userIds: $userIds');

    // the .where method is used to not show our current user who is using the app by using the user.uid
    return firestore
        .collection('users')
        .where('id', whereIn: userIds)
        /* .where('id', isNotEqualTo: user.uid)*/
        .snapshots();
  }

  static Future<void> sendFirstMessage(
      usersModel Chatuser, String msg, Type type) async {
    // the .get() is use to get the uid rest of the line is referencing the uid from the auth in the Collection 'users'
    // the .exists will check if the user exist or not and then return the bool value to the function
    await firestore
        .collection('users')
        .doc(Chatuser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessages(Chatuser, msg, type));
  }

  // for checking if the user exist or not
  static Future<void> updateUserInfo() async {
    // the .get() is use to get the uid rest of the line is referencing the uid from the auth in the Collection 'users'
    // the .exists will check if the user exist or not and then return the bool value to the function
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    // for getting the extension like jpeg or png etc.
    // split() method is used to get the last keyword after the '.' keyword with the help of the .last
    final ext = file.path.split('.').last;
    MyApp.logger.i('Extension: $ext');
    // below line is used to create a file in the firebase storage and then naming the image with user unique id with the image extension then it is stored in ref variable
    // also getting the storage reference with help of storage.ref().
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    // now we ar putting the file with the help of ref.putFile(file) we are also setting metadata with the help of SettableMetadata(contentType: 'image/$ext'))
    // and then using the .then keyword also logging the bytesTransferred and converting it into kb
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      MyApp.logger.i('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    // updating the image in our userModel
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  /// for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersInfo(
      usersModel chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  /// update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_toke': me.pushToke,
    });
  }

  /// ********Chat screen related API***********
  /// useful for getting conversation id
  /// for faceting messages
  static String getConversitionId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  /// for getting all the messages from a specific conversation from fireStore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getallMessages(
      usersModel user) {
    return firestore
        .collection('chats/${getConversitionId(user.id.toString())}/messages/')
        // this is use to show the last chat message first.
        .orderBy('sent', descending: true)
        .snapshots();
  }

  /// this reference is pointing toward the above reference
  static Future<void> sendMessages(
      usersModel Chatuser, String msg, Type type) async {
    /// message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    /// message to send
    final message_model message = message_model(
        type: type,
        told: Chatuser.id,
        sent: time,
        read: "",
        msg: msg,
        fromid: user.uid);
    final ref = firestore.collection(
        'chats/${getConversitionId(Chatuser.id.toString())}/messages/');

    /// the time in the doc is very important for creating the docID => .doc(time)
    /// if i don't pass the time for as a parameter then it will create its own docID
    await ref.doc(time).set(message.toJson());
  }

  /// update read status of message
  // static Future<void> updateMessageReadStatus(message_model message) async {
  //   /// this is  an entire path to where we want to update in our collection
  //   firestore
  //       .collection('chats/${getConversitionId(message.fromid.toString())}/messages/')
  //       .doc(message.sent)
  //       .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      usersModel user) {
    return firestore
        .collection('chats/${getConversitionId(user.id.toString())}/messages/')

        /// for showing the last message in the subtitle in our listTile
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  /// update read status of message
  static Future<void> updateMessageReadStatus(message_model message) async {
    try {
      String docPath =
          'chats/${getConversitionId(message.fromid.toString())}/messages/${message.sent}';
      DocumentReference docRef = firestore.doc(docPath);

      // Check if the document exists before updating
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef
            .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
        MyApp.logger.i('Message read status updated');
      } else {
        MyApp.logger.e('Document not found: $docPath');
      }
    } catch (e) {
      MyApp.logger.e('Failed to update message read status: $e');
    }
  }

  /// his ChatUser is = to my userModel
  ///  send chat image
  static Future<void> sendChatImage(usersModel chatUser, File file) async {
    // split() method is used to get the last keyword after the '.' keyword with the help of the .last
    final ext = file.path.split('.').last;
    // below line is used to create a file in the firebase storage and then naming the image with user unique id with the image extension then it is stored in ref variable
    // also getting the storage reference with help of storage.ref().
    /// storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversitionId(chatUser.id.toString())}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    // now we ar putting the file with the help of ref.putFile(file) we are also setting metadata with the help of SettableMetadata(contentType: 'image/$ext'))
    // and then using the .then keyword also logging the bytesTransferred and converting it into kb
    /// uploading img
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      MyApp.logger.i('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    /// updating the image in our userModel
    final imageUrl = await ref.getDownloadURL();
    await sendMessages(chatUser, imageUrl, Type.image);
  }

  /// for deleting messages from the chat
  static Future<void> deleteMessage(message_model message) async {
    await firestore
        .collection(
            'chats/${getConversitionId(message.told.toString())}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg.toString()).delete();
    }
  }

  static Future<void> updateMessage(
      message_model message, String updatedMsg) async {
    await firestore
        .collection(
            'chats/${getConversitionId(message.told.toString())}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}
