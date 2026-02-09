import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

class RejectionDetailsBottomSheet extends StatelessWidget {
  RejectionDetailsBottomSheet({Key? key}) : super(key: key);

  final List<QuestionAnswerModel> _questionsAndAnswers = [
    QuestionAnswerModel(
        question: "Existing High Payment Obligations",
        answer:
            "Got a high credit balance outstanding to pay back? We would not want to burden you with more debts. This is to protect you from falling behind in debt repayments."),
    QuestionAnswerModel(
        question: "Unsatisfactory Bureau Report",
        answer:
            "Have you had problems paying back your loan amount on time in the past? Regardless of your reasons, such instances are recorded in the bureau report, lowering your credit score. And if it's less than our minimum requirement, your application won’t be approved."),
    QuestionAnswerModel(
        question: "Recent Personal Loans in your Name",
        answer:
            "Did you take any personal loans recently? If that is so, we would not want to over-leverage you with extra debts you might find difficult to repay on time")
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 35,
                    child: IconButton(
                      onPressed: () {
                        AppAnalytics.trackWebEngageEventWithAttribute(
                          eventName: WebEngageConstants.knowWhyClosed,
                        );
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: appBarTitleColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Why the loan was not approved?",
                  style: GoogleFonts.poppins(
                      color: darkBlueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 32,
                ),
                ...List.generate(_questionsAndAnswers.length,
                    (index) => _questionAnswer(_questionsAndAnswers[index])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _questionAnswer(QuestionAnswerModel questionAnswerModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionAnswerModel.question,
          style: const TextStyle(
              color: primaryDarkColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 11,
        ),
        Text(
          questionAnswerModel.answer,
          style: const TextStyle(
              color: accountSummaryTitleColor,
              fontSize: 10,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

class QuestionAnswerModel {
  String question;
  String answer;

  QuestionAnswerModel({required this.question, required this.answer});
}
