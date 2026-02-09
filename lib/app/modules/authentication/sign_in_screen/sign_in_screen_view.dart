import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/model/lpc_info_model.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/sign_in_screen_logic.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/rich_text_consent_checkbox.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/otp_text_field.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/our_legacy_widget.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/widget/sign_in_bottom_sheet.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../res.dart';
import '../../../common_widgets/gradient_button.dart';
import '../../../common_widgets/otp_resend_widget/otp_resend_widget_view.dart';

class SignInScreenView extends StatefulWidget {
  SignInScreenView({Key? key}) : super(key: key);

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView>
    with SingleTickerProviderStateMixin {
  final logic = Get.find<SignInScreenLogic>();

  @override
  void initState() {
    logic.initAnimationControllers(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onBackPress,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<SignInScreenLogic>(
            builder: (logic) {
              return _signIn(logic);
            },
          ),
        ),
      ),
    );
  }

  Padding _signIn(SignInScreenLogic logic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  verticalSpacer(48),
                  _enablingIndiaTitle(),
                  _subTitle(),
                  verticalSpacer(54),
                  _animatedImage(logic),
                  OurLegacyWidget(),
                  verticalSpacer(14)
                ],
              ),
            ),
          ),
          verticalSpacer(10),
          _rbiRegulatedNbfc(),
          _button()
        ],
      ),
    );
  }

  Widget _animatedImage(SignInScreenLogic logic) {
    if (logic.animationController != null && logic.animation != null) {
      return GetBuilder<SignInScreenLogic>(
        id: logic.ANIMATED_IMAGES_ID,
        builder: (logic) {
          LpcInfoModel lpcInfoModel =
              logic.introImages[logic.currentIntroImageIndex];
          return AnimatedBuilder(
            animation: logic.animationController!,
            builder: (context, child) {
              return Opacity(
                opacity: logic.animation!.value,
                child: _imageAndTextWidget(lpcInfoModel),
              );
            },
          );
        },
      );
    }
    return _imageAndTextWidget(logic.introImages.first);
  }

  Column _imageAndTextWidget(LpcInfoModel lpcInfoModel) {
    return Column(
      children: [
        SvgPicture.asset(
          lpcInfoModel.image,
          height: 200,
        ),
        verticalSpacer(16),
        Text(
          lpcInfoModel.title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: darkBlueColor),
        ),
        Text(
          lpcInfoModel.message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: secondaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Text _subTitle() {
    return const Text(
      "by offering innovative financial solutions to individuals, businesses and more",
      style: TextStyle(
          color: primaryDarkColor, fontSize: 14, fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    );
  }

  Padding _enablingIndiaTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        "Enabling India’s \n Growth Story",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: darkBlueColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding _button() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GradientButton(
        onPressed: logic.onGetStartedClicked,
        title: "Get Started",
        bottomPadding: 0,
      ),
    );
  }

  Widget _rbiRegulatedNbfc() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Res.checkCircle),
        const SizedBox(
          width: 8,
        ),
        const Text(
          "RBI",
          style: TextStyle(
              color: darkBlueColor, fontWeight: FontWeight.w700, fontSize: 12),
        ),
        const Text(
          " Regulated NBFC",
          style: TextStyle(
              color: darkBlueColor, fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ],
    );
  }
}
