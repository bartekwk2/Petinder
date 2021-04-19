import 'dart:io';
import 'package:Petinder/di/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'chat/messages_income_bloc.dart';
import 'notification.dart';

class FirebaseMyMessages extends StatefulWidget {
  final Widget child;

  FirebaseMyMessages({this.child});
  @override
  _FirebaseMyMessagessState createState() => _FirebaseMyMessagessState();
}

class _FirebaseMyMessagessState extends State<FirebaseMyMessages> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String token;
  Box chatBox;
  NotificationPlugin notification = NotificationPlugin();
  bool isFirstTime = true;

  @override
  void initState() {
    Hive.openBox("Chat").then((value) {
      chatBox = value;
      chatBox.put("isOpen", false);
    });

    Hive.openBox("IsLogin").then((value) {
      value.watch()
        ..listen((event) {
          if (isFirstTime) {
            initFcm();
            isFirstTime = false;
          }
        });
    });
    super.initState();
  }

  void initFcm() {
    subscribeToEvent();
    configureCallbacks();
    saveToken();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void configureCallbacks() {
    _fcm.configure(
      onMessage: (message) async {
        handleMessage(message);
      },
      onResume: (message) async {
        handleMessage(message);
      },
      onLaunch: (message) async {
        handleMessage(message);
      },
    );
  }

  void handleMessage(Map<String, dynamic> message) {
    var title = message["notification"]["title"];
    var body = message["notification"]["body"];
    var isOpen = chatBox.get("isOpen");
    if (!isOpen) {
      notification.showNotification(title, body);
    }
    inject<NotificationsBloc>().newNotification(true);
  }

  void subscribeToEvent() {
    _fcm.subscribeToTopic((Hive.box("IsLogin").get("id")));
  }

  void saveToken() {
    if (Platform.isIOS) checkforIosPermission();
    _fcm.getToken().then((value) async {
      await secureStorage.write(key: 'fcmToken', value: value);
      print("TOKEN" + value);
    });
  }

  void getToken() async {
    token = await secureStorage.read(key: "token");
    print(token);
  }

  void checkforIosPermission() async {
    await _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
