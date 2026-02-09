import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/faq_help_support/faq_help_support_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';

class FaqDetailsWidget extends StatelessWidget {
  final String question;
  final String answer;
  final bool allowRequestForDeletion;
  final void Function()? onTap;

  FaqDetailsWidget(
      {required this.question,
      required this.answer,
      required this.onTap,
      this.allowRequestForDeletion = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _question(),
        verticalSpacer(10),
        _answer(),
        verticalSpacer(40),
        _wasThisFaqHelpful(),
        const Spacer(),
        if (allowRequestForDeletion) _requestForDeletion()
      ],
    );
  }

  Widget _requestForDeletion() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Request for deletion ",
                style: _deletionTextStyle(),
              ),
              SvgPicture.asset(Res.deleteArrow)
            ],
          ),
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

  Column _wasThisFaqHelpful() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Was this answer helpful?",
          style: TextStyle(
              color: darkBlueColor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 20,
        ),
        _likeAndDislike(),
      ],
    );
  }

  Row _likeAndDislike() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap: _onDislikeTapped,
            child: SvgPicture.asset(Res.roundedDisLikeIcon)),
        const SizedBox(
          width: 16,
        ),
        InkWell(
            onTap: _onLikeTapped, child: SvgPicture.asset(Res.roundedLikeIcon))
      ],
    );
  }

  void _onDislikeTapped() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.wasThisAnswerHelpFullDisLiked,
        attributeName: {'question': question});
  }

  void _onLikeTapped() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.wasThisAnswerHelpFullLiked,
        attributeName: {'question': question});
  }

  Widget _question() {
    return Text(
      question,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryDarkColor,
      ),
    );
  }

  Widget _answer() {
    return Text(
      answer,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryDarkColor,
        height: 1.6,
      ),
    );
  }
}
