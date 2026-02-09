import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/info_bulb_widget.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_field_validator.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/penny_drop_choice_screen.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/widgets/bank_details_prefilled_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/bank_details/widgets/bank_name_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/forms/base_field_validator.dart';
import '../../../../common_widgets/gradient_button.dart';
import '../../../../common_widgets/privo_text_form_field/privo_text_form_field.dart';
import '../../../../utils/no_leading_space_formatter.dart';
import '../../mixins/app_form_mixin.dart';

class BankDetailsScreen extends StatefulWidget{
  const BankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen>
    with AfterLayoutMixin,BankDetailsFieldValidator  {
  final logic = Get.find<BankDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GetBuilder<BankDetailsLogic>(
        builder: (logic) {
          switch (logic.bankDetailsState) {
            case BankDetailsState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case BankDetailsState.form:
              return _bankDetailsFormWidget();
            case BankDetailsState.prefilled:
              return Column(
                children: [
                  Expanded(
                    child: BankDetailsPrefilledWidget(),
                  ),
                  // computeHelpWidget(),
                  configureContinueButton(logic),
                ],
              );
          }
        },
      ),
    );
  }

  Widget _bankDetailsFormWidget() {
    switch (logic.userSelectedPennyTestingType) {
      case PennyTestingType.reverse:
        return PennyDropChoiceScreen();
      default:
        return _bankDetailsScreen();
    }
  }

  Widget _bankDetailsScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: logic.bankDetailsFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OnboardingStepOfWidget(
                    title: "Bank Verification",
                  ),
                  verticalSpacer(9),
                  _secureText(),
                  verticalSpacer(30),
                  _bankNameSearchWidget(),
                  verticalSpacer(10),
                  accountNumberTextFormField(),
                  verticalSpacer(20),
                  confirmAccountNumberTextFormField(),
                  verticalSpacer(20),
                  ifscTextFormField(),
                  verticalSpacer(50),
                ],
              ),
            ),
          ),
        ),
        configureContinueButton(logic),
        verticalSpacer(20),
      ],
    );
  }

  Row _secureText() {
    return Row(
      children: [
        SvgPicture.asset(Res.green_shield_svg),
        const SizedBox(
          width: 10,
        ),
        const Expanded(
          child: Text(
            "Verify your bank account details for a secure deposit.",
            style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 10,
                height: 1.4,
                color: Color(0xff404040)),
          ),
        )
      ],
    );
  }

  Padding addBankDetailsAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            logic.computeBankDetailsHeading(),
            style: addBankDetailsTilteTextStyle(),
          ),
          InkWell(
            onTap: logic.computeOnBackPress,
            child: const Icon(
              Icons.close,
              color: Color(0xff151742),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle addBankDetailsTilteTextStyle() {
    return GoogleFonts.poppins(
        fontWeight: FontWeight.w500, fontSize: 16, color: navyBlueColor);
  }

  Widget helpWidget() {
    return const InfoBulbWidget(
      text:
          "If the bank details are incorrect, please contact your sales representative.",
    );
  }

  Widget configureContinueButton(BankDetailsLogic bankDetailsLogic) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: GradientButton(
        onPressed: () => bankDetailsLogic.onManualContinue(),
        enabled: logic.isBankDetailsFormFilled,
        isLoading: logic.isButtonLoading,
        title: logic.computeBankCtaTitle(),
      ),
    );
  }

  SizedBox verticalSpacer(double verticalHeight) {
    return SizedBox(
      height: verticalHeight,
    );
  }

  PrivoTextFormField confirmAccountNumberTextFormField() {
    return PrivoTextFormField(
      id: logic.CONFIRM_ACCOUNT_NUMBER_TEXT_FIELD_ID,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: logic.isConfirmAccountNumberFieldEnabled(),
      controller: logic.confirmAccController,
      autofocus: logic.bankDetailsState == BankDetailsState.prefilled,
      prefixSVGIcon: Res.confirmAccountNumberTFSvg,
      validator: (val) => confirmAccountNumberValidator(
          val, logic.bankDetailsState, logic.accountNumberController),
      onChanged: (value) => logic.bankDetailsOnChange(),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        NoLeadingSpaceFormatter()
      ],
      keyboardType: TextInputType.number,
      decoration: _accountNumberFieldInputDecoration(
        hintText: "e.g. 7123456789086",
        labelText: "Confirm Account Number",
      ),
    );
  }

  PrivoTextFormField accountNumberTextFormField() {
    return PrivoTextFormField(
      id: logic.ACCOUNT_NUMBER_TEXT_FIELD_ID,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: logic.isAccountNumberFieldEnabled(),
      controller: logic.accountNumberController,
      validator:
          accountNumberValidator,
      onChanged: (value) => logic.bankDetailsOnChange(),
      enableInteractiveSelection: false,
      focusNode: logic.accNumberFocusNode,
      prefixSVGIcon: Res.accountNumberTFSvg,
      obscureText: logic.showAccNo
          ? false
          : (logic.bankDetailsState != BankDetailsState.prefilled &&
              (logic.isHighTicketSize || logic.accountNumberMasked)),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        NoLeadingSpaceFormatter()
      ],
      keyboardType: TextInputType.number,
      obscuringCharacter: "x",
      decoration: _accountNumberFieldInputDecoration(
        hintText: "e.g. 7123456789086",
        labelText: "Account Number",
      ),
    );
  }

  Widget ifscTextFormField() {
    return GetBuilder<BankDetailsLogic>(
      id: logic.IFSC_FIELD_ID,
      builder: (logic) {
        return PrivoTextFormField(
          id: logic.IFSC_TEXT_FIELD_ID,
          enabled: logic.isIFSCFieldEnabled(),
          controller: logic.ifscNameController,
          validator: (value) {
            return validateIfscCode(value,
                userSelectedBank: logic.userSelectedBank,
                isIFSCMatching: logic.isIFSCMatching());
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) => logic.bankDetailsOnChange(),
          inputFormatters: [NoLeadingSpaceFormatter()],
          prefixSVGIcon: Res.ifscTFIconSVG,
          decoration: InputDecoration(
            errorMaxLines: 3,
            labelText: "IFSC",
            hintText: "e.g. SBIN0001132",
            errorText: logic.ifscErrorMessage,
          ),
        );
      },
    );
  }

  TextStyle _editTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w300,
      color: skyBlueColor,
      fontSize: 10,
      fontFamily: 'Figtree',
      decoration: TextDecoration.underline,
    );
  }

  TextStyle _bankTitleTextStyle() {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: secondaryDarkColor,
      fontFamily: 'Figtree',
    );
  }

  TextStyle _bankNameTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'Figtree',
      color: primaryDarkColor,
    );
  }

  InputDecoration _accountNumberFieldInputDecoration({
    required String labelText,
    required String hintText,
  }) {
    return InputDecoration(
      errorMaxLines: 3,
      labelText: labelText,
      hintText: hintText,
      // hintStyle: _hintTextStyle(),
      // labelStyle: _hintTextStyle(),
      // border: const UnderlineInputBorder(
      //   borderSide: BorderSide(
      //     color: Color(0xFF707070),
      //   ),
      // ),
    );
  }

  Widget _textFieldLabel(String lableText) {
    return RichText(
      text: TextSpan(
        text: lableText,
        style: _hintTextStyle(),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(
              color: Color(0xffEE3D4B),
              fontWeight: FontWeight.normal,
              letterSpacing: 0.16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }

  Widget _bankNameSearchWidget() {
    if (logic.bankNameController.text.isEmpty) {
      return BankNameSearchWidget();
    }
    return editBankNameOptionWidget();
  }

  Widget editBankNameOptionWidget() {
    return InkWell(
      onTap: logic.onTapBankNameWidget,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            logic.computeSelectText(),
            maxLines: 1,
            style: _bankTitleTextStyle(),
          ),
          Row(
            children: [
              Text(
                logic.bankNameController.text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: _bankNameTextStyle(),
              ),
              const SizedBox(
                width: 8,
              ),
              SvgPicture.asset(
                Res.sbdEditIconSVG,
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _hintTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.34,
      color: Color(0xff707070),
    );
  }

  TextStyle get _consentTextStyle {
    return GoogleFonts.montserrat(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.16,
        color: const Color(0xff363840));
  }

  TextStyle briTextStyle({FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        color: const Color(0xff161742),
        fontSize: 11,
        fontFamily: 'Figtree',
        letterSpacing: 0.16);
  }

  computeHelpWidget() {
    switch (logic.lpc) {
      case "UPL":
        return logic.isHighTicketSize ? helpWidget() : const SizedBox();
      case "SBL":
        return helpWidget();
      case "CLP":
        return const SizedBox();
    }
  }
}
