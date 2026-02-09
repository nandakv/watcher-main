import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/bank_name_not_found/bank_not_found_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../res.dart';
import '../../common_widgets/gradient_button.dart';
import '../../utils/no_leading_space_formatter.dart';

class BankNotFoundScreen extends StatelessWidget {
  BankNotFoundScreen({Key? key}) : super(key: key);
  final logic = Get.find<BankNotFoundLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
            child: Column(
              children: [
                _appBarWidget(),
                Expanded(child: _bodyWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return GetBuilder<BankNotFoundLogic>(builder: (logic) {
      switch (logic.screenState) {
        case BankNotFoundScreenStates.notFound:
          return _bankInputScreen();
        case BankNotFoundScreenStates.success:
          return _successScreen();
      }
    });
  }

  Widget _successScreen() {
    return Column(
      children: [
        const Spacer(flex: 2),
        _titleWidget("Thank you!"),
        const Spacer(),
        _messageWidget("We'll notify you when your bank is added to the list"),
        const Spacer(flex: 2),
        SvgPicture.asset(
          Res.autoPaySuccessSVG,
        ),
        const Spacer(flex: 6),
        _tryAnotherBankWidget(),
      ],
    );
  }

  Widget _bankInputScreen() {
    return Column(
      children: [
        const Spacer(flex: 2),
        _titleWidget("We are sorry, your bank is currently not listed"),
        const Spacer(),
        _messageWidget(
            "Do not worry, we will notify you when additional banks are added"),
        const Spacer(flex: 2),
        SvgPicture.asset(
          Res.bankNotFound,
        ),
        const Spacer(flex: 2),
        _addYourBankWidget(),
        const Spacer(flex: 6),
        _submitButton(),
      ],
    );
  }

  Widget _titleWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: navyBlueColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _messageWidget(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42.0),
      child: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: darkBlueColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Align _appBarWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: logic.onCloseIconClicked,
        icon: const Icon(Icons.close),
      ),
    );
  }

  Widget _tryAnotherBankWidget() {
    return InkWell(
      onTap: logic.onTryAnotherBank,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: Text(
          "Try with another bank",
          style: TextStyle(
            color: navyBlueColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GetBuilder<BankNotFoundLogic>(
          id: logic.SUBMIT_BUTTON_ID,
          builder: (context) {
            return GradientButton(
              enabled: logic.isSubmitButtonEnabled,
              onPressed: () {
                logic.bankNameNotFoundSubmitted();
              },
              title: "Submit",
              buttonTheme: AppButtonTheme.dark,
            );
          }),
    );
  }

  Widget _addYourBankWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add your bank name to our waitlist",
            style: _titleTextStyle(fontWeight: FontWeight.w500, size: 14),
            textAlign: TextAlign.center,
          ),
          const VerticalSpacer(8),
          _bankNameInputField(),
        ],
      ),
    );
  }

  Widget _bankNameInputField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      controller: logic.addBankNameController,
      textCapitalization: TextCapitalization.words,
      onChanged: logic.onTextFieldValueChanged,
      inputFormatters: [NoLeadingSpaceFormatter()],
      decoration: InputDecoration(
        labelText: "Enter the bank Name",
        contentPadding: EdgeInsets.zero,
        labelStyle: _labelTextStyle,
        hintText: "",
      ),
    );
  }

  TextStyle _titleTextStyle(
      {FontWeight fontWeight = FontWeight.w600, double size = 16}) {
    return TextStyle(
        color: const Color(0xff1D478E),
        fontWeight: fontWeight,
        letterSpacing: 0.22,
        fontSize: size,
        fontFamily: 'Figtree');
  }

  TextStyle get _labelTextStyle {
    return const TextStyle(
      color: secondaryDarkColor,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.22,
      fontSize: 14,
    );
  }
}
