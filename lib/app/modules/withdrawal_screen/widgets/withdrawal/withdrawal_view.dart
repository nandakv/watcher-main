import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/withdrawal_bank_details.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_error_page.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_screen_logic.dart';
import 'package:privo/components/skeletons/skeletons.dart';
import 'package:privo/res.dart';

import 'widgets/insurance_container/insurance_container_view.dart';
import 'widgets/loan_amount_card.dart';
import 'widgets/purpose_selector.dart';
import 'widgets/tenure_selector.dart';
import 'widgets/withdrawal_payment_breakout_widget.dart';
import 'withdrawal_logic.dart';

class WithdrawalView extends StatefulWidget {
  const WithdrawalView({Key? key}) : super(key: key);

  @override
  State<WithdrawalView> createState() => _WithdrawalViewState();
}

class _WithdrawalViewState extends State<WithdrawalView> with AfterLayoutMixin {
  final logic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawalLogic>(
        id: logic.withdrawalDetailsView,
        builder: (logic) {
          switch (logic.withdrawalState) {
            case WithdrawalState.loading:
              return const Center(
                  child: RotationTransitionWidget(
                loadingState: LoadingState.progressLoader,
              ));
            case WithdrawalState.success:
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                      ),
                      child: _onSuccess(),
                    ),
                  ),
                  bankDetailsWidget(logic)
                ],
              );
            case WithdrawalState.error:
              return WithdrawalErrorPage(
                  title:
                      "Sorry, Something went wrong while displaying your details. Please contact our support team.",
                  assetImage: Res.Rejected,
                  isSVG: true);
          }
        });
  }

  Widget bankDetailsWidget(WithdrawalLogic logic) {
    if (!logic.bankDetailsLoading) {
      return _onBankDetailsFetched(logic);
    }
    return _skeletonView();
  }

  Container _onBankDetailsFetched(WithdrawalLogic logic) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6,
            offset: Offset(0, -3),
          )
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WithdrawalBankDetails(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            child: GetBuilder<WithdrawalLogic>(
              id: logic.withdrawalButtonId,
              builder: (logic) {
                return GradientButton(
                  onPressed: logic.onWithdrawPressed,
                  isLoading: logic.withdrawalState == WithdrawalState.loading,
                  enabled: logic.isWithdrawButtonActive(),
                  title: "Next",
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _onSuccess() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24,
          ),
          LoanAmountCard(),
          const SizedBox(
            height: 15,
          ),

          ///Widget to select purpose
          PurposeSelector(),
          const SizedBox(
            height: 22,
          ),

          ///Displays the entire Tenure section including the bottom and top labels
          if (logic.computeShowTenure()) TenureSelector(),

          ///insurance container
          if (!logic.isPaymentDetailsLoading &&
              logic.withdrawalCalculationModel?.insuranceDetails != null)
            GetBuilder<WithdrawalLogic>(
              id: logic.INSURANCE_CONTAINER_ID,
              builder: (logic) {
                return InsuranceContainer();
              },
            ),

          ///Payment break out card
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Withdrawal OverView",
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),

          ///Add condtion to show only on flexiod once backend is ready
          WithdrawalPaymentBreakOutWidget(),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _skeletonView() => SkeletonItem(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  height: Get.height * 0.04,
                  width: Get.width),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      );

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
