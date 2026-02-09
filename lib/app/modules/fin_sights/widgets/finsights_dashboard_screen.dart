import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/top_navigation_bar.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_account_overview_widget.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_data_visibility_label_widget.dart';
import 'package:privo/app/modules/fin_sights/widgets/mask_data_widget.dart';
import 'package:privo/app/modules/fin_sights/widgets/transaction_line_chart.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../res.dart';
import '../../../components/page_indicator.dart';
import '../../../routes/app_pages.dart';
import '../finsights_transaction_error.dart';
import '../spending_insights/spending_snap_shot_model.dart';
import 'finsights_your_finance_widget.dart';
import 'finsights_top_transaction_view.dart';

class FinsightsDashboardScreen extends StatelessWidget {
  FinsightsDashboardScreen({super.key});

  final logic = Get.find<FinSightsLogic>();
  final DateFormat dateFormat = DateFormat("dd MMM ‘yy");


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: logic.canDashboardPop,
      onPopInvoked: (didPop) {
        if (!didPop) logic.onDashboardBackPressed();
      },
      child: SingleChildScrollView(
        child: Stack(
          children: [
            _backgroundImage(context),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TopNavigationBar(
                      onInfoPressed: logic.onTopBarInfoPressed,
                      enableShadow: false,
                      onBackPressed: logic.onDashboardBackPressed,
                    ),
                    FinsightsDataVisibilityLabelWidget(),
                    const VerticalSpacer(8),
                    _closingBalanceWidget(),
                    const VerticalSpacer(44),
                    FinsightsAccountOverviewWidget(),
                    const VerticalSpacer(40),
                    buildSpendingSnapShot(logic),
                    const VerticalSpacer(40),
                    FinsightsYourFinanceWidget(),
                    const VerticalSpacer(40),
                    FinsightsTopTransactionView(),
                    const VerticalSpacer(40),
                    _finsightsLineGraph(),
                    const VerticalSpacer(56),
                    _bottomLicenseWidget(context)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _finsightsLineGraph() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Maximum Account Balance",
          ).headingSMedium(color: appBarTitleColor),
          Text(
            "Overview of the highest balance each month for the past ${logic.overviewModel.months.length} months",
          ).bodyXSRegular(color: appBarTitleColor),
          const VerticalSpacer(16),
          logic.overviewModel.maxBalancePerMonthList.isNotEmpty
              ? const SizedBox(
                  height: 210,
                  child: TransactionLineChart(),
                )
              : FinsightsTransactionError(),
        ],
      ),
    );
  }

  Column _closingBalanceWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("CLOSING BALANCE").bodyMMedium(
              color: secondaryDarkColor,
            ),
            const SizedBox(
              width: 6,
            ),
            InkWell(
              onTap: logic.onTapClosingBalanceInfo,
              child: SvgPicture.asset(
                Res.infoIconSVG,
                width: 16.w,
                height: 16.h,
              ),
            ),
          ],
        ),
        Text('as on ${dateFormat.format(logic.finSightsViewModel.closingBalanceDate)}')
            .bodySRegular(
          color: secondaryDarkColor,
        ),
        const VerticalSpacer(4),
        MaskDataWidget(
          text: logic.finSightsViewModel.closingBalance.removeAllWhitespace,
          styleBuilder: (text) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FittedBox(
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 1,
              ).displayM(
                color: navyBlueColor,
                addShadow: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stack _bottomLicenseWidget(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Plan today,\ngain tomorrow",
              ).headingLSemiBold(color: lightGrayColor),
              const VerticalSpacer(8),
              RichText(
                text:  TextSpan(
                  text: "Powered by ",
                  style: const TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: secondaryDarkColor,
                  ),
                  children: [
                    TextSpan(
                      text: "Sahamati, ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: skyBlueColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrlString(
                            "https://sahamati.org.in/",
                            mode: LaunchMode.inAppWebView,
                          );
                        },
                    ),
                    const TextSpan(
                      text: "RBI licensed",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: secondaryDarkColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        _bottomBackgroundImage(context),
      ],
    );
  }

  SvgPicture _bottomBackgroundImage(BuildContext context) {
    return SvgPicture.asset(
      Res.finsightsBottomBackgroundSvg,
      alignment: Alignment.bottomRight,
    );
  }

  SvgPicture _backgroundImage(BuildContext context) {
    return SvgPicture.asset(
      Res.finsightsDashboardBGSvg,
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
    );
  }


  buildSpendingSnapShot(FinSightsLogic logic) {
    return GetBuilder<FinSightsLogic>(
        id: "spending_snap_card",
        builder: (logic) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF000000).withOpacity(.05),
                width: 2.w,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: logic.totalDebitAmountLast6Months == "0.0"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spending Snapshot',
                  style:
                  AppTextStyles.headingSMedium(color: navyBlueColor),
                ),
                VerticalSpacer(16.h),
                _buildSpendingSnapShotErrorMessage(),
              ],
            )
                : InkWell(
              onTap: () => Get.toNamed(Routes.SPENDING_INSIGHTS),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSpendingSnapShotTitle(),
                    VerticalSpacer(12.h),
                    _pageView(),
                    GetBuilder<FinSightsLogic>(
                        id: logic.SNAP_SHOT_PAGE_INDICATOR,
                        builder: (logic) {
                          return Align(
                            alignment: Alignment.center,
                            child: PageIndicator(
                              currentIndex: logic.currentIndex,
                            ),
                          );
                        }),
                  ]),
            ),
          );
        });
  }

  Row _buildSpendingSnapShotErrorMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(Res.noSpendingData),
        Text(
          'Uh oh! Looks like there is no spending \ndata to show at this moment',
          style: AppTextStyles.bodySRegular(color: secondaryDarkColor),
        ),
      ],
    );
  }

  Row _buildSpendingSnapShotTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Spending Snapshot',
          style: AppTextStyles.headingSMedium(color: navyBlueColor),
        ),
        SvgPicture.asset(Res.circleRight),
      ],
    );
  }

  Widget _pageView() {
    return CarouselSlider(
      items: logic.carouselSlides
          .map<Widget>((e) => _buildSpendingSwipeCard(
          spendingSnapShotModel: e))
          .toList(),
      carouselController: logic.spendingSnapShotPageController,
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          logic.onCarouselPageChange(index);
        },
        height: 105.h,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
      ),
    );
  }

  Row _buildSpendingSwipeCard( {required SpendingSnapShotModel spendingSnapShotModel}) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(spendingSnapShotModel.img),
              SizedBox(width: 32.0.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spendingSnapShotModel.title,
                      style: AppTextStyles.bodyLSemiBold(
                          color: darkBlueColor),
                    ),
                    VerticalSpacer(4.0.h),
                    spendingSnapShotModel.subTitle
                  ],
                ),
              ),
            ],
          );
  }
}
