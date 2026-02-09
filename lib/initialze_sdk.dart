import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/services/data_cloud_service.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import 'package:privo/app/services/sfmc_analytics.dart';
import 'package:privo/app/utils/native_channels.dart';
import 'package:privo/flavors.dart';
import 'package:privo/res.dart';
import 'package:sfmc/sfmc.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // PrivoPlatform.initializePlatformServices();
  try {
    await Firebase.initializeApp();

    SDKManager().onReceivePushNotification(
      message: message,
      configuration: NotificationConfiguration.configure(),
    );
  } catch (e) {
    Get.log("exception while notification, $e");
  }
}

Future<void> _initializeFirebaseApp() async {
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: F.envVariables.firebaseOptionsForIOS,
    );
  } else {
    await Firebase.initializeApp();
  }
}

class SDKManager {
  static Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();
      await Amplify.addPlugins([auth, storage]);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(F.envVariables.amplifyConfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  static initializeAllSDK() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: true,
      ),
    );
    await _preLoadSvg([Res.splashBackGround, Res.csIndiaLogo]);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    PrivoPlatform.initializePlatformServices();
    await _configureAmplify();
    await _initializeFirebaseApp();
    await SFMCAnalytics().init();
    if (Platform.isAndroid) {
      await NativeFunctions().initFacebookSDK();
    }
    AppAnalytics.initAppsFlyer();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await initNotifications();
    await PrivoPlatform.platformService.turnOnScreenProtection();
  }

  static Future<void> _preLoadSvg(List<String> assets) async {
    for (String asset in assets) {
      final loader = SvgAssetLoader(asset);
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }

  static initNotifications() async {
    await _initializeFirebaseApp();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.log("foreground notification received, ${message.data}");
      SDKManager().onReceivePushNotification(
        message: message,
        configuration: NotificationConfiguration.configure(),
      );
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification!;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     Get.dialog(AlertDialog(
    //       title: Text(notification.title!),
    //       content: SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [Text(notification.body!)],
    //         ),
    //       ),
    //     ));
    //   }
    // });
  }

  onReceivePushNotification({
    required RemoteMessage message,
    required NotificationConfiguration configuration,
  }) async {
    final flutterLocalNotificationsPlugin =
        configuration.flutterLocalNotificationsPlugin;
    final channel = configuration.channel;

    if (message.notification != null && message.notification?.android != null) {
      Get.log("Triggering local notification...");
      SDKManager.showBigPictureNotificationURL(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        notification: message.notification,
        androidNotification: message.notification!.android,
        channel: channel,
      );
    } else if (message.data['title'] != null && message.data['alert'] != null) {
      await flutterLocalNotificationsPlugin.show(
        0,
        message.data['title'],
        message.data['alert'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            icon: 'launcher_icon',
          ),
        ),
      );
    }
  }

  static Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  static Future<void> showBigPictureNotificationURL(
      {required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      required RemoteNotification? notification,
      required AndroidNotification? androidNotification,
      required AndroidNotificationChannel channel}) async {
    if (notification != null &&
        androidNotification != null &&
        androidNotification.imageUrl != null) {
      final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
          await _getByteArrayFromUrl(androidNotification.imageUrl!));
      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(bigPicture,
              contentTitle: notification.title,
              htmlFormatContentTitle: true,
              summaryText: notification.body,
              htmlFormatSummaryText: true);
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              styleInformation: bigPictureStyleInformation);
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
          0, notification.title, notification.body, platformChannelSpecifics);
    } else {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                icon: "launcher_icon",
                styleInformation: BigTextStyleInformation('')),
          ));
    }
  }

  static initializeTestSDK() async {
    Get.log('test sdk');

    await _initializeFirebaseApp();

    // try {
    //   await Amplify.addPlugins([
    //     AmplifyAuthCognito(),
    //   ]);
    //   await Amplify.configure(F.envVariables.amplifyConfig);
    // } on Exception catch (e) {
    //   Get.log("Amplify Already Configured");
    // }
  }
}

class NotificationConfiguration {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final AndroidNotificationChannel channel;

  NotificationConfiguration({
    required this.flutterLocalNotificationsPlugin,
    required this.channel,
  });

  factory NotificationConfiguration.configure() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'Credit Saison India Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.high,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');

    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iOSInitializationSettings,
    );

    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    return NotificationConfiguration(
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
      channel: channel,
    );
  }
}
