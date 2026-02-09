import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:privo/res.dart';

import '../splash_screen_module/splash_screen_controller.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with AfterLayoutMixin {
  final logic = Get.find<SplashScreenController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(builder: (logic) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              left: logic.backgroundOffset.dx,
              top: logic.backgroundOffset.dy,
              child: Lottie.asset(
                Res.splashScreenLottieFile,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                onLoaded: (composition) =>
                    logic.onLottieLoaded(composition,context),
                repeat: false,
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    logic.initialCheck(context);
  }
}
