import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:prosnap/core/navigation/app_navigator.dart';
import 'package:prosnap/features/chating/views/chating_screen.dart';
import 'package:prosnap/features/conversations/views/conversations.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static String? fcmToken;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(requestAlertPermission: true),
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationClick(details.payload);
      },
    );

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    fcmToken = await _messaging.getToken();
    log("FCM Token: $fcmToken");

    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationClick(message.data['route']);
    });

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data['route']);
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          color: Color.fromARGB(255, 26, 171, 74),
        );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );
    await _localNotifications.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformDetails,
      payload: message.data['route'],
    );
  }

  Future<void> displayNotification({title, body, route}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          color: Color.fromARGB(255, 97, 194, 5),
        );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );
    await _localNotifications.show(
      0,
      title,
      body,
      platformDetails,
      payload: route,
    );
  }

  void _handleNotificationClick(String? route) async {
    if (route == '/conversations') {
      AppNavigator.push(const ConversationsScreen());
    }

    if (route?.contains('chat') ?? false) {
      final conversationId = route!.split("/").last;
      AppNavigator.push(ChatingScreen(conversationId: conversationId));
    }
  }
}
