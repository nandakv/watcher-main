import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/app_button.dart';
import 'package:privo/app/common_widgets/blue_background.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/terms_and_conditions_text.dart';
import 'package:privo/app/modules/app_permissions/widgets/referral_welcome_screen.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_permissions_logic.dart';
import 'widgets/permission_item_widget.dart';

class AppPermissionsPage extends StatefulWidget {
  const AppPermissionsPage({Key? key}) : super(key: key);

  @override
  State<AppPermissionsPage> createState() => _AppPermissionsPageState();
}

class _AppPermissionsPageState extends State<AppPermissionsPage>
    with WidgetsBindingObserver, AfterLayoutMixin {
  final logic = Get.find<AppPermissionsLogic>();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    Get.log("lifecycle state - $state");
    switch (state) {
      case AppLifecycleState.resumed:
        if (logic.settingsDialogShown) {
          logic.requestPermission();
          logic.settingsDialogShown = false;
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppPermissionsLogic>(builder: (logic) {
      return Scaffold(
        body: logic.showWelcomeScreen ? ReferralWelcomeScreen() : Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            _grantPermissions(),
            const SizedBox(height: 20),
            _dataSafety(),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (Platform.isAndroid) ...[
                        const PermissionItem(
                          iconPath: Res.sms,
                          permissionTitle: "SMS",
                          isMandatory: false,
                          description:
                          "With your consent, our app collects, stores, and transmits financial transaction messages to our servers. We only access messages from alphanumeric senders and use this data solely to underwrite your loan application. We do not collect or store personal SMS",
                        ),
                        const SizedBox(height: 20),
                      ],
                      PermissionItem(
                        iconPath: Res.location,
                        permissionTitle: "Location",
                        isMandatory: true,
                        description: PrivoPlatform.platformService
                            .getLocationPermissionDescription(),
                      ),
                      const SizedBox(height: 20),
                      const PermissionItem(
                        iconPath: Res.filesAndMedia,
                        permissionTitle: "File and Media",
                        isMandatory: true,
                        description:
                        "We may access your files and media for you to upload documents for onboarding, KYC, and lending services.",
                      ),
                      const SizedBox(height: 20),
                      PermissionItem(
                        iconPath: Res.camera,
                        permissionTitle: "Camera",
                        isMandatory: true,
                        description: PrivoPlatform.platformService
                            .getCameraPermissionDescription(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const TermsAndConditionsText(),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GetBuilder<AppPermissionsLogic>(
                  id: 'bt',
                  builder: (logic) {
                    return GradientButton(
                      onPressed: logic.requestPermission,
                      isLoading: logic.isLoading,
                      title: "Accept",
                      titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      buttonTheme: AppButtonTheme.dark,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }

  Padding _grantPermissions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        "Grant permissions",
        style: GoogleFonts.poppins(
          color: darkBlueColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.14,
        ),
      ),
    );
  }

  SizedBox _dataSafety() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Res.dataSafety),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                          text: "Don’t worry, your data is 100% safe\n",
                          style: TextStyle(
                              fontSize: 10,
                              color: navyBlueColor,
                              fontWeight: FontWeight.w600)),
                      WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "We require these permissions one-time to enable a seamless experience for you",
                              style: TextStyle(
                                  color: darkBlueColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.16),
                            ),
                          )),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: SvgPicture.asset(
                Res.dataSafetyBackground,
                fit: BoxFit.fitWidth,
              )),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }
}
