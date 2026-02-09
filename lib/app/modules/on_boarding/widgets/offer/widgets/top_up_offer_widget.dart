import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/net_disbursal_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_item_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';

class TopUpOfferWidget extends StatelessWidget {
  TopUpOfferWidget({super.key});

  final logic = Get.find<OfferLogic>();

  BorderSide borderSide = const BorderSide(color: borderSkyBlueColor);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(Res.close_x_mark_svg),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _loanDetailsWidget(),
          ),
        ),
      ],
    );
  }

  Widget _loanDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _topWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              _loanBreakDownText(),
              const VerticalSpacer(8),
              _loanBreakDownTable(),
              NetDisbursalWidget(removeAddOns: true,title: "Disbursal Amount",border: Border(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
              ),),
              const VerticalSpacer(16),
              _noteWidget()
            ],
          ),
        )
      ],
    );
  }

  BoxDecoration _netDisbursalContainerDecoration() {
    return BoxDecoration(
      color: lightSkyBlueColor,
      border: Border(
        bottom: _borderSide(),
        left: _borderSide(),
        right: _borderSide(),
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
    );
  }

  BorderSide _borderSide() => const BorderSide(color: Colors.blue, width: 1.0);

  Container _loanBreakDownTable() {
    return Container(
      decoration: _tableDecoration(),
      child: Padding(
        padding: _tablePadding(),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logic.responseModel.loanBreakDownData.length,
          itemBuilder: (BuildContext context, int index) {
            return OfferTableItemWidget(
              offerTableModel: logic.responseModel.loanBreakDownData[index],
              padding: const EdgeInsets.symmetric(vertical: 4),
            );
          },
        ),
      ),
    );
  }

  EdgeInsets _tablePadding() {
    return const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    );
  }

  BoxDecoration _tableDecoration() {
    return BoxDecoration(
      border: Border.all(color: borderSkyBlueColor),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    );
  }

  Text _noteWidget() {
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: "Note: ", style: _noteTextStyle()),
        TextSpan(
            text:
                "The total outstanding balance on your current loan will be settled internally. However, please note that daily interest will continue to accrue until the disbursement date.",
            style: _noteDetailTextStyle())
      ]),
      textAlign: TextAlign.left,
    );
  }

  TextStyle _noteDetailTextStyle() {
    return const TextStyle(
      color: secondaryDarkColor,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle _noteTextStyle() {
    return const TextStyle(
      color: navyBlueColor,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }

  Align _loanBreakDownText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Loan Breakdown",
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: primaryDarkColor),
      ),
    );
  }

  Stack _topWidget() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Congratulations, ${logic.firstName}!",
              style: GoogleFonts.poppins(
                  color: navyBlueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const VerticalSpacer(24),
            const Text(
              "You are eligible for a top-up amount of",
              style: TextStyle(
                  fontSize: 14,
                  color: darkBlueColor,
                  fontWeight: FontWeight.w400),
            ),
            _offerAmount(),
          ],
        ),
        SvgPicture.asset(Res.topUpOffer)
      ],
    );
  }

  Text _offerAmount() {
    return Text.rich(
      TextSpan(
        text: "₹",
        children: [
          TextSpan(
            text: logic.fetchLoanAmount(),
            style: titleTextStyle(
              fontSize: 40,
            ),
          ),
        ],
      ),
      style: titleTextStyle(
        fontSize: 40,
        isFigtree: true,
      ),
      textAlign: TextAlign.center,
    );
  }

  TextStyle titleTextStyle({double? fontSize, bool isFigtree = false}) {
    return isFigtree
        ? TextStyle(
            fontSize: fontSize ?? 24,
            fontWeight: FontWeight.w600,
            color: navyBlueColor,
          )
        : GoogleFonts.poppins(
            fontSize: fontSize ?? 24,
            fontWeight: FontWeight.w600,
            color: navyBlueColor,
          );
  }
}
