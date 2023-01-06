import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:test_object_box/model/model_notification.dart';
import 'package:test_object_box/object_box.dart';
import 'package:test_object_box/widget/list_notification.dart';

import 'services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    initStore(),
    PushNotificationService().initialize(),
  ]).then((value) {
    FirebaseMessaging.onBackgroundMessage(
        PushNotificationService.firebaseMessagingBackgroundHandler);
  });

  runApp(const MyApp());
}

// global variable
final Completer<ObjectBox> _storeCompleter = Completer<ObjectBox>();

Future<void> initStore() async {
  if (!_storeCompleter.isCompleted) {
    final store = await ObjectBox.create();
    _storeCompleter.complete(store);
  }
}

Future<ObjectBox> getStore() async {
  if (!_storeCompleter.isCompleted) {
    final store = await ObjectBox.create();
    _storeCompleter.complete(store);
  }
  return await _storeCompleter.future;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListNotification(),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            FloatingActionButton(
              onPressed: () async => onSignFunction(),
              tooltip: 'Login',
              child: const Icon(Icons.apple),
            ), // This trailing comma makes auto-formatting nicer for build methods.
            Spacer(),
            FloatingActionButton(
              onPressed: () async => onClearFunction(),
              tooltip: 'Clear',
              child: const Icon(Icons.clear),
            ), // This trailing comma makes auto-formatting nicer for build methods.
            Spacer(),
            FloatingActionButton(
              onPressed: () async => onPressFunction(),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ],
        ),
      ),
    );
  }

  onSignFunction() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId: 'de.lunaone.flutter.signinwithappleexample.service',

        redirectUri:
            // For web your redirect URI needs to be the host of the "current page",
            // while for Android you will be using the API server that redirects back into your app via a deep link
            kIsWeb
                ? Uri.parse('https://google.com')
                : Uri.parse(
                    'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                  ),
      ),
      // TODO: Remove these if you have no need for them
      nonce: 'example-nonce',
      state: 'example-state',
    );

    print("credentialApple ${credential}");
  }

  onClearFunction() async {
    final ObjectBox objectBox = await getStore();
    await objectBox.clearList();
  }

  onPressFunction() async {
    print("FCM");
    var token = await PushNotificationService.getToken();
    print(token);
    final ObjectBox objectBox = await getStore();
    Stream<List<ModelNotification>> streamData =
        await objectBox.getAllNotification();

    Stream<ModelNotification> streamDataRow = await objectBox.getFirstId();
    List<ModelNotification> listModel = await streamData.first;
    // await objectBox.getAllNotification().first;
    if (listModel.isEmpty) {
      objectBox.putDemoData();
      return;
    }

    ModelNotification rowModel = await streamDataRow.first;
    ModelNotification rowFirst = listModel.last;
    int count = listModel.length + 1;

    String title = "${rowFirst.title} [{count}]";
    String detail = "${rowFirst.detail} [{count}]";
    title = title.replaceAll("{count}", "${count}");
    detail = detail.replaceAll("{count}", "${count}");
    DateTime date = DateTime.now();
    ModelNotification added = ModelNotification(
      title: title,
      detail: detail,
    );
    print(rowFirst.toJson());
    print(added.toJson());
    // result.forEach((element) {
    //   print("resultEach ${element}");
    // });
    print("rowModel = ${rowModel.toJson()}");
    // setState(() {
    await objectBox.addNotification(added);
    // });
  }
}
