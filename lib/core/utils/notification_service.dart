import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. الطلب إذن من المستخدم
    await _messaging.requestPermission();

    // 2. إعداد local notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(settings);

    // 3. Show FCM token (ممكن تخزنه في Firestore)
    final token = await _messaging.getToken();
    print("🔥 FCM Token: $token");

    // 4. استقبال الإشعار لما التطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 إشعار في foreground: ${message.notification?.title}");
      showLocalNotification(message);
    });

    // 5. لما المستخدم يفتح الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📬 تم فتح التطبيق من إشعار");
    });
  }

  static void showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'main_channel', // id
      'Main Channel', // title
      channelDescription: 'channel for main notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    _localNotifications.show(
      message.notification.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }
}