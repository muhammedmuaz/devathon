import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

class FirebaseApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  final _firebasenotification = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // Initializing Local Notification
    _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    NotificationSettings settings =
        await _firebasenotification.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // settings.authorizationStatus
    final fcm = await _firebasenotification.getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
      pushNotification(message);
      // Trigger a dialog or update the UI with the received message
    });
    // FirebaseMessaging.onBackgroundMessage(
    //     _firebaseMessagingBackgroundHandler);
  }

  static void pushNotification(
    RemoteMessage message,
  ) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channed id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _notification.show(
      2,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static scheduleNotification(differenceInMinutes, String Message) async {
    timezone.initializeTimeZones();
    // Fetch pending notifications
    List<PendingNotificationRequest> pendingNotifications =
        await _notification.pendingNotificationRequests();

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max, // set the importance of the notification
      priority: Priority.high, // set prority
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _notification.zonedSchedule(
      Random().nextInt(100000),
      "Navigator App",
      Message,
      // timezone.TZDateTime.from(time, timezone.local),
      timezone.TZDateTime.now(timezone.local)
          .add(Duration(minutes: differenceInMinutes)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
