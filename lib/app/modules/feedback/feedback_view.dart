import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/modules/customer_feedback_widget/widgets/rejection_feedback_widget.dart';
import 'package:privo/app/modules/on_boarding/model/privo_app_bar_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import 'feedback_logic.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({Key? key}) : super(key: key);

  final logic = Get.find<FeedbackLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrivoAppBar(
              model: PrivoAppBarModel(
                title: "",
                progress: 0,
                isAppBarVisible: true,
                isTitleVisible: false,
                appBarText: "Feedback",
              ),
            ),
            FeedBackWidget()
          ],
        ),
      ),
    );
  }
}

class FeedBackWidget extends StatelessWidget {
  final logic = Get.find<FeedbackLogic>();
  String feedBackTitle;

  FeedBackWidget(
      {Key? key,
      this.feedBackTitle =
          "Feel free to share your thoughts with our team"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return feedBackWidget();
  }

  Widget feedBackWidget() {
    return GetBuilder<FeedbackLogic>(builder: (logic) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 33),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedBackTitle,
              style: GoogleFonts.poppins(
                  color: appBarTitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            _feedBackTextWidget(logic),
            const SizedBox(
              height: 30,
            ),
            GradientButton(
              onPressed: () {
                logic.sendUserFeedBack();
              },
              title: 'Submit',
              buttonTheme: AppButtonTheme.dark,
              enabled: logic.isFilled,
              isLoading: logic.isLoading,
            ),
          ],
        ),
      );
    });
  }

  TextFormField _feedBackTextWidget(FeedbackLogic logic) {
    return TextFormField(
      maxLines: 5,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: logic.validateReason,
      style: textStyle(),
      enabled: !logic.isLoading,
      controller: logic.feedBackTextController,
      onChanged: (text) => logic.feedBackTextFieldOnChanged(),
      maxLength: 200,
      decoration: feedbackTextInputDecoration(logic),
    );
  }

  InputDecoration feedbackTextInputDecoration(FeedbackLogic logic) {
    return InputDecoration(
        border: logic.borderStyle,
        enabledBorder: logic.borderStyle,
        focusedErrorBorder: logic.borderStyle,
        errorBorder: logic.borderStyle,
        focusedBorder: logic.borderStyle,
        hintText: "I think we can be better",
        hintStyle: const TextStyle(
          fontSize: 12,
          color: accountSummaryTitleColor,
        ));
  }

  TextStyle textStyle() {
    return const TextStyle(
      fontSize: 12,
      color: accountSummaryTitleColor,
    );
  }
}
