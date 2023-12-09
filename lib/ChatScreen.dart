
import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatScreen extends StatefulWidget
{
  var Photo ="";
  var Name = "";
  var receiverid="";
  ChatScreen({required this.Photo,required this.Name,required this.receiverid});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
{
  void scrollToBottom()
  {
    Timer(
      Duration(milliseconds: 300), // Delay for smoother scroll
          () {
            _controller.animateTo(
              _controller.position.minScrollExtent,
            duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
        );
      },
    );
  }
  TextEditingController _text = TextEditingController();
  ScrollController _controller = new ScrollController();
  var selected = "new group";
  var senderid="";
  var isloading=false;
  bool showemoji = false;
  File?selectedfile;

  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      senderid =prefs.getString("senderid").toString();
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
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: Colors.grey.shade100,
        leadingWidth: 20.0,
        title: Row(
          children: [
            CircleAvatar(child: Image.network(widget.Photo,width: 40.0)),
            SizedBox(width: 10.0,),
            Expanded(
              child: Text(widget.Name,style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.video_call_rounded)),
          IconButton(onPressed: (){}, icon: Icon(Icons.call)),
          PopupMenuButton(

            color: Colors.black,
            shape: OutlineInputBorder(
              borderRadius:BorderRadius.circular(11),
            ),
            position: PopupMenuPosition.over,

            onSelected: (val){
              print(val.toString());
              setState(() {
                selected=val!;
              });

            },
            itemBuilder:(context)
            {
              return const [
                PopupMenuItem(
                  child: Text("New group",style: TextStyle(
                    color: Colors.white
                  )),
                  value: "home",
                ),
                PopupMenuItem(
                  child: Text("New brodcast",style: TextStyle(
                      color: Colors.white
                  )),
                  value: "about",
                ),
                PopupMenuItem(
                  child: Text("Linked device",style: TextStyle(
                      color: Colors.white
                  )),
                  value: "contact",
                ),
                PopupMenuItem(
                  child: Text("Setting",style: TextStyle(
                      color: Colors.white
                  )),
                  value: "setting",
                ),
              ];
            },

          ),

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Users").doc(senderid)
                  .collection("chats").doc(widget.receiverid).collection("message").orderBy("timestamp",descending: true).snapshots(),
              builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasData)
                  {
                    if(snapshot.data!.size<=0)
                      {
                        return Center(
                          child: Text("No Message"),
                        );
                      }
                    else
                      {
                        return ListView(
                          scrollDirection: Axis.vertical,
                          controller: _controller,
                          reverse: true,
                          children: snapshot.data!.docs.map((document){

                            if(document["senderid"]==senderid)
                              {
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.purple.shade700,
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child:(document["type"]=="image")?Image.network(document["msg"].toString(),width: 200,):Text(document["msg"].toString(),style: TextStyle(color: Colors.white),),
                                  ),
                                );
                              }
                            else
                              {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.purple.shade500,
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: (document["type"]=="image")?Image.network(document["msg"].toString(),width: 200,):Text(document["msg"].toString(),style: TextStyle(color: Colors.white),),
                                  ),
                                );
                              }

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
              },
            )
          ),
          Row(
            children: [
              Expanded(child:   Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.grey.shade400,
                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          showemoji = !showemoji;
                        });
                      },
                          icon: Icon(Icons.emoji_emotions)),
                      Expanded(
                        child: TextField(
                          onTap: (){
                            if(showemoji)
                            setState(() {
                              showemoji = !showemoji;
                            });
                          },
                            controller: _text,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  )
                              ),
                              hintText: "Message",
                            )
                        ),
                      ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.attachment)),

                      IconButton(onPressed: () async{
                        final ImagePicker picker = ImagePicker();
                        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                        selectedfile=File(photo!.path);

                        if(selectedfile!=null)
                          {
                            setState(() {
                              isloading=true;
                            });
                            var uuid = Uuid();
                            var filename = uuid.v1().toString();

                            await FirebaseStorage.instance.ref(filename).putFile(selectedfile!).whenComplete((){}).then((filedata) async{
                              await filedata.ref.getDownloadURL().then((fileurl) async{
                                await FirebaseFirestore.instance.collection("Users").doc(senderid)
                                    .collection("chats").doc(widget.receiverid).collection("message").add({
                                  "senderid":senderid,
                                  "receiverid":widget.receiverid,
                                  "msg":fileurl,
                                  "type":"image",
                                  "timestamp":DateTime.now().millisecondsSinceEpoch
                                }).then((value) async{
                                  await FirebaseFirestore.instance.collection("Users").doc(widget.receiverid)
                                      .collection("chats").doc(senderid).collection("message").add({
                                    "senderid":senderid,
                                    "receiverid":widget.receiverid,
                                    "msg":fileurl,
                                    "type":"image",
                                    "timestamp":DateTime.now().millisecondsSinceEpoch
                                  }).then((value){
                                    AwesomeNotifications().createNotification(
                                      content: NotificationContent(
                                        id: 103,
                                        channelKey: 'networkimg',
                                        title: "Img sent",
                                        bigPicture: fileurl,
                                        notificationLayout: NotificationLayout.BigPicture,

                                      ),
                                    );
                                    setState(() {
                                      isloading=false;
                                    });
                                  });
                                });
                              });
                            });
                          }

                      },
                          icon: Icon(Icons.camera_alt)),
                    ],
                  ),
              )),
              (isloading)?CircularProgressIndicator():IconButton(onPressed: () async{

                var msg = _text.text.toString();
                if(msg.length!=0)
                  {
                    scrollToBottom();
                    _text.text="";

                    await FirebaseFirestore.instance.collection("Users").doc(senderid)
                        .collection("chats").doc(widget.receiverid).collection("message").add({
                      "senderid":senderid,
                      "receiverid":widget.receiverid,
                      "msg":msg,
                      "type":"text",
                      "timestamp":DateTime.now().millisecondsSinceEpoch
                    }).then((value) async{
                      await FirebaseFirestore.instance.collection("Users").doc(widget.receiverid)
                          .collection("chats").doc(senderid).collection("message").add({
                        "senderid":senderid,
                        "receiverid":widget.receiverid,
                        "msg":msg,
                        "type":"text",
                        "timestamp":DateTime.now().millisecondsSinceEpoch
                      });
                    });
                  }
              }, icon: Icon(Icons.send)),
            ],
          ),
          if(showemoji)
          SizedBox(
            height: 280.0,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {},
              textEditingController: _text,
              config: Config(
                columns: 8,
                bgColor: Colors.black,
                 emojiSizeMax: 30.0,
              ),
            ),
          ),
        ],
      ),

    );
  }
}

