import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/modules/customer_feedback_widget/customer_feedback_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class RejectionFeedBackWidget extends StatelessWidget {
  final logic = Get.find<CustomerFeedbackLogic>();

  RejectionFeedBackWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(Res.feedback),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "Got thoughts to share?",
                  style: TextStyle(color: loanTextColor, fontSize: 14),
                ),
              ],
            ),
            InkWell(
                onTap: () => logic.onFeedbackSheetClosed(),
                child: SvgPicture.asset(Res.close_no_outline)),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: TextFormField(
            maxLines: 5,
            style: textStyle(),
            controller: logic.feedBackTextController,
            onChanged: (text) => logic.feedBackTextFieldOnChanged(),
            maxLength: 500,
            decoration: feedbackTextInputDecoration(),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        BlueButton(
          onPressed: () {
            logic.sendUserFeedBack();
          },
          title: 'Submit',
          buttonColor: logic.isFilled ? activeButtonColor : inactiveButtonColor,
          isLoading: logic.isLoading,
        ),
      ],
    );
  }

  TextStyle textStyle() {
    return const TextStyle(
      fontSize: 12,
      color: accountSummaryTitleColor,
    );
  }

  InputDecoration feedbackTextInputDecoration() {
    return const InputDecoration(
        border: InputBorder.none,
        hintText: "Let us know here...",
        hintStyle: TextStyle(
          fontSize: 12,
          color: accountSummaryTitleColor,
        ));
  }
}
