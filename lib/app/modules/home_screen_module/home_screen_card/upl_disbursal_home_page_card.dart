import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:privo/app/common_widgets/home_page_button.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/home_card_rich_text_values.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/widgets/card_badge.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/components/button.dart';

import '../../../../res.dart';
import '../../../common_widgets/vertical_spacer.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../on_boarding/mixins/app_form_mixin.dart';
import '../home_screen_logic.dart';
import '../widgets/home_page_right_arrow_widget.dart';
import '../widgets/withdrawal_home_page/withdrawal_limit_details_widget.dart';
import 'expandable_home_screen_card.dart';
import 'primary_home_screen_card/primary_home_screen_card_logic.dart';

class UPLDisbursalHomePageCard extends StatelessWidget {
  UPLDisbursalHomePageCard({
    Key? key,
    required this.emiAmount,
    required this.loanAmount,
    required this.emiPaid,
    required this.emiTotal,
    required this.isFundTransferInProgress,
    required this.lpcCard,
    required this.cardBadgeType,
  }) : super(key: key);

  final String emiAmount;
  final String loanAmount;
  final int emiPaid;
  final int emiTotal;
  final CardBadgeType cardBadgeType;
  final bool isFundTransferInProgress;
  final LpcCard lpcCard;

  final homeScreenLogic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return ExpandableHomeScreenCard(
      lpcCard: lpcCard,
      cardBadgeType: cardBadgeType,
      children: [
        _bodyWidget(),
        _viewLoansCta(),
      ],
    );
  }

  Widget _bodyWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 16.h,
            right: 15.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _loanAmount(),
              VerticalSpacer(16.h),
              _monthlyEmi(),
              VerticalSpacer(24.h),
            ],
          ),
        ),
        const Spacer(),
        _limitChart(),
      ],
    );
  }

  WithdrawalLimitDetailsWidget _loanAmount() {
    return WithdrawalLimitDetailsWidget(
      withdrawalLimitType: WithdrawalLimitType(
          title: "Loan Amount",
          value: loanAmount,
          titleColor: secondaryDarkColor,
          icon: Res.avaialable_wallet,
          valueColor: green500),
    );
  }

  WithdrawalLimitDetailsWidget _monthlyEmi() {
    return WithdrawalLimitDetailsWidget(
      withdrawalLimitType: WithdrawalLimitType(
          title: "Monthly EMI",
          value: emiAmount,
          titleColor: secondaryDarkColor,
          icon: Res.used_limit_wallet,
          valueColor: const Color(0xFF3F7ECB)),
    );
  }

  Widget _limitChart() {
    return SizedBox(
      height: 110.w,
      width: 110.w,
      child: PieChart(
        chartType: ChartType.ring,
        legendOptions: const LegendOptions(showLegends: false),
        colorList: const [
          Color(0xFF316DB6),
          Color(0xFF32B353),
        ],
        chartRadius: 100.w,
        totalValue: 100,
        chartValuesOptions: _chartOptions(),
        ringStrokeWidth: 14.w,
        centerWidget: RichTextWidget(
          textAlign: TextAlign.center,
          infoList: HomeCardTexts().uplPieChartTextValues(
              emiPaid: emiPaid.toString(), totalEmi: emiTotal.toString()),
        ),
        dataMap: _fetchLimitDataMap(),
      ),
    );
  }

  ChartValuesOptions _chartOptions() {
    return ChartValuesOptions(
      showChartValuesOutside: true,
      chartValueStyle: TextStyle(
          fontSize: 6.sp, color: grey900, fontWeight: FontWeight.w600),
      showChartValuesInPercentage: true,
    );
  }

  Map<String, double> _fetchLimitDataMap() {
    Get.log("emi pending ${((emiTotal - emiPaid) * emiTotal) / 100}");
    Get.log("emi paid ${(emiPaid * emiTotal) * 100}");
    //To Compute the percentage to be shown in pie chart indicators
    return {
      "EMI Pending": ((emiTotal - emiPaid) / emiTotal) * 100,
      "EMI Paid": (emiPaid / emiTotal) * 100,
    };
  }

  Widget _viewLoansCta() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GetBuilder<PrimaryHomeScreenCardLogic>(
        tag: lpcCard.appFormId,
        builder: (logic) {
          return Button(
            title: "View details",
            buttonSize: ButtonSize.small,
            buttonType: ButtonType.primary,
            isLoading: logic.isWithdrawButtonLoading,
            onPressed: () => logic.goToServicingScreen(
                LPCService.instance.lpcCards.indexOf(lpcCard)),
          );
        },
      ),
    );
  }
}
