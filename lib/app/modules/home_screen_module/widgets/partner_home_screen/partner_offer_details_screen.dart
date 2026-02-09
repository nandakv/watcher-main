import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/faq/faq_page.dart';
import 'package:privo/app/modules/faq/faq_utility.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../res.dart';
import '../../../on_boarding/model/privo_app_bar_model.dart';
import '../../../on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import '../../home_screen_logic.dart';
import '../home_page_top_widget.dart';

class PartnerOfferDetailsScreen extends StatelessWidget {
  PartnerOfferDetailsScreen({
    Key? key,
  }) : super(key: key);
  get logic => Get.find<HomeScreenLogic>();

  final String limitAmount = Get.arguments['limitAmount'] ?? "";

  final List<String> howToAvailOffer = [
    "Verify information: Provide accurate details to complete credit evaluation and receive a suitable offer up to your pre-approved limit.",
    "Verify identity: Complete KYC for enhanced security.",
    "Link bank account: Connect for easy fund transfers and set up auto-pay.",
    "Withdraw funds: Access money conveniently whenever needed.",
  ];

  Text _titleText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xff1D478E),
          letterSpacing: 0.58,
          fontWeight: FontWeight.w500),
    );
  }

  Text _bodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.08,
        height: 1.4,
        color: Color(0xff404040),
        fontFamily: 'Figtree',
      ),
    );
  }

  Widget _limitAmountText() {
    return Text(
      "₹ $limitAmount",
      style: GoogleFonts.poppins(
          fontSize: 40,
          color: Colors.white,
          letterSpacing: 0.58,
          fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PrivoAppBar(
              lpcCard: LPCService.instance.activeCard,
              showFAQ: true,
              model: PrivoAppBarModel(
                title: "",
                progress: 0,
                isAppBarVisible: true,
                isTitleVisible: false,
                appBarText: "Offer details",
              ),
            ),
            _topBannerWidget(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _aboutThisOfferWidget(),
                  const SizedBox(
                    height: 12,
                  ),
                  _howToAvailOfferWidget(),
                ],
              ),
            ),
            const Spacer(),
            _faqButton(),
            const SizedBox(
              height: 28,
            ),
            _getStartedButton(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBannerWidget() {
    return HomeScreenTopWidget(
      scaffoldKey: logic.homePageScaffoldKey,
      infoText: "",
      showHamburger: false,
      background: Res.withdrawal_pattern,
      widget: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _offerInfoText(),
            const SizedBox(
              height: 12,
            ),
            _limitAmountText(),
            const SizedBox(
              height: 26,
            ),
            _tncText(),
          ],
        ),
      ),
    );
  }

  Widget _offerInfoText() {
    return const Padding(
      padding: EdgeInsets.only(right: 40.0),
      child: Text(
        "Get instant money in your account with a pre-approved Credit Line of up to",
        style: TextStyle(
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.08,
          color: Color(0xffFFF3EB),
          fontFamily: 'Figtree',
        ),
      ),
    );
  }

  Widget _tncText() {
    return const Text(
      "*T&C Apply",
      style: TextStyle(
        fontSize: 6,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.08,
        color: Color(0xffFFF3EB),
        fontFamily: 'Figtree',
      ),
    );
  }

  Widget _howToAvailOfferWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText(
          "How to avail this offer",
        ),
        const SizedBox(
          height: 6,
        ),
        _bodyText("To avail this offer, follow these 4 steps:"),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: howToAvailOffer.length,
          itemBuilder: (context, index) {
            {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bodyText("  ${index + 1}. "),
                  Expanded(child: _bodyText(howToAvailOffer[index]))
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _aboutThisOfferWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText(
          "About this offer",
        ),
        const SizedBox(
          height: 6,
        ),
        _bodyText(
            "Our \"Pre-Approved Credit Line,\" in collaboration with our esteemed partner, is a tailored solution for new customers. It offers instant access to funds, revolving credit, no foreclosure fees, and flexible repayment options. Experience the convenience and flexibility of your Pre-Approved Credit Line by getting started today!"),
      ],
    );
  }

  Widget _getStartedButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: GradientButton(
        onPressed: () {
          Get.back();
          logic.computeUserStateAndNavigate();
        },
        title: "Get Started",
      ),
    );
  }

  Widget _faqButton() {
    return InkWell(
      onTap: () {
        Get.to(
          () => FAQPage(
            faqModel: FAQUtility().partnerFAQs,
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Frequently Asked Questions >",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.08,
            color: skyBlueColor,
            decoration: TextDecoration.underline,
            fontFamily: 'Figtree',
          ),
        ),
      ),
    );
  }
}
