import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloudNotificationsExample extends StatefulWidget {
  const CloudNotificationsExample({Key? key}) : super(key: key);
  @override
  State<CloudNotificationsExample> createState() => _CloudNotificationsExampleState();
}

class _CloudNotificationsExampleState extends State<CloudNotificationsExample> {

  var token="";

  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token").toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Notification"),
      ),
      body: Text(token),
    );
  }
}
