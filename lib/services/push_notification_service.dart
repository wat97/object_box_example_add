import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_object_box/object_box.dart';

import '../main.dart';
import '../model/model_notification.dart';

class PushNotificationService {
  Future initialize() async {
    late final FirebaseMessaging _messaging;

    // 1. Initialize the Firebase app
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    print("settingAuthor ${settings.authorizationStatus}");

    print("tokenPush ");
    print(await getToken());

    print('User granted permission');

    // FirebaseMessagingPlatform
    // TODO: handle the received notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Parse the message received

      print("messageObject");
      print(jsonEncode(message.data));
      try {
        final ObjectBox objectBox = await getStore();
        ModelNotification modelNotification = ModelNotification(
          title: message.data['title'],
          detail: message.data['body'],
        );
        objectBox.addNotification(modelNotification);
      } catch (e) {
        print("errorMessage ${e}");
      }
    });
  }

  static Future firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    print("messageHandler ${message}");
  }

  static Future<String> getToken() async {
    String? tokenPush;
    await FirebaseMessaging.instance.getToken().then(
      (token) {
        tokenPush = token;
        // Storage().setString(
        //   Storage.,
        //   tokenPush ?? "defaultToken",
        // );
        print("getFcm $token");
      },
    );
    return tokenPush ?? "defaultToken";
  }
}
