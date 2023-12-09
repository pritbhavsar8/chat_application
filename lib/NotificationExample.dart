import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationExample extends StatefulWidget
{
  const NotificationExample({Key? key}) : super(key: key);

  @override
  State<NotificationExample> createState() => _NotificationExampleState();
}

class _NotificationExampleState extends State<NotificationExample>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Notification"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(onPressed: () async{
              bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
              if(isAllowed)
                {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 101,
                          channelKey: 'alerts',
                          title: "Warning!",
                          body: "I am from chat app"
                      )
                  );
                }
              else
                {
                  AlertDialog alert = AlertDialog(
                    title: Text("Get Notified!"),
                    content: Text("Allow Awesome Notifications to send you beautiful notifications!"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Deny',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.red),
                          )),
                      TextButton(
                          onPressed: () async {
                            await AwesomeNotifications().requestPermissionToSendNotifications();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Allow',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.deepPurple),
                          )),
                    ],
                  );
                  showDialog(context: context, builder: (context){
                    return alert;
                  });
                }



            }, child: Text("Send")),
            ElevatedButton(onPressed: (){
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: 102,
                      channelKey: 'assetsimg',
                      title: "Warning!",
                      bigPicture: 'asset://img/bakery.png',
                     notificationLayout: NotificationLayout.BigPicture,
                  )
              );
            }, child: Text("Send Local img")),
            ElevatedButton(onPressed: (){
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 103,
                    channelKey: 'networkimg',
                    title: "Warning!",
                    bigPicture: "https://t4.ftcdn.net/jpg/01/43/42/83/360_F_143428338_gcxw3Jcd0tJpkvvb53pfEztwtU9sxsgT.jpg",
                    notificationLayout: NotificationLayout.BigPicture,
                  ),
              );
            }, child: Text("Send Network img")),
            ElevatedButton(onPressed: (){
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 104,
                    channelKey: 'buttons',
                    title: "Warning!",
                    body: ' notification with action buttons in Flutter App',
                  ),
                actionButtons: [
                  NotificationActionButton(
                      key: "Replay",
                      label: "Replay Message"
                  ),

                  NotificationActionButton(
                    key: "delete",
                    label: "Delete Message",
                  ),
                ]
              );
            }, child: Text("Show Notification With Button")),
          ],
        ),
      ),
    );
  }
}
