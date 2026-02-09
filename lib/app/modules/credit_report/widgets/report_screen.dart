import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/back_arrow_app_bar.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/credit_report/model/credit_report_model.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_info_widget.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_experian.dart';
import 'package:privo/app/modules/credit_report/widgets/tile_overview.dart';
import 'package:privo/app/modules/referral/widgets/referral_card.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import '../../../../res.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_text_theme.dart';
import '../credit_report_helper_mixin.dart';
import '../credit_report_logic.dart';
import 'credit_report_tile.dart';
import 'refresh_credit_score.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({Key? key}) : super(key: key);

  final logic = Get.find<CreditReportLogic>();

  Widget _titleWidget(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: navyBlueColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.9,
      ),
    );
  }

  Widget _creditScoreOverview() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 26.0),
            child: SvgPicture.asset(logic.creditScoreScale.imagePath),
          ),
          Column(
            children: [
              _creditScoreTextWidget(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    logic.creditScoreScale.title,
                    style: TextStyle(
                      color: logic.creditScoreScale.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 16 / 12,
                    ),
                  ),
                  const HorizontalSpacer(6),
                  InkWell(
                      onTap: logic.onCreditScoreInfoClicked,
                      child: _infoIcon()),
                ],
              ),
              const VerticalSpacer(4),
              Text(
                logic.creditScoreModel.applicationDetails.lastUpdatedText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  color: secondaryDarkColor,
                  height: 1.4,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _creditScoreTextWidget() {
    return Text(
      logic.creditReport.score.toString(),
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: navyBlueColor,
        fontSize: 40,
      ),
    );
  }

  Widget _infoIcon() {
    return SvgPicture.asset(
      Res.infoIconSVG,
      height: 16,
      width: 16,
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
              controller: logic.creditReportScrollController,
              key: logic.creditReportScrollKey,
              child: _bodyWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appbar() {
    return BackArrowAppBar(
      title: 'Credit Score',
      onBackPress: logic.onBackClicked,
    );
  }

  Widget _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacer(32),
          _creditScoreOverview(),
          verticalSpacer(6),
          _buildCreditPointStatusWidget(),
          verticalSpacer(16),
          _computeNextUpdateWidget(),
          verticalSpacer(40),
          _titleWidget("Your Credit Overview"),
          verticalSpacer(12),
          _creditOverviewWidget(),
          verticalSpacer(32.h),
          if(logic.isReferralEnabled)...[
            ReferralCard(onTap: logic.onReferralCardTapped,bodyText: "This financial tool helped you monitor your credit score - now pass it on",),
            VerticalSpacer(29.h),
          ],
          _titleWidget("What’s Building Your Credit"),
          verticalSpacer(12),
          _creditInfoWidget(),
          verticalSpacer(18),
          const PoweredByExperian(),
        ],
      ),
    );
  }

  Widget _buildCreditPointStatusWidget() {
    return GetBuilder<CreditReportLogic>(
      id: logic.SCORE_POINT_WIDGET,
      builder: (logic) {
        if (!logic.shouldShowCreditPointStatus) {
          return _computeWidget(logic);
        }
        return logic.hasValidGraphData
            ? _lineGraphTile(logic)
            : Container();
      },
    );
  }

  Container _lineGraphTile(CreditReportLogic logic) {
    return Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
              decoration: BoxDecoration(
                color: lightBlueColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: logic.creditScoreLineGraphModel.scoreDifference == 0
                  ? Center(
                      child: Text(
                        "Your Experian score has no change",
                        style: AppTextStyles.bodySRegular(
                            color: appBarTitleColor),
                      ),
                    )
                  : _experianScorePointCard(logic),
            );
  }


  Widget _computeWidget(CreditReportLogic logic) {
      if (logic.isCreditScorePointLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return const SizedBox.shrink();
    }
  }

  InkWell _experianScorePointCard(CreditReportLogic logic) {
    return InkWell(
      onTap: () {
        logic.currentCreditReportState = CreditReportState.scoreUpdateStatus;
        logic.logEventOnTapCreditHomeGraphTile();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(logic.creditScoreUpdate.icon),
                HorizontalSpacer(14.w),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Your Experian score has \n${logic.creditScoreUpdate.scoreChange} by ',
                        style:
                            AppTextStyles.bodySRegular(color: appBarTitleColor),
                      ),
                      TextSpan(
                        text: '${logic.creditScoreUpdate.creditPoint} points',
                        style: AppTextStyles.bodySSemiBold(
                            color: appBarTitleColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(Res.rightArrowCreditScore)
        ],
      ),
    );
  }

  Row _nextScoreUpdate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            logic.creditScoreModel.applicationDetails.nextScoreUpdateText,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: secondaryDarkColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 17 / 12,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        InkWell(onTap: logic.onNextScoreUpdateClicked, child: _infoIcon()),
      ],
    );
  }

  Widget _creditOverviewWidget() {
    return GetBuilder<CreditReportLogic>(
        id: logic.CREDIT_OVERVIEW,
        builder: (context) {
          return Column(
            children: [
              Column(
                children: List.generate(
                  min(logic.creditOverviewLength, logic.maxCreditOverviewItems),
                  (index) {
                    CreditAccount creditAccount =
                        logic.creditReport.accounts[index];
                    return CreditReportTile(
                      title: creditAccount.accountName,
                      subTitle: creditAccount.lenderName,
                      subTitleColor: secondaryDarkColor,
                      rightInfoWidget: TileOverview(
                        creditAccount: creditAccount,
                      ),
                      iconPath: logic.getExperianBankLogo(
                          experianBankName: creditAccount.lenderName),
                      onTap: () => logic.onCreditOverviewTapped(creditAccount),
                    );
                  },
                ),
              ),
              if (_showViewAll()) ...[const VerticalSpacer(12), _viewAll()],
            ],
          );
        });
  }

  bool _showViewAll() =>
      logic.creditReport.accounts.length > logic.maxCreditOverviewItems;

  InkWell _viewAll() {
    return InkWell(
      onTap: () => logic.onViewAllTapped(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          Text(
            "View all",
            style: hyperlinkStyle(size: 12),
          ),
          const HorizontalSpacer(2),
          SizedBox(
            width: 16,
            height: 16,
            child: Center(
              child: SvgPicture.asset(Res.doubleArrowRight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditInfoWidget() {
    return Column(
      children: CreditInfoType.values
          .map((type) => CreditInfoWidget(type: type))
          .toList(),
    );
  }

  _computeNextUpdateWidget() {
    if (!logic.creditScoreModel.refreshAvailable) return _nextScoreUpdate();
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: RefreshCreditScore(),
    );
  }
}
