import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChatScreen.dart';
import 'LoginScreen.dart';

class HomeScreen1 extends StatefulWidget
{


  HomeScreen1();

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {


  var name="";
  var email="";
  var photo="";
  var googleid="";

  getdata() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name").toString();
      email = prefs.getString("email").toString();
      photo = prefs.getString("photo").toString();
      googleid = prefs.getString("googleid").toString();
    });
  }


  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: Text("Home Screen"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();

              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.signOut();


              Navigator.of(context).pop;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginScreen(),)
              );
            },
            icon: Icon(Icons.logout,),

          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.indigo.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0,),
            CircleAvatar(
              radius: 20.0,
              child: InkWell(onTap: (){
                print("photo");
              },child: Image.network(photo)),
            ),
            SizedBox(height: 10.0,),
            Text(name),
            SizedBox(height: 10.0,),
            Text(email),
            SizedBox(height: 10.0,),
            Text(googleid),

          ],
        ),

      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").where("Email",isNotEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(snapshot.hasData)
          {
            if(snapshot.data!.size<=0)
            {
              return Center(
                child: Text("No data"),
              );
            }
            else
            {
              return ListView(
                children: snapshot.data!.docs.map((document){
                  return ListTile(
                    leading: Image.network(document["Photo"].toString()),
                    title: Text(document["Name"].toString()),
                    subtitle: Text(document["Email"].toString()),
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>ChatScreen(
                          Photo: document["Photo"].toString(),
                          Name: document["Name"].toString(),
                          receiverid: document.id.toString(),
                        ),)
                      );
                    },
                    onLongPress: () async {
                      var id = document.id.toString();
                      await FirebaseFirestore.instance.collection("Users").doc(id).delete().then((value){});
                    },
                  );
                }).toList(),
              );
            }
          }
          else
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

        }

      ),
    );
  }
}
