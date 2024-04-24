
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';

import 'constant.dart';

//region Handle Background Firebase Message
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp().then((value) {}).catchError((e) {});
}
//endregion
// TODO, analysis these code in next step
Future<void> initFirebaseMessaging() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.instance.setAutoInitEnabled(true).then((value) {
    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null && message.notification!.title.validate().isNotEmpty && message.notification!.body.validate().isNotEmpty) {
        log('NOTIFICATIONDATA: ${message.data}');
        showNotification(currentTimeStamp(), message.notification!.title.validate(), message.notification!.body.validate(), message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  });

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
}

void handleNotificationClick(RemoteMessage message) {
  if (message.data.containsKey('is_chat')) {
    LiveStream().emit(LIVESTREAM_FIREBASE, 3);
    /*if (message.data.isNotEmpty) {
      // navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ChatListScreen()));
      // log('message.data=============== ${message.data}');
      // log('UserData.fromJson(message.data)=============== ${UserData.fromJson(message.data)}');
      navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => UserChatScreen(receiverUser: UserData.fromJson(message.data))));
    }*/
  } else if (message.data.containsKey('id')) {
    String? notId = message.data["id"].toString();
    // if (notId.validate().isNotEmpty) {
    //   navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => BookingDetailScreen(bookingId: notId.toString().toInt())));
    // }
  } else if (message.data.containsKey('service_id')) {
    String? notId = message.data["service_id"];
    // if (notId.validate().isNotEmpty) {
    //   navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ServiceDetailScreen(serviceId: notId.toInt())));
    // }
  }
}


void showNotification(int id, String title, String message, RemoteMessage remoteMessage) async {
  log(title);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //code for background notification channel
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'notification',
    'Notification',
    importance: Importance.high,
    enableLights: true,
    playSound: true,
  );

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_stat_ic_notification');
  var iOS = const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  var macOS = iOS;
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iOS, macOS: macOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      handleNotificationClick(remoteMessage);
    },
  );

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'notification',
    'Notification',
    importance: Importance.high,
    visibility: NotificationVisibility.public,
    autoCancel: true,
    //color: primaryColor,
    playSound: true,
    priority: Priority.high,
    icon: '@drawable/ic_stat_ic_notification',
  );

  var darwinPlatformChannelSpecifics = const DarwinNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: darwinPlatformChannelSpecifics,
    macOS: darwinPlatformChannelSpecifics,
  );

  flutterLocalNotificationsPlugin.show(id, title, message, platformChannelSpecifics);
}
