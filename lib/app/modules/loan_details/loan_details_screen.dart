import 'dart:async';
import 'dart:math';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/back_arrow_app_bar.dart';
import 'package:privo/app/common_widgets/closed_bar.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/pill_button.dart';
import 'package:privo/app/components/top_navigation_bar.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/widgets/card_badge.dart';
import 'package:privo/app/modules/loan_details/widgets/bpi_info_widget.dart';
import 'package:privo/app/modules/loan_details/widgets/document_button_widget.dart';
import 'package:privo/app/modules/loan_details/widgets/loan_info_bottom_sheet.dart';
import 'package:privo/app/modules/loan_details/widgets/total_payment_info_bottom_sheet.dart';
import 'package:privo/app/modules/payment/payment_view.dart';
import 'package:privo/app/modules/servicing_home_screen/widgets/emi_progress_bar.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';
import 'package:privo/components/svg_icon.dart';
import '../../../components/button.dart';
import '../../../res.dart';
import '../../common_widgets/calender/day_month_year.dart';
import '../../common_widgets/golden_badge.dart';
import '../../firebase/analytics.dart';
import '../../models/rich_text_model.dart';
import '../../utils/app_functions.dart';
import '../../utils/web_engage_constant.dart';
import '../faq/faq_page.dart';
import '../faq/faq_utility.dart';
import '../faq/widget/faq_tile.dart';
import '../on_boarding/model/privo_app_bar_model.dart';
import '../on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import '../payment/widgets/payment_know_more_bottom_sheet.dart';
import '../pdf_document/pdf_document_logic.dart';
import 'loan_details_analytics_mixin.dart';
import 'loan_details_logic.dart';
import 'widgets/card_title_and_value_widget.dart';
import 'widgets/info_bottom_sheet.dart';
import 'widgets/loan_details_item_widget.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({Key? key}) : super(key: key);

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen>
    with AfterLayoutMixin, LoanDetailsAnalyticsMixin {
  final logic = Get.find<LoanDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoanDetailsLogic>(builder: (logic) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: logic.isPageLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    _newScreen(),
                    // _oldScreen(),
                    _overlayWidget(),
                  ],
                ),
        ),
      );
    });
  }

  Widget _newScreen() {
    return Column(
      children: [
        TopNavigationBar(
          title: "Loan ID #${logic.loanDetailModel.loanId}",
          enableShadow: true,
          secondaryWidget: logic.computeSecondaryWidget(),
          trailing: InkWell(
            onTap: () {
              logic.goToHelp();
            },
            child: const SVGIcon(
              size: SVGIconSize.medium,
              icon: Res.questionMark,
              color: Colors.black,
            ),
          ),
        ),
        _newBodyWidget(),
      ],
    );
  }

  Widget _newBodyWidget() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VerticalSpacer(32.h),
            _overViewHeading(),
            VerticalSpacer(16.h),
            _overviewContainer(),
            VerticalSpacer(40.h),
            _emiDetailsHeading(),
            VerticalSpacer(16.h),
            _emiDetailsContainer(),
            if (logic.documentsList.isNotEmpty) ...[
              VerticalSpacer(16.h),
              _docsSection(),
            ],
            VerticalSpacer(40.h),
            if (logic.loanDetailModel.loanStatus != LoanStatus.closed) ...[
              _paymentsHeading(),
              VerticalSpacer(16.h),
              _newAdvanceEMIWidget(),
              if (logic.loanDetailModel.overduePaymentTypeDetails.type ==
                  PaymentTypeStatus.eligible) ...[
                VerticalSpacer(16.h),
                _newOverdueWidget(),
              ] else ...[
                VerticalSpacer(16.h),
                _newForeCloseWidget(),
              ],
              VerticalSpacer(36.h),
            ],
          ],
        ),
      ),
    );
  }

  Widget _overViewHeading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Overview",
          style: AppTextStyles.headingSMedium(
            color: AppTextColors.primaryNavyBlueHeader,
          ),
        ),
        HorizontalSpacer(8.w),
        if (logic.loans.isInsured)
          const CSBadge(
            text: "Insured",
            bgColor: secondaryYellow800,
            leading: SVGIcon(
              size: SVGIconSize.small,
              icon: Res.verifiedSecured,
              color: Colors.white,
            ),
          )
      ],
    );
  }

  Widget _overviewContainer() {
    return GradientBorderContainer(
      borderRadius: 8.r,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      _loanAmountTile(
                        title: "Loan amount",
                        subTitle: AppFunctions()
                            .parseNumberToCommaFormatWithRupeeSymbol(
                          num.parse(logic.loanDetailModel.loanAmount),
                        ),
                        icon: Res.loanAmountSVG,
                      ),
                      HorizontalSpacer(16.w),
                      const VerticalDivider(),
                      HorizontalSpacer(16.w),
                      _loanAmountTile(
                        title: "EMI amount",
                        subTitle: AppFunctions()
                            .parseNumberToCommaFormatWithRupeeSymbol(
                          num.parse(logic.loanDetailModel.emiAmount),
                        ),
                        icon: Res.emiAmountSVG,
                      ),
                    ],
                  ),
                ),
                VerticalSpacer(16.h),
                _detailsTile(
                  title: "Interest rate (per annum)",
                  value: "${logic.loanDetailModel.roi}%",
                ),
                VerticalSpacer(8.h),
                _detailsTile(
                  title: "Annual Percentage Rate (APR)",
                  value: logic.loanDetailModel.apr,
                  onInfoTapped: () {
                    _aprBottomSheetEvents();
                  },
                ),
                VerticalSpacer(8.h),
                _detailsTile(
                  title: "Tenure",
                  value: "${logic.loanDetailModel.tenure} months",
                ),
                VerticalSpacer(8.h),
                _detailsTile(
                  title: "Start date",
                  value: DateFormat("dd MMM ’yy").format(
                    DateTime.parse(logic.loanDetailModel.loanStartDate),
                  ),
                ),
                VerticalSpacer(8.h),
                _detailsTile(
                  title: "End date",
                  value: DateFormat("dd MMM ’yy").format(
                    DateTime.parse(logic.loanDetailModel.loanEndDate),
                  ),
                ),
              ],
            ),
          ),
          _amountTransferredContainer(),
        ],
      ),
    );
  }

  Widget _loanAmountTile({
    required String title,
    required String subTitle,
    required String icon,
  }) {
    return Expanded(
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: 32.h,
            width: 32.h,
          ),
          HorizontalSpacer(8.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyXSRegular(
                    color: AppTextColors.neutralBody,
                  ),
                ),
                VerticalSpacer(2.h),
                // Use FittedBox to scale down the text if it's too large
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subTitle,
                    style: AppTextStyles.bodyLMedium(
                      color: AppTextColors.primaryNavyBlueHeader,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _detailsTile({
    required String title,
    required String value,
    Function()? onInfoTapped,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.bodySRegular(
            color: AppTextColors.neutralBody,
          ),
        ),
        HorizontalSpacer(8.w),
        if (onInfoTapped != null)
          InkWell(
            onTap: () {
              onInfoTapped();
            },
            child: const SVGIcon(
              size: SVGIconSize.small,
              icon: Res.informationFilledIcon,
            ),
          ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodySSemiBold(
            color: AppTextColors.neutralDarkBody,
          ),
        ),
      ],
    );
  }

  Widget _amountTransferredContainer() {
    return InkWell(
      onTap: () {
        // _openAmountTransferredBottomSheet();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.r),
            bottomRight: Radius.circular(8.r),
          ),
          color: AppBackgroundColors.primarySubtle,
          border: Border(
            top: BorderSide(
              color: const Color(0xff8FD1EC),
              width: 0.6.r,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Row(
            children: [
              Text(
                "Amount transferred",
                style: AppTextStyles.bodySMedium(
                    color: AppTextColors.primaryNavyBlueHeader),
              ),
              const Spacer(),
              Text(
                AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
                  num.parse(logic.loanDetailModel.disbursalAmount),
                ),
                style: AppTextStyles.bodySSemiBold(
                  color: AppTextColors.primaryNavyBlueHeader,
                ),
              ),
              // HorizontalSpacer(8.w),
              // const SVGIcon(
              //   size: SVGIconSize.small,
              //   icon: Res.accordingRight,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emiDetailsHeading() {
    return Text(
      "EMI details",
      style: AppTextStyles.headingSMedium(
        color: AppTextColors.primaryNavyBlueHeader,
      ),
    );
  }

  Widget _emiDetailsContainer() {
    return GradientBorderContainer(
      borderRadius: 8.r,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          _computeInProgressWidget(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "EMIs",
                      style: AppTextStyles.bodyMMedium(
                        color: AppTextColors.brandBlueBodyFocus,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Total EMIs: ${logic.loanDetailModel.emiTotal}",
                      style: AppTextStyles.bodySRegular(
                          color: AppTextColors.brandBlueBodyFocus),
                    ),
                  ],
                ),
                VerticalSpacer(16.h),
                EmiProgressIndicator(
                  totalEmi: logic.loanDetailModel.emiTotal,
                  paidEmi: logic.loanDetailModel.emiPaid,
                  skippedEmi: logic.loanDetailModel.overdueInst,
                ),
                VerticalSpacer(8.h),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 36.w,
                    children: [
                      _emiTypeTileWidget(
                        title: "Paid",
                        value: logic.loanDetailModel.emiPaid.toString(),
                        color: green500,
                      ),
                      _emiTypeTileWidget(
                        title: "Overdue",
                        value: logic.loanDetailModel.overdueInst.toString(),
                        color: red700,
                      ),
                      _emiTypeTileWidget(
                        title: "Pending",
                        value: logic.loanDetailModel.emiPending.toString(),
                        color: AppBackgroundColors.neutralLightSubtle,
                      ),
                    ],
                  ),
                ),
                if (logic.emiDocumentsList.isNotEmpty) ...[
                  VerticalSpacer(24.h),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 16.w,
                      runSpacing: 16.h,
                      children: logic.emiDocumentsList,
                    ),
                  ),
                ],
                _computePaymentHistoryCTA(),
                VerticalSpacer(24.h),
                _divider(),
                VerticalSpacer(16.h),
                _totalAmountRemainingWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInProgressInfoWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppBackgroundColors.primarySubtle, // Light blue background
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Res.blueBulbSVG,
            height: 24.w,
            width: 24.w,
          ),
          SizedBox(width: 12.w),
          // Text with inline info icon
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySRegular(
                  color: AppTextColors.neutralBody,
                ),
                children: [
                  const TextSpan(
                    text: "Your current month's EMI payment is in progress ",
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      onTap: logic.onEmiInProgressTapped,
                      child: SvgPicture.asset(
                        Res.informationFilledIcon,
                        height: 16.w,
                        width: 16.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextEMIWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        children: [
          VerticalSpacer(16.h),
          Row(
            children: [
              SvgPicture.asset(
                Res.blueBulbSVG,
                height: 24.w,
                width: 24.w,
              ),
              HorizontalSpacer(12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "Your next EMI will be auto-debited on ",
                      style: AppTextStyles.bodySRegular(
                        color: AppTextColors.neutralBody,
                      ),
                    ),
                    buildSuperscriptDate(DateTime.parse(logic.loanDetailModel.nextDueDate)),
                  ],
                ),
              ),
            ],
          ),
          VerticalSpacer(16.h),
          _divider(),
        ],
      ),
    );
  }

  Widget buildSuperscriptDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String suffix = AppFunctions().getDayOfMonthSuffix(date.day);
    String monthYear = DateFormat(' MMMM, yyyy').format(date);

    final baseStyle = AppTextStyles.bodySSemiBold(
      color: AppTextColors.neutralBody,
    );

    final suffixStyle = baseStyle.copyWith(
      fontSize: baseStyle.fontSize! * 0.75,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: day.trim(), style: baseStyle),
              WidgetSpan(
                alignment: PlaceholderAlignment.top,
                child: Transform.translate(
                  offset: const Offset(1, -1),
                  child: Text(suffix, style: suffixStyle),
                ),
              ),
            ],
          ),
        ),
        Text(monthYear, style: baseStyle,textAlign: TextAlign.end,),
      ],
    );
  }

  String formatDateToDaySuffixMonthYear() {
    DateTime date = DateTime.parse(logic.loanDetailModel.nextDueDate);
    String day = DateFormat('d').format(date);
    String suffix = AppFunctions().getDayOfMonthSuffix(date.day);
    String monthYear = DateFormat(' MMM, yyyy').format(date);

    return '$day$suffix$monthYear';
  }

  Widget _emiTypeTileWidget({
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5.w,
          height: 5.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        HorizontalSpacer(4.w),
        Text(
          "$title: $value",
          style: AppTextStyles.bodySRegular(
            color: AppTextColors.brandBlueBodyFocus,
          ),
        ),
      ],
    );
  }

  Widget _totalAmountRemainingWidget() {
    return Row(
      children: [
        Text(
          "Total payable",
          style: AppTextStyles.bodySMedium(
            color: AppTextColors.neutralDarkBody,
          ),
        ),
        HorizontalSpacer(4.w),
        InkWell(
          onTap: () {
            _openTotalAmountRemainingBottomSheet();
          },
          child: const SVGIcon(
            size: SVGIconSize.small,
            icon: Res.informationFilledIcon,
          ),
        ),
        const Spacer(),
        RichTextWidget(
          infoList: [
            RichTextModel(
              text: AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
                  logic.loanDetailModel.totalPayable.amountPaid),
              textStyle: AppTextStyles.bodySSemiBold(
                color: AppTextColors.neutralDarkBody,
              ),
            ),
            RichTextModel(
              text:
                  " / ${AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
                logic.loanDetailModel.totalPayable.totalAmountPayable,
              )}",
              textStyle: AppTextStyles.bodyXSMedium(
                color: AppTextColors.neutralDarkBody,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openTotalAmountRemainingBottomSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
      TotalPayableDetailsBottomSheet(
        loanDetailsModel: logic.loanDetailModel,
      ),
    );
  }

  Container _divider() {
    return Container(
      height: 1.h,
      color: AppBackgroundColors.neutralLightSubtle,
    );
  }

  Widget _docsSection() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 16.w,
        runSpacing: 16.h,
        children: logic.documentsList,
      ),
    );
  }

  Widget _paymentsHeading() {
    return Text(
      "Payments",
      style: AppTextStyles.headingSMedium(
        color: AppTextColors.primaryNavyBlueHeader,
      ),
    );
  }

  Widget _newAdvanceEMIWidget() {
    return GradientBorderContainer(
      borderRadius: 8.r,
      color: AppBackgroundColors.primarySubtle,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Expanded(
              child: RichTextWidget(
                textAlign: TextAlign.left,
                infoList: [
                  RichTextModel(
                    text: "Advance pay single EMI before\ndue date with ease.",
                    textStyle: AppTextStyles.bodySRegular(
                      color: AppTextColors.brandBlueTitle,
                    ),
                  ),
                  RichTextModel(
                    text: " Know more",
                    textStyle: AppTextStyles.bodySRegular(
                      color: AppTextColors.link,
                    ),
                    onTap: logic.onAdvanceEMIKnowMoreClicked,
                  ),
                ],
              ),
            ),
            Button(
              buttonSize: ButtonSize.small,
              buttonType: ButtonType.primary,
              title: "Pay EMI  ",
              onPressed: logic.onAdvanceEMIPayClicked,
            ),
          ],
        ),
      ),
    );
  }

  Widget _newOverdueWidget() {
    return GradientBorderContainer(
      borderRadius: 8.r,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              children: [
                const SVGIcon(
                  size: SVGIconSize.medium,
                  icon: Res.errorFilledIcon,
                  color: red700,
                ),
                HorizontalSpacer(4.w),
                Text(
                  logic.computeOverdueCardTitle(),
                  style: AppTextStyles.headingSMedium(
                    color: AppTextColors.brandBlueTitle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: logic.loanDetailModel.isPendingPayment
                      ? RichTextWidget(
                          infoList: [
                            RichTextModel(
                              text:
                                  "Clear your pending charges from the previous payment",
                              textStyle: AppTextStyles.bodyXSRegular(
                                color: AppTextColors.neutralDarkBody,
                              ),
                            ),
                            RichTextModel(
                              text: " Know more",
                              textStyle: AppTextStyles.bodyXSRegular(
                                color: AppTextColors.primaryInverseTitle,
                              ),
                              onTap: logic.onTapOverdueKnowMore,
                            ),
                          ],
                        )
                      : Text(
                          "Pay now to stop accruing late fees\nand protect your credit profile",
                          style: AppTextStyles.bodyXSRegular(
                            color: AppTextColors.neutralBody,
                          ),
                        ),
                ),
                Button(
                  buttonSize: ButtonSize.small,
                  buttonType: ButtonType.primary,
                  title: "Pay now",
                  onPressed: logic.onOverdueCTAClicked,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _newForeCloseWidget() {
    return GradientBorderContainer(
      borderRadius: 8.r,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Expanded(
              child: RichTextWidget(
                textAlign: TextAlign.left,
                infoList: [
                  RichTextModel(
                    text: "Pay all EMIs to close your\nloan.",
                    textStyle: AppTextStyles.bodySRegular(
                      color: AppTextColors.brandBlueTitle,
                    ),
                  ),
                  RichTextModel(
                    text: " Know more",
                    textStyle: AppTextStyles.bodySRegular(
                      color: AppTextColors.link,
                    ),
                    onTap: logic.onTapForeclosureKnowMore,
                  ),
                ],
              ),
            ),
            Button(
              buttonSize: ButtonSize.small,
              buttonType: ButtonType.primary,
              title: "Foreclose",
              onPressed: logic.onTapForecloseCTA,
            ),
          ],
        ),
      ),
    );
  }

  Column _oldScreen() {
    return Column(
      children: [
        PrivoAppBar(
          model: PrivoAppBarModel(
            title: "",
            progress: 0,
            isAppBarVisible: true,
            isTitleVisible: false,
            appBarText: "Reference ID: #${logic.loanDetailModel.loanId}",
          ),
          showFAQ: true,
          lpcCard: LPCService.instance.activeCard,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Overview",
                        style: _headingTextStyle,
                      ),
                    ),
                    if (logic.loanDetailModel.loanStatus ==
                        LoanStatus.closed) ...[ClosedBar()],
                    if (logic.loanDetailModel.overduePaymentTypeDetails.type ==
                        PaymentTypeStatus.eligible) ...[
                      _overDueAlert(),
                    ],
                    const Spacer(),
                    _optionMenuWidget()
                  ],
                ),
                _topContainerWidget(),
                if (logic.loanDetailModel.showAdvanceEmi &&
                    !logic.isClosedLoan())
                  _advanceEMIWidget(),
                const SizedBox(
                  height: 10,
                ),
                _bottomContainerWidget(),
                // EmiProgressIndicator(),
                _computeOverDueOrForeclosure()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _overlayWidget() {
    return GetBuilder<LoanDetailsLogic>(
      id: logic.OVERLAY_WIDGET_KEY,
      builder: (logic) {
        return logic.enableOverlay
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black38,
              )
            : const SizedBox();
      },
    );
  }

  Widget _optionMenuWidget() {
    return PopupMenuTheme(
      data: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: PopupMenuButton<int>(
        icon: Icon(
          Icons.adaptive.more,
          color: navyBlueColor,
        ),
        position: PopupMenuPosition.under,
        color: const Color(0xffFFF3EB),
        offset: const Offset(-22, 0),
        onOpened: logic.onOptionMenuTap,
        onSelected: (value) {
          if (value == 1) {
            logic.goToHelp();
          }
        },
        onCanceled: () => logic.toggleOverlay(overlayValue: false),
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 1,
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: _getHelpWidget(),
            ),
          ];
        },
      ),
    );
  }

  Widget _getHelpWidget() {
    return const Center(
      child: Text(
        "Get Help",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: navyBlueColor,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _computeOverDueOrForeclosure() {
    if (logic.isClosedLoan()) {
      return const SizedBox();
    }

    if (logic.loanDetailModel.overduePaymentTypeDetails.type ==
        PaymentTypeStatus.eligible) {
      return _overdueAlertWidget();
    }

    if (logic.loanDetailModel.paymentType == PaymentType.partPay) {
      return _partPayAlertWidget();
    }

    if (logic.loanDetailModel.foreClosurePaymentTypeDetails.type ==
        PaymentTypeStatus.eligible) {
      return _forecloseWidget();
    }

    return const SizedBox();
  }

  Widget _topContainerWidget() {
    return Container(
      padding: const EdgeInsets.only(right: 12, left: 22, bottom: 20, top: 12),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EB),
        borderRadius: _computeBorderRadius(
            showBottomWidget: logic.loanDetailModel.showAdvanceEmi),
        border: Border.all(
          color: const Color(0xff161742),
          width: .5,
        ),
      ),
      child: Column(
        children: [
          if (logic.loans.isInsured)
            const Align(
                alignment: Alignment.topRight,
                child: GoldenBadge(title: "Insured")),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: Column(
              children: [
                LoanDetailsItemWidget(
                    firstItem: _computeShowAmountWithdrawn(),
                    secondItem: _computeShowAmountCredited()),
                LoanDetailsItemWidget(
                    firstItem: CardTitleAndValueWidget(
                      "Rate of Interest",
                      '${logic.loanDetailModel.roi}%',
                    ),
                    secondItem: CardTitleAndValueWidget(
                        "Annual Percentage Rate (APR)",
                        logic.loanDetailModel.apr,
                        iconWidget: _infoIcon(onPressed: () {
                      _aprBottomSheetEvents();
                    }))),
                LoanDetailsItemWidget(
                    firstItem: CardTitleAndValueWidget(
                        "Broken Period Interest (BPI)",
                        '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.bpiAmount)}',
                        iconWidget: _infoIcon(onPressed: () {
                      _bpiBottomSheetEvents();
                    })),
                    secondItem: CardTitleAndValueWidget("Processing Fee",
                        '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.processingFee)}')),
                computeShowElasticCreditLineType(),
                if (logic.loanDetailModel.docHandlingFee != "0")
                  CardTitleAndValueWidget(
                    "Documentation charges",
                    '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.docHandlingFee)}',
                  ),
                Divider(
                  color: const Color(0xff161742).withOpacity(.5),
                ),
                LoanDetailsItemWidget(
                    firstItem: dateTitleAndValue("Loan start date",
                        DateTime.parse(logic.loanDetailModel.loanStartDate)),
                    secondItem: dateTitleAndValue("Loan end date",
                        DateTime.parse(logic.loanDetailModel.loanEndDate)),
                    itemSpace: logic.BOTTOM_ITEM_SPACE),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runSpacing: 10,
                    spacing: 20,
                    children: logic.documentsList,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CardTitleAndValueWidget _computeShowAmountWithdrawn() {
    if (LPCService.instance.activeCard?.loanProductCode != "FCL") {
      return CardTitleAndValueWidget(
        "Amount Withdrawn",
        '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.loanAmount)}',
      );
    }
    return CardTitleAndValueWidget(
      "Total Sanctioned Amount",
      '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.sanctionedAmount.toString())}',
    );
  }

  CardTitleAndValueWidget _computeShowAmountCredited() {
    if (LPCService.instance.activeCard?.loanProductCode != "FCL") {
      return CardTitleAndValueWidget("Amount Credited",
          '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.disbursalAmount)}');
    }
    return CardTitleAndValueWidget(
      "Amount Withdrawn",
      '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.loanAmount)}',
    );
  }

  BorderRadius _computeBorderRadius({required bool showBottomWidget}) {
    showBottomWidget = !logic.isClosedLoan();
    return BorderRadius.only(
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
      bottomRight: showBottomWidget ? Radius.zero : const Radius.circular(8),
      bottomLeft: showBottomWidget ? Radius.zero : const Radius.circular(8),
    );
  }

  void _bpiBottomSheetEvents() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.bpiHelpfulEventLoaded);
    Get.bottomSheet(
      InfoBottomSheet(
          title: "Broken period Interest (BPI)",
          text:
              'Amount collected as an interest from the borrower if the time between the actual date of disbursal and the 1st instalment is more than 30 days.',
          closedEvent: WebEngageConstants.bpiHelpfulEventClosed,
          yesEvent: WebEngageConstants.bpiHelpfulEventYes,
          noEvent: WebEngageConstants.bpiHelpfulEventNo),
    );
  }

  void _aprBottomSheetEvents() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aprHelpfulEventLoaded);
    Get.bottomSheet(
      InfoBottomSheet(
          title: "Annual Percentage Rate",
          text:
              'This is the yearly percentage that represents the total cost of the loan. It includes both the base interest rate and any additional charges applied to the loan',
          closedEvent: WebEngageConstants.aprHelpfulEventClosed,
          yesEvent: WebEngageConstants.aprHelpfulEventYes,
          noEvent: WebEngageConstants.aprHelpfulEventNo),
    );
  }

  void _elasticClTypeBottomSheetEvents(ElasticCreditLineType elasticClType) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.elasticClHelpfulEventLoaded);
    Get.bottomSheet(InfoBottomSheet(
        title: _computeElasticClTypeTitle(elasticClType),
        text: _computeElasticClTypeBody(elasticClType),
        attributeName: {
          "credit_line_type": _computeElasticClTypeTitle(elasticClType)
        },
        closedEvent: WebEngageConstants.elasticClHelpfulEventClosed,
        yesEvent: WebEngageConstants.elasticClHelpfulEventYes,
        noEvent: WebEngageConstants.elasticClHelpfulEventNo));
  }

  _computeElasticClTypeTitle(ElasticCreditLineType elasticClType) {
    switch (elasticClType) {
      case ElasticCreditLineType.pure:
        return "Pure Flexi Credit Line";
      case ElasticCreditLineType.hybrid:
        return "Hybrid Flexi Credit Line";
      case ElasticCreditLineType.drop:
        return "Drop Flexi Credit Line";
      case ElasticCreditLineType.none:
        return "";
    }
  }

  _computeElasticClTypeBody(ElasticCreditLineType elasticClType) {
    switch (elasticClType) {
      case ElasticCreditLineType.pure:
        return "A combination of pure credit line and dropline credit line is offered in the form of a hybrid product. A hybrid flexi loan option is where, facility for the initial 1/2 years is pure and customers need to pay only interest. After 24 months, the loan converts into a dropline facility for the remaining tenure.";
      case ElasticCreditLineType.hybrid:
        return "An Overdraft facility that allows you to withdraw and repay funds as per your convenience. The sanctioned withdrawal limit is fixed and remains the same throughout the tenure.";
      case ElasticCreditLineType.drop:
        return "Dropline Overdraft is a financial instrument that allows a borrower to overdraw cash from his/her current account up to an agreed limit, wherein the withdrawal limit reduces each month from the sanctioned limit. The interest rate is paid only on the withdrawn cash and not on the total borrowing limit.";
      case ElasticCreditLineType.none:
        return "";
    }
  }

  Container _bottomContainerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EB),
        borderRadius: _computeBorderRadius(
            showBottomWidget:
                logic.loanDetailModel.overduePaymentTypeDetails.type ==
                        PaymentTypeStatus.eligible ||
                    logic.loanDetailModel.foreClosurePaymentTypeDetails.type ==
                        PaymentTypeStatus.eligible),
        border: Border.all(
          color: const Color(0xff161742),
          width: .5,
        ),
      ),
      child: Column(
        children: [
          LoanDetailsItemWidget(
              firstItem: CardTitleAndValueWidget("Repayment amount",
                  '₹${AppFunctions().parseIntoCommaFormat(_computeRePaymentAmount().toString())}',
                  previousValue: AppFunctions().parseIntoCommaFormat(
                      logic.loanDetailModel.totalRepayAmt)),
              secondItem: _computeShowPrincipalAmount(),
              itemSpace: logic.BOTTOM_ITEM_SPACE),
          LoanDetailsItemWidget(
              firstItem: CardTitleAndValueWidget("Interest amount",
                  '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.totalInterestPaid)}',
                  previousValue: AppFunctions()
                      .parseIntoCommaFormat(logic.loanDetailModel.totalProfit)),
              secondItem: _showUpComingEMI(),
              itemSpace: logic.BOTTOM_ITEM_SPACE),
          Divider(
            color: const Color(0xff161742).withOpacity(.5),
          ),
          LoanDetailsItemWidget(
              firstItem: CardTitleAndValueWidget(
                "Monthly EMI",
                '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.emiAmount)}',
              ),
              secondItem: CardTitleAndValueWidget(
                "Tenure",
                '${logic.loanDetailModel.tenure} months',
              ),
              itemSpace: logic.BOTTOM_ITEM_SPACE),
          const SizedBox(
            height: 25,
          ),
          _computePaymentHistoryCTA(),
        ],
      ),
    );
  }

  CardTitleAndValueWidget _computeShowPrincipalAmount() {
    if (LPCService.instance.activeCard?.loanProductCode != "FCL") {
      return CardTitleAndValueWidget("Principal amount",
          '₹${AppFunctions().parseIntoCommaFormat(logic.loanDetailModel.totalPrincipalPaid)}',
          previousValue: AppFunctions()
              .parseIntoCommaFormat(logic.loanDetailModel.loanAmount));
    }
    return CardTitleAndValueWidget(
      "Total EMI Paid",
      "${logic.loanDetailModel.emiPaid}",
      previousValue: logic.loanDetailModel.emiTotal.toString(),
    );
  }

  Widget _computePaymentHistoryCTA() {
    return logic.loanDetailModel.paymentHistoryEnabled
        ? Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: PillButton(
              text: "Transactions",
              onTap: logic.goToTransactionHistory,
              isSelected: false,
              leading: Res.transactions,
            ),
          )
        : const SizedBox();
  }

  Widget _bottomPaymentWidget(
      {required Widget body,
      required String buttonTitle,
      required void Function()? onTap,
      bool isButtonEnabled = true}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
          color: const Color(0xff161742).withOpacity(1),
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: body,
          ),
          const SizedBox(
            width: 10,
          ),
          _payButton(
            title: buttonTitle,
            onTap: onTap,
            enabled: isButtonEnabled,
          ),
        ],
      ),
    );
  }

  Widget _forecloseWidget() {
    return _bottomPaymentWidget(
      body: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: "Pay all EMIs to close your loan\n",
            style: _baseTitleTextStyle.copyWith(fontSize: 8),
          ),
          TextSpan(
            text: 'Know More.',
            style: _baseTitleTextStyle.copyWith(
              fontSize: 8,
              color: skyBlueColor,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = logic.onForeclosureKnowMoreClicked,
          ),
        ]),
      ),
      buttonTitle: "Pre-pay",
      onTap: logic.onForeclosePayClicked,
      isButtonEnabled: logic.loanDetailModel.isForeClosureEnabled,
    );
  }

  Widget _advanceEMIWidget() {
    return _bottomPaymentWidget(
      body: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Pre-pay single EMI before due date with ease ",
              style: _baseTitleTextStyle.copyWith(fontSize: 8),
            ),
            TextSpan(
              text: 'Know More.',
              style: _baseTitleTextStyle.copyWith(
                fontSize: 8,
                color: skyBlueColor,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = logic.onAdvanceEMIKnowMoreClicked,
            ),
          ],
        ),
      ),
      buttonTitle: "Pay EMI",
      onTap: logic.onAdvanceEMIPayClicked,
      isButtonEnabled:
          logic.loanDetailModel.advanceEMIPaymentTypeDetails.type ==
              PaymentTypeStatus.eligible,
    );
  }

  Widget _overdueBodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Transform.rotate(
              angle: 180 * pi / 180,
              child: const Icon(
                Icons.info,
                color: Color(0xFFFFF3EB),
                size: 16,
              )),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              "Overdue alert",
              style: _baseHeaderTitleTextStyle,
            ),
          ),
        ]),
        const SizedBox(
          height: 4,
        ),
        Text(
          "Pay now to stop accruing late fees and protect your credit profile.",
          style: _baseTitleTextStyle,
        ),
      ],
    );
  }

  Widget _partPayAlertWidget() {
    return _bottomPaymentWidget(
        body: _partPayAlertBodyWidget(),
        buttonTitle: 'Part Pay Now',
        onTap: logic.onPartPayClicked);
  }

  Widget _partPayAlertBodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 4,
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Ease your load with Part Pay's partial payment option!\n",
              style: _baseTitleTextStyle.copyWith(fontSize: 8),
            ),
            TextSpan(
              text: 'Know More.',
              style: _baseTitleTextStyle.copyWith(
                fontSize: 8,
                color: skyBlueColor,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = logic.onPartPayKnowMoreClicked,
            ),
          ]),
        )
      ],
    );
  }

  Widget _overdueAlertWidget() {
    return _bottomPaymentWidget(
      buttonTitle: "Pay Now",
      onTap: logic.onOverdueCTAClicked,
      body: _overdueBodyWidget(),
    );
  }

  Container _overDueAlert() {
    return Container(
      decoration: _alertDecoration(),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 6,
      ),
      child: Text(
        "Overdue",
        style: GoogleFonts.poppins(
            color: const Color(0xFFFFF3EB),
            fontSize: 8,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  BoxDecoration _alertDecoration() {
    return BoxDecoration(
      color: const Color(0xFFEE3D4B),
      borderRadius: BorderRadius.circular(50),
    );
  }

  Widget _showUpComingEMI() {
    return logic.loanDetailModel.emiPaid != logic.loanDetailModel.emiTotal
        ? dateTitleAndValue(
            "Upcoming EMI", DateTime.parse(logic.loanDetailModel.nextDueDate))
        : const CardTitleAndValueWidget("Upcoming EMI", "-");
  }

  double _computeRePaymentAmount() {
    return double.parse(logic.loanDetailModel.totalPrincipalPaid) +
        double.parse(logic.loanDetailModel.totalInterestPaid);
  }

  InkWell invoiceButtonWidget(String title, {dynamic Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF404040).withOpacity(1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Text(
            title,
            style: _subTitleTextStyle(
                color: const Color(0xFF404040), fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Widget _payButton(
      {required String title,
      required void Function()? onTap,
      bool enabled = true}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: enabled
                ? const Color(0xFFFFF3EB)
                : const Color(0xffFFF3EB).withOpacity(0.8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: _subTitleTextStyle(
                fontWeight: FontWeight.w500, color: const Color(0xFF1D478E)),
          ),
        ),
      ),
    );
  }

  InkWell _infoIcon({required Function onPressed}) {
    return InkWell(
        onTap: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: SvgPicture.asset(
            Res.info_icon,
          ),
        ));
  }

  Widget dateTitleAndValue(
    String title,
    DateTime value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: _titleTextStyle(),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          DayMonthYear(date: value),
        ],
      ),
    );
  }

  TextStyle _titleTextStyle(
      {double fontSize = 8, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize,
        letterSpacing: 0.18,
        fontWeight: fontWeight,
        fontFamily: 'Figtree',
        color: const Color(0xFF404040));
  }

  TextStyle _subTitleTextStyle(
      {FontWeight fontWeight = FontWeight.w600,
      Color color = const Color(0xFFFFF3EB)}) {
    return TextStyle(
        fontSize: 12,
        letterSpacing: 0.18,
        fontWeight: fontWeight,
        fontFamily: 'Figtree',
        color: color);
  }

  TextStyle get _baseTitleTextStyle {
    return GoogleFonts.poppins(
        fontSize: 7,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w300,
        color: const Color(0xFFFFF3EB));
  }

  TextStyle get _baseHeaderTitleTextStyle {
    return GoogleFonts.poppins(
        fontSize: 14,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFFFF0EB));
  }

  TextStyle get _headingTextStyle {
    return GoogleFonts.poppins(
        fontSize: 14,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1D478E));
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }

  computeShowElasticCreditLineType() {
    if (logic.loanDetailModel.elasticCreditLineType !=
        ElasticCreditLineType.none) {
      return CardTitleAndValueWidget("Credit Line Type",
          parseLpcCreditLineType(logic.loanDetailModel.elasticCreditLineType),
          iconWidget: _infoIcon(
        onPressed: () {
          _elasticClTypeBottomSheetEvents(
              logic.loanDetailModel.elasticCreditLineType);
        },
      ));
    }
    return const SizedBox();
  }

  parseLpcCreditLineType(ElasticCreditLineType elasticCreditLineType) {
    switch (elasticCreditLineType) {
      case ElasticCreditLineType.pure:
        return "Pure";
      case ElasticCreditLineType.hybrid:
        return "Hybrid";
      case ElasticCreditLineType.drop:
        return "Drop";
      case ElasticCreditLineType.none:
        return "";
    }
  }

  void _openAmountTransferredBottomSheet() {
    Get.bottomSheet(
      LoanInfoBottomSheet(
        sheetTitle: "Amount transferred",
        itemsBeforeDivider: [
          DetailItem(
            title: "Loan amount",
            value: num.parse(logic.loanDetailModel.loanAmount),
          ),
          DetailItem(
            title: "Processing fee (incl. GST)",
            value: num.parse(logic.loanDetailModel.processingFee),
          ),
          DetailItem(
            title: "Broken Period Interest (BPI)",
            value: num.parse(logic.loanDetailModel.bpiAmount),
          ),
          DetailItem(
            title: "Insurance premium",
            value: num.parse("0"),
          ),
        ],
        itemAfterDivider: DetailItem(
            title: "Amount transferred",
            value: num.parse(logic.loanDetailModel.disbursalAmount),
            isHighlighted: true),
        bottomWidget: const BpiInfoWidget(),
      ),
    );
  }

  _computeInProgressWidget() {
    switch(logic.loanDetailModel.isEmiPaymentInProgress) {
      case EmiPaymentStatus.inProgress:
        return _buildInProgressInfoWidget();
      case EmiPaymentStatus.closed:
        return const SizedBox.shrink();
      case EmiPaymentStatus.nextEmi:
        return _nextEMIWidget();
    }

  }
}
