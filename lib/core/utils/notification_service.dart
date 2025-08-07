import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. الطلب إذن من المستخدم
    await _messaging.requestPermission();

    // 2. إعداد local notifications مع إعدادات iOS و Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // 3. Show FCM token (ممكن تخزنه في Firestore)
    if(Platform.isAndroid) {
      final token = await _messaging.getToken();
      print("🔥 FCM Token: $token");
    }


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

  // معالج للإشعارات المحلية على iOS (للإصدارات الأقدم)
  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // معالجة الإشعار المحلي على iOS
    print("📱 تم استقبال إشعار محلي على iOS: $title");
  }

  // معالج لاستجابة المستخدم للإشعار
  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      print("📬 تم النقر على الإشعار مع البيانات: $payload");
    }
  }

  static void showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'main_channel', // id
      'Main Channel', // title
      channelDescription: 'channel for main notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _localNotifications.show(
      message.notification.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }
}