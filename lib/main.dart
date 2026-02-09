import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/splash_screen_module/splash_screen_bindings.dart';
import 'package:privo/app/modules/splash_screen_module/splash_screen_page.dart';
import 'package:privo/app/routes/app_pages.dart';

import 'package:privo/app/theme/app_theme.dart';

import 'flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: false,
      designSize: Size(360, 800 + MediaQuery.viewPaddingOf(context).top),
      ensureScreenSize: true,
      enableScaleWH: () => true,
      minTextAdapt: true,
      child: SafeArea(
        bottom: true,
        top: false,
        child: GetMaterialApp(
          defaultGlobalState: true,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'IN'),
          ],
          unknownRoute: GetPage(
            name: Routes.SPLASH_SCREEN,
            page: () => const SplashScreenPage(),
            binding: SplashScreenBinding(),
          ),
          color: Colors.white,
          locale: const Locale('en'),
          title: 'Credit Saison IN',
          theme: appThemeData,
          initialRoute: Routes.SPLASH_SCREEN,
          getPages: AppPages.pages,
          navigatorObservers: [
            if (F.appFlavor == Flavor.prod)
              DatadogNavigationObserver(
                datadogSdk: DatadogSdk.instance,
              ),
            FirebaseAnalyticsObserver(analytics: AppAnalytics.analytics),
          ],
        ),
      ),
    );
  }
}
