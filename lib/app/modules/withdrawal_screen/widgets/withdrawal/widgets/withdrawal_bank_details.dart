import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/account_details_widget.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/components/skeletons/skeletons.dart';
import 'package:privo/res.dart';

class WithdrawalBankDetails extends StatelessWidget {
  WithdrawalBankDetails({Key? key}) : super(key: key);

  final logic = Get.find<WithdrawalLogic>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: GetBuilder<WithdrawalLogic>(
        id: logic.BANK_DETAILS_EXPANSION_ID,
        builder: (logic) {
          return ExpansionTile(
            tilePadding: const EdgeInsets.only(
              left: 16.0,
              right: 12,
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _amountDetails(logic),
            ),
            backgroundColor: Colors.transparent,
            initiallyExpanded: false,
            onExpansionChanged: (value) {
              logic.isAccountDetailsExpanded = value;
            },
            trailing: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE2E2E2),
              ),
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(logic.isAccountDetailsExpanded
                  ? Res.chevron_down_svg
                  : Res.chevronUp),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: AccountDetailsWidget(
                    accountNumber: logic.accountNumber,
                    bankName: logic.bankName,
                    title: ''),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _amountDetails(WithdrawalLogic logic) {
    return GetBuilder<WithdrawalLogic>(
      id: logic.NET_DISBURSAL_ID,
      builder: (logic) {
        return RichText(
          text: TextSpan(
            children: [
              logic.isPaymentDetailsLoading
                  ? _netDisbursalAmountLoadingWidget()
                  : TextSpan(
                      text: _fetchWithdrawalAmount(logic),
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF161742),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.19),
                    ),
              const TextSpan(
                  text: " will be transferred to",
                  style: TextStyle(
                      color: Color(0xFF707070),
                      fontSize: 10,
                      fontWeight: FontWeight.w400)),
              if (!logic.isAccountDetailsExpanded) ...[
                WidgetSpan(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 4, right: 4, bottom: 2),
                    child: SvgPicture.asset(
                      Res.default_bank,
                      alignment: Alignment.topCenter,
                      height: 12,
                      width: 12,
                    ),
                  ),
                ),
                TextSpan(
                  text: _fetchMaskedAccountNumber(logic),
                  style: const TextStyle(
                      color: Color(0xFF707070),
                      fontSize: 10,
                      fontWeight: FontWeight.w400),
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  WidgetSpan _netDisbursalAmountLoadingWidget() {
    return const WidgetSpan(
      child: SizedBox(
        width: 40,
        child: SkeletonItem(
          child: SkeletonLine(),
        ),
      ),
    );
  }

  _fetchMaskedAccountNumber(WithdrawalLogic logic) {
    if (logic.accountNumber.isNotEmpty) {
      return "XX${logic.accountNumber.substring(logic.accountNumber.length - 4)}";
    }
  }

  _fetchWithdrawalAmount(WithdrawalLogic logic) {
    if (logic.withdrawalCalculationModel != null &&
        logic.withdrawalCalculationModel!.disbursedAmount != null) {
      return "₹ ${AppFunctions().parseIntoCommaFormat(logic.netDisbursalAmount.toString())} ";
    }
  }
}
