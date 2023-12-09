import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_application/CloudNotificationsExample.dart';
import 'package:chat_application/LoginScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChatScreen.dart';
import 'NotificationExample.dart';
import 'SplashScreen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
       null, //'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Alerts',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple),


        NotificationChannel(
            channelKey: 'assetsimg',
            channelName: ' AssetsIMG',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple),
        NotificationChannel(
            channelKey: 'networkimg',
            channelName: 'NetworkIMG',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.deepPurple),
        NotificationChannel(
            channelKey: 'buttons',
            channelName: 'Buttons',
            channelDescription: 'Notification tests as alerts',
            playSound: true,
            onlyAlertOnce: true,
            groupAlertBehavior: GroupAlertBehavior.Children,
            importance: NotificationImportance.High,
            defaultPrivacy: NotificationPrivacy.Private,
            defaultColor: Colors.deepPurple,
            ledColor: Colors.orangeAccent),
      ],
      debug: true);
  AwesomeNotifications().actionStream.listen((action) {
    if(action.buttonKeyPressed == "Replay"){
      print("Replay button is pressed");
    }else if(action.buttonKeyPressed == "delete"){
      print("Delete button is pressed.");
    }else{
      print(action.payload); //notification was pressed
    }
  });

  await FirebaseMessaging.instance.getToken().then((value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", value.toString());
  });
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  runApp(const MyApp());
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
      var title = notification.title.toString();
      var body = notification.body.toString();

      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 101,
              channelKey: 'alerts',
              title: title,
              body: body
          )
      );
  }
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Splashscreen(),
    );
  }
}

