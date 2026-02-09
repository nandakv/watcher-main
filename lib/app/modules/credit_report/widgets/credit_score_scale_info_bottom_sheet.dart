import 'dart:ffi';

import 'package:card_swiper/card_swiper.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common_widgets/bottom_sheet_widget.dart';
import '../../../common_widgets/vertical_spacer.dart';
import '../../../theme/app_colors.dart';
import '../credit_report_helper_mixin.dart';
import '../credit_report_logic.dart';
import '../model/credit_score_scale_model.dart';

class CreditScoreScaleInfoBottomSheet extends StatelessWidget {
  final logic = Get.find<CreditReportLogic>();

  CreditScoreScaleInfoBottomSheet({
    Key? key,
  }) : super(key: key);

  Widget _titleWidget() {
    return Text(
      "Credit Score Scale",
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkBlueColor,
      ),
    );
  }

  Widget _impactWidget(CreditScoreScale creditScoreData) {
    return Text(
      creditScoreData.title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: creditScoreData.color,
      ),
    );
  }

  Widget _descriptionTextWidget(String details) {
    return Text(
      details,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 12,
        height: 1.4,
        color: secondaryDarkColor,
      ),
    );
  }

  Widget _scoreRangeText(CreditScoreScale creditScoreData) {
    return Text(
      "${creditScoreData.minScore} to ${creditScoreData.maxScore}",
      style: const TextStyle(
        color: secondaryDarkColor,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _closeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: Get.back,
          child: const Icon(
            Icons.clear_rounded,
            color: appBarTitleColor,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      childPadding: const EdgeInsets.all(24),
      enableCloseIconButton: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _closeButton(),
            _titleWidget(),
            verticalSpacer(24),
            ExpandablePageView.builder(
              itemCount: CreditScoreScale.values.length,
              controller: logic.creditScoreScaleCarousalController,
              onPageChanged: logic.onCreditScoreScalePageChanged,
              itemBuilder: (context, index) {
                return _carouselWidget(CreditScoreScale.values[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _carouselWidget(CreditScoreScale creditScoreData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 250,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SvgPicture.asset(creditScoreData.imagePath),
                  Column(
                    children: [
                      _impactWidget(creditScoreData),
                      verticalSpacer(4),
                      _scoreRangeText(creditScoreData),
                      verticalSpacer(6),
                    ],
                  )
                ],
              ),
              verticalSpacer(18),
              _carouselPageIndicator(),
              // PageIndicator(
              //   count: CreditScoreScale.values.length,
              //   controller: logic.creditScoreScaleCarousalController,
              //   color: secondaryDarkColor.withOpacity(0.2),
              //   activeColor: secondaryDarkColor,
              //   size: 4,
              //   activeSize: 4,
              //   scale: 6,
              //   space: 5,
              //   layout: PageIndicatorLayout.WARM,
              // ),
              verticalSpacer(18),
              _descriptionTextWidget(creditScoreData.details),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carouselPageIndicator() {
    return GetBuilder<CreditReportLogic>(
        id: logic.PAGE_INDICATOR_ID,
        builder: (logic) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              CreditScoreScale.values.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _pageIndicatorDot(index),
              ),
            ),
          );
        });
  }

  int pageValue() {
    final controller = logic.creditScoreScaleCarousalController;
    if (controller.hasClients && controller.position.hasContentDimensions) {
      return controller.page?.round() ?? 0;
    }
    return 0;
  }

  Container _pageIndicatorDot(int index) {
    return Container(
      width: pageValue() == index ? 12 : 5,
      height: 5,
      decoration: BoxDecoration(
          color: pageValue() == index
              ? secondaryDarkColor
              : Color.fromRGBO(112, 112, 112, 0.20),
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
