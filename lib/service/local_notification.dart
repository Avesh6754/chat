import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotification {
  LocalNotification._();

  static final LocalNotification instance = LocalNotification._();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> initNotification() async {
    AndroidInitializationSettings android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: android
    );
    await _plugin.initialize(initializationSettings);
    await showSimpleNotification();
  }

  Future<void> showSimpleNotification() async {
    AndroidNotificationDetails android = const AndroidNotificationDetails(
      "chat_application",
      "Chat App",
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: android);
    await _plugin.show(
      0,
      'Simple Notification',
      'This is a simple notification',
      platformChannelSpecifics,
    );
  }
}
