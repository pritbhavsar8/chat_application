import 'package:chat_application/HomeScreen1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget
{

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style:ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(11.0)
            )
          ) ,
          onPressed: () async
          {
            final GoogleSignIn googleSignIn = GoogleSignIn();
            final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
            if (googleSignInAccount != null)
            {
              final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
              final AuthCredential authCredential = GoogleAuthProvider.credential(
                  idToken: googleSignInAuthentication.idToken,
                  accessToken: googleSignInAuthentication.accessToken);

              // Getting users credential
              UserCredential result = await auth.signInWithCredential(authCredential);
              User user = result.user!;

              var name = user.displayName.toString();
              var email = user.email.toString();
              var photo = user.photoURL.toString();
              var googleid = user.uid.toString();

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("islogin", true);
              prefs.setString("name", name);
              prefs.setString("email", email);
              prefs.setString("photo", photo);
              prefs.setString("googleid", googleid);

              // Firestore
              //check

              await FirebaseFirestore.instance.collection("Users").where("Email",isEqualTo: email).get().then((documents) async{
                if(documents.size<=0)
                  {
                    await FirebaseFirestore.instance.collection("Users").add({
                      "Name":name,
                      "Email":email,
                      "Gid":googleid,
                      "Photo":photo,
                    }).then((document) async{
                      //sp
                      prefs.setString("senderid", document.id.toString());
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>HomeScreen1()),
                      );
                    });
                  }
                else
                  {
                    prefs.setString("senderid",documents.docs.first.id.toString());
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>HomeScreen1()),
                    );
                  }
              });
            }
          },
          child: Text("Login with Google"),
        ),
      ),
    );
  }
}
