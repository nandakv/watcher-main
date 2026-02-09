import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/top_navigation_bar.dart';
import 'package:privo/app/modules/servicing_home_screen/active_closed_loans.dart';
import 'package:privo/app/modules/servicing_home_screen/loans_tab_model.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';

import '../../../res.dart';
import '../../models/loans_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/multi_lpc_faq.dart';
import 'servicing_home_screen_logic.dart';
import 'widgets/empty_loan_widget.dart';

class ServicingAllWithdrawalScreen extends StatelessWidget {
  ServicingAllWithdrawalScreen({Key? key}) : super(key: key);

  final logic = Get.find<ServicingHomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: logic.isPageLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TopNavigationBar(
                  title: logic.computeTitle(),
                  trailing: InkWell(
                    onTap: () {
                      MultiLPCFaq(
                        lpcCard: logic.lpcCard(),
                      ).openMultiLPCBottomSheet(
                        onPressContinue: () {},
                      );
                    },
                    child: SvgPicture.asset(Res.helpAppBar),
                  ),
                ),
                _tabBar(),
                Expanded(
                  child: GetBuilder<ServicingHomeScreenLogic>(
                    id: logic.TABBAR_VIEW_ID,
                    builder: (logic) {
                      return _loanListingWidget();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _loanListingWidget() {
    return logic.tabBarViewLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : logic.lpcTabList.length == 1
            ? _computeLoanState(logic.lpcTabList.first)
            : TabBarView(
                physics: logic.tabBarViewLoading
                    ? const NeverScrollableScrollPhysics()
                    : null,
                controller: logic.tabController,
                children: logic.lpcTabList
                    .map((loanTab) => _computeLoanState(loanTab))
                    .toList(),
              );
  }

  Widget _tabBar() {
    return GetBuilder<ServicingHomeScreenLogic>(
      id: logic.TABBAR_VIEW_ID,
      builder: (logic) {
        return logic.lpcTabList.length == 1
            ? const SizedBox()
            : Container(
                width: double.infinity,
                decoration: _tabBarDecoration(),
                padding: const EdgeInsets.only(left: 4),
                child: IgnorePointer(
                  ignoring: logic.tabBarViewLoading,
                  child: TabBar(
                    physics: logic.tabBarViewLoading
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    controller: logic.tabController,
                    tabAlignment: TabAlignment.start,
                    tabs: logic.lpcTabList
                        .map(
                          (loanTab) => Tab(
                            text: loanTab.title,
                          ),
                        )
                        .toList(),
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: _tabIndicatorDecoration(),
                    labelStyle: _activeTabLabelStyle(),
                    labelColor: navyBlueColor,
                    unselectedLabelColor: secondaryDarkColor,
                    unselectedLabelStyle: _inActiveTabLabelStyle(),
                  ),
                ),
              );
      },
    );
  }

  Widget _computeLoanState(LoansTabModel loanTab) {
    switch (loanTab.state) {
      case LoanTabState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoanTabState.empty:
        return const EmptyLoanWidget();
      case LoanTabState.success:
        return _loanListWidget(loanTab);
      case LoanTabState.error:
        return _loanTabErrorStateWidget();
    }
  }

  Widget _loanTabErrorStateWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Res.bank_verify_failure,
            height: 160,
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            "Error!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryDarkColor,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            "Encountering a glitch while loading details.\nRefresh to retry.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: secondaryDarkColor,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: logic.onTapLoanTabRetry,
            child: Container(
              decoration: BoxDecoration(
                color: darkBlueColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  "Refresh",
                  style: TextStyle(
                    color: offWhiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loanListWidget(LoansTabModel loanTab) {
    if (loanTab.loansModel == null) return const SizedBox();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (logic.loanNotPresent(loanTab)) _noLoanWidget(),
          if (loanTab.loansModel!.activeLoans.isNotEmpty) ...[
            _titleWidget(
              title: "Active loans",
              count: loanTab.loansModel!.activeLoans.length,
            ),
            VerticalSpacer(24.h),
            _activeClosedLoansList(
                itemCount: loanTab.loansModel!.activeLoans.length,
                loansList: loanTab.loansModel!.activeLoans)
          ],
          if (loanTab.loansModel!.activeLoans.isNotEmpty)
            SizedBox(
              height: 56.h,
            ),
          if (loanTab.loansModel!.closedLoans.isNotEmpty) ...[
            _titleWidget(
              title: "Closed loans",
              count: loanTab.loansModel!.closedLoans.length,
            ),
            VerticalSpacer(24.h),
            _activeClosedLoansList(
              itemCount: loanTab.loansModel!.closedLoans.length,
              loansList: loanTab.loansModel!.closedLoans,
            ),
          ]
        ],
      ),
    );
  }

  Widget _titleWidget({
    required String title,
    required int count,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.headingSMedium(
            color: AppTextColors.primaryNavyBlueHeader,
          ),
        ),
        HorizontalSpacer(8.w),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppTextColors.brandBlueBodyFocus,
          ),
          height: 24.h,
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          child: Center(
            child: Text(
              "$count",
              style: AppTextStyles.bodyMMedium(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _tabBarDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: lightGrayColor,
          width: 0.6,
        ),
      ),
    );
  }

  UnderlineTabIndicator _tabIndicatorDecoration() {
    return UnderlineTabIndicator(
      borderRadius: BorderRadius.circular(2),
      borderSide: const BorderSide(
        color: goldColor,
        width: 2,
      ),
    );
  }

  TextStyle _inActiveTabLabelStyle() {
    return const TextStyle(
      fontFamily: 'Figtree',
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );
  }

  TextStyle _activeTabLabelStyle() {
    return const TextStyle(
      fontFamily: 'Figtree',
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );
  }

  Widget _noLoanWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 120.0),
        child: Text(
          "You haven’t made any withdrawals yet",
          style: TextStyle(
              color: darkBlueColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.9),
        ),
      ),
    );
  }

  ListView _activeClosedLoansList(
      {required int itemCount, required List<Loans> loansList}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) {
        return SizedBox(height: 12.h);
      },
      itemBuilder: (context, index) {
        return Padding(
          padding: loansList[index].loanPaymentStatus == LoanPaymentStatus.none
              ? EdgeInsets.zero
              : EdgeInsets.only(top: 12.h),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              GradientBorderContainer(
                borderRadius: 8.r,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.r),
                          ),
                          child: SvgPicture.asset(Res.loanListBGSVG),
                        ),
                      ),
                    ),
                    ActiveClosedLoans(
                      loans: loansList[index],
                      index: index,
                    ),
                  ],
                ),
              ),
              if (loansList[index].loanPaymentStatus != LoanPaymentStatus.none)
                Positioned(
                  top: -14,
                  left: 14,
                  child: CSBadge(
                    text: computeText(loansList[index]),
                    bgColor: computeColor(loansList[index]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

computeColor(Loans loans) {
  switch (loans.loanPaymentStatus) {
    case LoanPaymentStatus.advanceEMI:
      return darkBlueColor;
    case LoanPaymentStatus.overdue:
    case LoanPaymentStatus.pendingAmount:
      return red;
  }
}

computeText(Loans loans) {
  switch (loans.loanPaymentStatus) {
    case LoanPaymentStatus.advanceEMI:
      return "Pay in advance";
    case LoanPaymentStatus.overdue:
      return "Overdue";
    case LoanPaymentStatus.pendingAmount:
      return "Pending amount";
  }
}
