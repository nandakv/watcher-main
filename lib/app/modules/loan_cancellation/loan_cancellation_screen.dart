import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/faq/faq_model.dart';
import 'package:privo/app/modules/faq/faq_utility.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../theme/app_text_theme.dart';
import '../faq/widget/faq_list_widget.dart';
import '../on_boarding/model/privo_app_bar_model.dart';
import '../on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import 'loan_cancellation_logic.dart';

class LoanCancellationScreen extends StatelessWidget {
  LoanCancellationScreen({Key? key}) : super(key: key);

  final logic = Get.find<LoanCancellationLogic>();

  Widget _appbar() {
    return PrivoAppBar(
      showFAQ: true,
      lpcCard: LPCService.instance.activeCard,
      model: PrivoAppBarModel(
        title: "",
        progress: 0,
        isAppBarVisible: true,
        isTitleVisible: false,
        appBarText: "Cancellation #${logic.loanId}",
      ),
    );
  }

  Widget _titleWidget(String title,
      {double size = 12, FontWeight fontWeight = FontWeight.w500}) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: fontWeight,
        color: darkBlueColor,
      ),
    );
  }

  Widget _loanCancellationInfo() {
    return Text(
      "Loan cancellation is now available on the Credit Saison India Mobile App. If you've withdrawn funds from your Privo Instant Loan and they've been disbursed, you can cancel the transaction within 3 to 6 days post-disbursement ",
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: darkBlueColor,
      ),
    );
  }

  Widget _proceedToCancellationCTA() {
    return InkWell(
      onTap: logic.onProceedToCancellationCTA,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Text("Proceed to cancellation", style: hyperlinkStyle()),
      ),
    );
  }

  Widget _faqWidget() {
    return FAQListWidget(
      faqModel: FAQUtility().loanCancellationFAQs,
    );
  }

  Widget _loanCancellationInfoPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget("Loan Cancellation"),
        verticalSpacer(16),
        _loanCancellationInfo(),
        verticalSpacer(8),
        _proceedToCancellationCTA(),
        verticalSpacer(32),
        _titleWidget("Frequently Asked Questions"),
        verticalSpacer(18),
        Expanded(child: _faqWidget()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _appbar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: GetBuilder<LoanCancellationLogic>(builder: (logic) {
                  switch (logic.loanCancellationStage) {
                    case LoanCancellationStage.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      return _loanCancellationInfoPage();
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
