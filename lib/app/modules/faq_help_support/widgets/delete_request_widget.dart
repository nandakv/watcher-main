import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/faq_help_support/faq_help_support_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class DeleteRequestWidget extends StatelessWidget {

  final helpSupportLogic = Get.find<FAQHelpSupportLogic>();

  DeleteRequestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Expanded(
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               _title(),
               verticalSpacer(10),
               _subTitle(),
               verticalSpacer(10),
               // _provideFeedback(),
               // verticalSpacer(30),
               _reasonForDeletion(),
               verticalSpacer(20),
               _reasonDescription(),
             ],
           ),
         ),
       ),
        _submitButton(),
        verticalSpacer(10),
        _cancel(),
        verticalSpacer(20),
      ],
    );
  }

  GradientButton _submitButton() {
    return GradientButton(
        onPressed: helpSupportLogic.onAccountDeletionSubmitPressed,
        title: "Submit",
        isLoading: helpSupportLogic.isLoading,
        enabled: helpSupportLogic.isEnabled,
        buttonTheme: AppButtonTheme.dark,
      );
  }

  Widget _cancel() {
    return Center(
      child: InkWell(
        onTap: helpSupportLogic.onAccountDeletionCancelClicked,
        child: const Text("Cancel",
            style: TextStyle(
              color: darkBlueColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }

  Container _reasonDescription() {
    return Container(
      decoration: _reasonContainerDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        maxLines: 5,
        maxLength: 200,
        controller: helpSupportLogic.reasonDescriptionController,
        decoration: _reasonDescriptionDecoration(),
      ),
    );
  }

  BoxDecoration _reasonContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: darkBlueColor,
      ),
    );
  }

  InputDecoration _reasonDescriptionDecoration() {
    return const InputDecoration(
        hintText: "Describe here",
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: secondaryDarkColor,
            fontSize: 12,
            fontWeight: FontWeight.w400));
  }

  TextFormField _reasonForDeletion() {
    return TextFormField(
      controller: helpSupportLogic.reasonController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: helpSupportLogic.validateReason,
      readOnly: true,
      onTap: helpSupportLogic.onTapReasonField,
      decoration: _purposeInputDecoration(),
    );
  }

  Text _title() {
    return Text(
      "Sorry to see you go!",
      style: GoogleFonts.poppins(
        color: darkBlueColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Text _subTitle() {
    return const Text(
      "Is there anything we can do to improve your experience? We'd love to hear your feedback!",
      style: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 12, color: darkBlueColor),
    );
  }

  Widget _provideFeedback() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: helpSupportLogic.onRequestForDeletionClicked,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Provide feedback  ",
              style: _deletionTextStyle(),
            ),
            SvgPicture.asset(Res.deleteArrow)
          ],
        ),
      ),
    );
  }

  TextStyle _deletionTextStyle() {
    return const TextStyle(
        decoration: TextDecoration.underline,
        color: Color(0xFF5BC4F0),
        fontSize: 12,
        fontWeight: FontWeight.w500);
  }

  InputDecoration _purposeInputDecoration() {
    return InputDecoration(
        isDense: true,
        label: RichText(
          text: TextSpan(
            text: 'Reason for deletion',
            style: _labelTextStyle,
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(
                  color: Color(0xffEE3D4B),
                ),
              ),
            ],
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
          child: RotatedBox(
            quarterTurns: 3,
            child: SvgPicture.asset(
              Res.chevron_down_svg,
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          maxWidth: 32,
        ),
        alignLabelWithHint: true,
        labelStyle: _labelTextStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.5,
            color: primaryDarkColor,
          ),
        ));
  }

  TextStyle get _labelTextStyle => const TextStyle(
        fontSize: 14,
        letterSpacing: 0.22,
        fontFamily: 'Figtree',
        color: Color(0xff404040),
        fontWeight: FontWeight.w400,
      );
}
