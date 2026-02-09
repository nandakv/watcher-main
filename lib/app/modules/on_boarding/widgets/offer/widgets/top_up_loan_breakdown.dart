import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/model/top_up_break_down_data.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/check_box_tile_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/net_disbursal_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_Model.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_item_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';

class TopUpLoanBreakDown extends StatefulWidget {
  TopUpLoanBreakDown({super.key});

  @override
  State<TopUpLoanBreakDown> createState() => _TopUpLoanBreakDownState();
}

class _TopUpLoanBreakDownState extends State<TopUpLoanBreakDown> {
  final offerLogic = Get.find<OfferLogic>();

  late List<OfferTableModel> loanBreakDownList;
  late List<OfferTableModel> deductionBreakDownList;

  BorderSide borderSide = BorderSide(color: borderSkyBlueColor);

  @override
  void initState() {
    loanBreakDownList = TopUpLoanBreakDownPageData()
        .computeOfferTableModel(offerLogic.responseModel.offerSection);
    deductionBreakDownList = TopUpDeductionBreakDownData()
        .computeOfferTableModel(offerLogic.responseModel.offerSection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpacer(32),
                Text(
                  "Loan Breakdown",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: navyBlueColor,
                  ),
                ),
                const VerticalSpacer(16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: borderSkyBlueColor),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: _listPadding(),
                    child: _loanListBreakDown(loanBreakDownList),
                  ),
                ),
                const VerticalSpacer(4),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: borderSide,
                      left: borderSide,
                      right: borderSide,
                    ),
                  ),
                  child: Padding(
                    padding: _listPadding(),
                    child: _loanListBreakDown(deductionBreakDownList),
                  ),
                ),
                if (offerLogic.responseModel.insuranceDetails != null)
                  CheckBoxTileWidget(
                    offerServiceType: OfferServiceType.insurance,
                  ),
                if (offerLogic.responseModel.vasDetailsList != null) ...[
                  CheckBoxTileWidget(
                    offerServiceType: OfferServiceType.healthcare,
                  ),
                ],
                NetDisbursalWidget(border: Border(
                  left: borderSide,
                  right: borderSide,
                  bottom: borderSide,
                ),),

              ],
            ),
          ),
        ),
        const SizedBox(height: 20,),
        GetBuilder<OfferLogic>(
            id: offerLogic.BUTTON_ID,
            builder: (logic) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GradientButton(
              title: "Continue",
              onPressed: () =>
                  offerLogic.callRecordConsent(),
              isLoading: offerLogic.isButtonLoading,
            ),
          );
        })
      ],
    );
  }




  EdgeInsets _listPadding() {
    return const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    );
  }

  ListView _loanListBreakDown(List<OfferTableModel> breakDownList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: breakDownList.length,
      itemBuilder: (BuildContext context, int index) {
        return OfferTableItemWidget(offerTableModel: breakDownList[index]);
      },
    );
  }
}
