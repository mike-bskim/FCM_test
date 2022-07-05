import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'background_message_handler.dart';
// import 'package:push_notification/background_message_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(const MyApp());
}

Future<void> _messageHandler(RemoteMessage message) async {
  debugPrint('----------------------background message ${message.notification!.body}');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     debugPrint('onMessage: $message');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     debugPrint('onLaunch: $message');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     debugPrint('onResume: $message');
    //   },
    //   onBackgroundMessage: myBackgroundMessageHandler,
    // );

    return MaterialApp(
      title: 'MessagingTutorial Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MessagingTutorial(),
    );
  }
}

class MessagingTutorial extends StatefulWidget {
  const MessagingTutorial({Key? key}) : super(key: key);

  @override
  State<MessagingTutorial> createState() => _MessagingTutorialState();
}

class _MessagingTutorialState extends State<MessagingTutorial> {
  late FirebaseMessaging _firebaseMessaging;

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) {
      debugPrint('token: [$token]');
    });
  }

  @override
  Widget build(BuildContext context) {

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      debugPrint("MessagingTutorial >> message recieved");
      debugPrint('Title >> ${event.notification!.title.toString()}');
      debugPrint('Body >> ${event.notification!.body.toString()}');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(event.notification!.title!),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('------------------------Message clicked!');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('MessagingTutorial Demo'),
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
