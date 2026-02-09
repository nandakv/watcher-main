import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/skip_bottom_sheet.dart';
import 'package:privo/app/common_widgets/failure_page.dart';
import 'package:privo/app/modules/on_boarding/widgets/otp_udyam_screen/otp_udyam_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/otp_udyam_screen/udyam_validator.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/common_text_fields/text_field_decoration.dart';
import '../../../../../common_widgets/gradient_button.dart';
import '../../../../../common_widgets/privo_text_form_field/privo_text_form_field.dart';
import '../../../../../common_widgets/rich_text_widget.dart';
import '../../../../../common_widgets/spacer_widgets.dart';
import '../../../../../common_widgets/vertical_spacer.dart';
import '../../../../../firebase/analytics.dart';
import '../../../../../models/rich_text_model.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../utils/web_engage_constant.dart';
import '../../../../authentication/sign_in_screen/widget/sign_in_field_validator.dart';
import '../../../../polling/polling_screen.dart';
import '../../consent_check/consent_check.dart';

class UdyamScreen extends StatefulWidget {
  const UdyamScreen({super.key});

  @override
  State<UdyamScreen> createState() => _UdyamScreenState();
}

class _UdyamScreenState extends State<UdyamScreen>
    with AfterLayoutMixin, UdyamValidator, SignInFieldValidator {
  final otpUdyamLogic = Get.find<OtpUdyamLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<OtpUdyamLogic>(builder: (logic) {
          return Container(
              color: Colors.white, child: _bodyWidget(otpUdyamLogic));
        }),
      ),
    );
  }

  Widget _bodyWidget(OtpUdyamLogic otpUdyamLogic) {
    switch (otpUdyamLogic.udyamState) {
      case UdyamState.udyamScreen:
        return _udyamDetailsWidget();
      case UdyamState.loading:
        return _loadingWidget();
      case UdyamState.success:
        return _successWidget();
      case UdyamState.failure:
        return _failureScreen();
    }
  }

  Column _loadingWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: CircularProgressIndicator())],
    );
  }

  Column _successWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PollingScreen(
            bodyTexts: const ["We have fetched your Udyam details"],
            titleLines: const ["Successful"],
            assetImagePath: Res.kycSuccessfull,
            bodyTextStyle: _bodyTextStyle(),
            isV2: true,
            isClosedEnable: false,
            replaceProgressWidget: Container(),
          ),
        )
      ],
    );
  }

  Column _udyamDetailsWidget() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpacer(20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    child: Text(
                      "Provide Udyam Details",
                      style: GoogleFonts.poppins(
                        color: darkBlueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _subTitleText(),
                  const SizedBox(
                    height: 30,
                  ),
                  SvgPicture.asset(
                    Res.udyamCertificate,
                  ),
                  _udyamNumberTextField(),
                  verticalSpacer(40),
                  _mobileTextField(),
                  verticalSpacer(4),
                  _inlineOtpText(),
                ],
              ),
            ),
          ),
        ),
        _checkBoxWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GetBuilder<OtpUdyamLogic>(
              id: 'button',
              builder: (logic) {
                return GradientButton(
                    isLoading: logic.isButtonLoading,
                    title: "Get OTP",
                    enabled: logic.getOtpButtonEnable(),
                    onPressed: () {
                      logic.getOtpClicked();
                    });
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: GetBuilder<OtpUdyamLogic>(
              id: 'skip',
              builder: (logic) {
                return InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      BottomSheetWidget(
                        child: SkipBottomSheet(
                          title: "Are you sure?",
                          subTitle:
                              "You may be asked to provide Udyam document manually later",
                          onTapSkipYes:()=> logic.onSkipUdyam(isSkipBottomSheet: true),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Skip Now",
                    style: TextStyle(
                        color: appBarTitleColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Figtree'),
                  ),
                );
              }),
        ),
        verticalSpacer(20)
      ],
    );
  }

  Widget _udyamNumberTextField() {
    return PrivoTextFormField(
      id: otpUdyamLogic.UDYAM_FIELD_ID,
      maxLength: 20,
      controller: otpUdyamLogic.udyamController,
      prefixSVGIcon: Res.pdPan,
      readOnly: otpUdyamLogic.readOnly,
      onChanged: (_) => otpUdyamLogic.ctaButtonEnable(),
      textCapitalization: TextCapitalization.characters,
      decoration: _udyamNumberTextFieldDecoration(),
      validator: udyamNumberValidation,
    );
  }

  Widget _mobileTextField() {
    return PrivoTextFormField(
      id: otpUdyamLogic.MOBILE_FIELD_ID,
      controller: otpUdyamLogic.mobileNumberController,
      prefixSVGIcon: Res.phoneIconTFSVG,
      maxLength: 10,
      //  enabled: !otpUdyamLogic.isButtonLoading,
      onChanged: (_) {
        if (otpUdyamLogic.mobileNumberController.text.length > 9) {
          FocusScope.of(context).unfocus();
          udyamPhoneNumberEvent();
        }
        otpUdyamLogic.ctaButtonEnable();
      },
      validator: validateMobileNumber,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: _mobileTextFieldDecoration(),
    );
  }

  void udyamPhoneNumberEvent() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.phoneNumberEntered,
        attributeName: {
          "Phone_Number": otpUdyamLogic.mobileNumberController.text
        });
  }

  InputDecoration _mobileTextFieldDecoration() {
    return textFieldDecoration(
      counterWidget: const SizedBox.shrink(),
      label: "Mobile Number",
      prefix: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '+91 ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryDarkColor,
          ),
        ),
      ),
    );
  }

  InputDecoration _udyamNumberTextFieldDecoration() {
    return textFieldDecoration(
      label: "Udyam Registration Number",
      counterWidget: const SizedBox(),
    );
  }

  GetBuilder<OtpUdyamLogic> _checkBoxWidget() {
    return GetBuilder<OtpUdyamLogic>(
        id: 'checkBox',
        builder: (logic) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: CheckBoxWithText(
                value: logic.consentCheckBoxValue,
                onChanged: (value) {
                  if (value != null) {
                    logic.consentCheckBoxValue = value;
                    logic.checkBoxEvent(value);
                  }
                },
                consentText:
                    "I hereby give consent to Kisetsu Saison Finance (India) Pvt Ltd to fetch my complete Udyam certificate from the issuing authority for the purpose of processing my loan application."),
          );
        });
  }

  TextStyle _bodyTextStyle() {
    return const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
        fontFamily: 'Figtree');
  }

  Row _subTitleText() {
    return Row(
      children: [
        SvgPicture.asset(Res.green_shield_svg),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            "Your data is 100% safe and encrypted",
            style: _subTitleTextStyle(),
          ),
        )
      ],
    );
  }

  TextStyle _subTitleTextStyle() {
    return const TextStyle(
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
        fontSize: 10,
        letterSpacing: 0.16,
        fontFamily: 'Figtree');
  }

  Widget _failureScreen() {
    return FailurePage(
      title: "Something Went Wrong!",
      message:
          "Looks like there was an issue fetching your details. Please try again",
      illustration: Res.aaFailure,
      ctaTitle: "Try Again",
      onCtaClicked: () {
        otpUdyamLogic.udyamState = UdyamState.loading;
        otpUdyamLogic.afterLayout();
      },
      isSkip: true,
      onSkipClicked: otpUdyamLogic.onSkipUdyam,
    );
  }

  Widget _inlineOtpText() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.0),
        child: RichTextWidget(infoList: [
          RichTextModel(
            text: "Enter the number linked to your ",
            textStyle: const TextStyle(
                fontSize: 10,
                color: secondaryDarkColor,
                fontWeight: FontWeight.w400),
          ),
          RichTextModel(
            text: "Udyam",
            textStyle: const TextStyle(
                fontSize: 10,
                color: secondaryDarkColor,
                fontWeight: FontWeight.w600),
          )
        ]));
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    return otpUdyamLogic.afterLayout();
  }
}
