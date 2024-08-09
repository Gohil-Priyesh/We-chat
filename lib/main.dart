import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:we_chat_app/Home/splashscreen.dart';
import 'package:we_chat_app/logger_interceptor.dart';
import 'firebase_options.dart';

void main()async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  // the binding was not initialized correctly
  /// Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  /// for setting orientations to portrait only.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value){
    _initializeFirebase();
    runApp(const MyApp());
  });
  
  await Firebase.initializeApp(); // Initialize Firebase



  // Initialize Logger
  final logger = Logger();
  logger.i("Firebase Initialized");

  // Setup Dio with LoggerInterceptor
  //i have to use dio when i make any server calls
  final dio = Dio();
  dio.interceptors.add(LoggerInterceptor());



}
class MyApp extends StatelessWidget {
  static final logger = Logger();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return  MaterialApp(
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(

            tooltipTheme: TooltipThemeData(decoration: BoxDecoration(
              color: Colors.lightBlueAccent
            )),
            iconTheme: IconThemeData(color: Colors.lightBlueAccent),
            disabledColor: Colors.lightBlue,
            appBarTheme: AppBarTheme(color: Colors.white),
            useMaterial3: true,

            // Define the default brightness and colors.
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightBlue,
              // ···
              brightness: Brightness.light,
            ),

            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              displayLarge: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
              // ···
              titleLarge: GoogleFonts.abel(
                fontSize: 30,
                // fontStyle: FontStyle.italic,
              ),
              bodyMedium: GoogleFonts.merriweather(),
              displaySmall: GoogleFonts.pacifico(),
            ),
          ),
          home: Splashscreen(),
        );
      },
    );
  }
}
_initializeFirebase() async {

  // Log Firebase initialization
  final logger = Logger();
  logger.i("Firebase initialized with options: ${DefaultFirebaseOptions.currentPlatform}");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',

  );
  MyApp.logger.i('Notification channel log $result');
}