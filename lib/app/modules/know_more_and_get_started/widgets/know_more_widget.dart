import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/faq/faq_model.dart';
import 'package:privo/app/modules/faq/widget/faq_list_widget.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_helper.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/know_more_top_widget.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../res.dart';
import '../../fin_sights/fin_sights_logic.dart';

class KnowMoreWidget extends StatelessWidget {
  final KnowMoreHelper knowMoreHelper;

  const KnowMoreWidget({super.key, required this.knowMoreHelper});

  Widget _appbar() {
    return Container(
      color: skyBlueColor.withOpacity(0.1),
      child: Row(
        children: [
          if (knowMoreHelper.backButton != null)
            knowMoreHelper.backButton!
          else
            IconButton(
              onPressed: () => knowMoreHelper.onKnowMoreBackPressed(),
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: appBarTitleColor,
              ),
            ),
          Text(
            knowMoreHelper.knowMoreAppBarTitle,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: navyBlueColor,
            ),
          ),
          const Spacer(),
          if (knowMoreHelper.closeButton != null)
            knowMoreHelper.closeButton!
          else
            IconButton(
              onPressed: () => knowMoreHelper.onClosePressed(),
              icon: SvgPicture.asset(Res.close_mark_svg),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _appbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _knowMoreTopWidget(),
                  _knowMoreBottomWidget(),
                ],
              ),
            ),
          ),
          _bottomStickyWidget(),
        ],
      ),
    );
  }

  Widget _bottomStickyWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 32,
        right: 32,
        bottom: 16,
      ),
      child: Column(
        children: [
          knowMoreHelper.consentWidget,
          _buttonWidget(),
          knowMoreHelper.poweredByWidget,
          const VerticalSpacer(12),
        ],
      ),
    );
  }

  Widget _buttonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 6),
      child: knowMoreHelper.knowMoreButton,
    );
  }

  Widget _knowMoreBottomWidget() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          knowMoreHelper.knowMoreBody,
          if (knowMoreHelper.knowMoreFaqModel != null) _faqs(),
        ],
      ),
    );
  }

  Widget _knowMoreTopWidget() {
    return KnowMoreTopWidget(
      illustration: knowMoreHelper.knowMoreIllustration,
      title: knowMoreHelper.knowMoreTitle,
      message: knowMoreHelper.knowMoreMessage,
      background: knowMoreHelper.knowMoreBackground,
    );
  }

  Widget _subtitleWidget(String subtitle) {
    return Text(
      subtitle,
      style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: navyBlueColor,
          fontFamily: 'Figtree'),
    );
  }

  Widget _faqs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subtitleWidget("Frequently Asked Questions"),
        const VerticalSpacer(16),
        FAQListWidget(
          faqModel: knowMoreHelper.knowMoreFaqModel!,
          shrinkWrap: true,
        ),
      ],
    );
  }
}
