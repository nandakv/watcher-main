import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/page_swipe_indicator.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/faq/widget/faq_list_widget.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/voice_of_trust_model.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/documents_you_need_widget.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/know_more_top_widget.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import '../../../common_widgets/rich_text_widget.dart';
import '../../../models/rich_text_model.dart';

class KnowMoreScreen extends StatelessWidget {
  KnowMoreScreen({Key? key}) : super(key: key);

  final KnowMoreGetStartedLogic logic = Get.find<KnowMoreGetStartedLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _knowMoreTopWidget(),
                verticalSpacer(12),
                _knowMoreBottomWidget(),
              ],
            ),
          ),
        ),
        if (logic.isGetStartedCTAEnabled) _getStartedButton()
      ],
    );
  }

  Widget _getStartedButton() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: PrivoButton(
        onPressed: logic.onGetStartedTap,
        title: "Get Started",
      ),
    );
  }

  Widget _knowMoreBottomWidget() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        children: [
          _lpcInfoWidget(),
          verticalSpacer(36),
          _keyFeaturesWidget(),
          verticalSpacer(36),
          if (logic.isSBD) _documentsYouNeedWidget(),
          _voiceOfTrustWidget(),
          verticalSpacer(36),
          _faqs(),
        ],
      ),
    );
  }

  Widget _lpcInfoWidget() {
    switch (logic.lpc) {
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        return _businessPotentialInfoWidget();
      default:
        return _clpPottentialInfoWidget();
    }
  }

  Widget _clpPottentialInfoWidget() {
    return Column(
      children: [
        _subtitleWidget("Unlock Limitless Possibilities "),
        verticalSpacer(8),
        _contentTextWidget(
          "Privo offers instant, paperless credit with flexible access and you only pay interest on what you use",
        ),
      ],
    );
  }

  Widget _faqs() {
    return Column(
      children: [
        _subtitleWidget("Frequently Asked Questions"),
        verticalSpacer(16),
        FAQListWidget(
          faqModel: logic.computeFAQModel(),
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _voiceOfTrustWidget() {
    return Column(
      children: [
        _subtitleWidget("Voice of Trust"),
        verticalSpacer(8),
        _contentTextWidget(
            "Hear from those we have served. Our clients' voices echo the impact of our financial solutions"),
        verticalSpacer(24),
        _reviewsWidget(),
        verticalSpacer(12),
        GetBuilder<KnowMoreGetStartedLogic>(
            id: logic.voiceOfTrustId,
            builder: (logic) {
              return PageSwipeIndicator(
                currentIndex: logic.voiceOfTrustCarouselIndex,
                dotsCount: logic.voiceOfTrustList.length,
                activeColor: navyBlueColor,
                inactiveColor: navyBlueColor.withOpacity(0.2),
              );
            }),
      ],
    );
  }

  Widget _reviewsWidget() {
    return ExpandablePageView.builder(
      itemCount: logic.voiceOfTrustList.length,
      controller: logic.voiceOfTrustViewController,
      onPageChanged: (index) {
        logic.voiceOfTrustCarouselIndex = index.toDouble();
      },
      itemBuilder: (context, index) {
        return _voiceOfTrustTile(logic.voiceOfTrustList[index]);
      },
    );
  }

  Widget _voiceOfTrustTile(VoiceOfTrustModel voiceOfTrust) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GradientBorderContainer(
        borderRadius: 8,
        child: Container(
          height: 170,
          color: const Color(0xff5BC4F0).withOpacity(0.1),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                voiceOfTrust.review,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, color: darkBlueColor, height: 1.3),
              ),
              verticalSpacer(16),
              const Spacer(),
              Text(
                voiceOfTrust.name,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalSpacer(6),
              _starRating(voiceOfTrust.rating),
            ],
          ),
        ),
      ),
    );
  }

  Widget _starRating(int rating) {
    return Row(
      children: [
        for (int i = 0; i < rating; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SvgPicture.asset(Res.ratingStar),
          ),
      ],
    );
  }

  Widget _documentsYouNeedWidget() {
    return Column(
      children: [
        _subtitleWidget("Documents You Need"),
        verticalSpacer(16),
        DocumentsYouNeedWidget(),
        verticalSpacer(36),
      ],
    );
  }

  Widget _keyFeaturesWidget() {
    return Column(
      children: [
        _subtitleWidget("Key Features and Benefits"),
        verticalSpacer(16),
        Row(
          children: getKeyFeatures(),
        ),
      ],
    );
  }

  List<Widget> getKeyFeatures() {
    List<Widget> list = [];
    logic.keyFeatures.forEach((key, value) {
      list.add(_featureTile(iconPath: key, titleList: value));
    });
    return list;
  }

  Widget _featureTile(
      {required String iconPath, required List<RichTextModel> titleList}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            SvgPicture.asset(iconPath),
            verticalSpacer(6),
            RichTextWidget(
              textAlign: TextAlign.center,
              infoList: titleList,
            )
          ],
        ),
      ),
    );
  }

  Widget _businessPotentialInfoWidget() {
    return Column(
      children: [
        _subtitleWidget("Unlock Your Business Potential"),
        verticalSpacer(8),
        _contentTextWidget(
          "Introducing Credit Saison Small Business Loans. Our tailored financing solutions are designed to meet the unique needs of startups and small enterprises",
        ),
      ],
    );
  }

  Widget _knowMoreTopWidget() {
    return KnowMoreTopWidget(
      illustration: logic.knowMoreillustration,
      title: logic.title,
      message: logic.message,
      background: logic.knowMoreBackground,
    );
  }

  Widget _subtitleWidget(String subtitle) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: navyBlueColor,
          fontFamily: 'Figtree'),
    );
  }

  Widget _contentTextWidget(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, height: 1.4),
    );
  }
}
