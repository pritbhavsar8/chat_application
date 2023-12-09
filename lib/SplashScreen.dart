import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:chat_application/HomeScreen1.dart';
import 'package:chat_application/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget
{
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
{
  checklogin() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GoogleSignIn googleSignIn = GoogleSignIn();
   // if(prefs.containsKey("islogin"))
    if(await googleSignIn.isSignedIn())
      {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>HomeScreen1()));
      }
    else
      {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>LoginScreen()),
        );
      }
  }
  
  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), (){
      checklogin();
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: JelloIn(
          animate: true,
            child: Icon(Icons.chat,color: Colors.green,size: 100.0,)
        ),
      ),
    );
  }
}
