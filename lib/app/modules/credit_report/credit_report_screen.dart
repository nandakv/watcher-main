import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/contact_us/contact_us_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/credit_account_details/credit_account_details_screen.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/widgets/all_credit_loans.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_know_more_v2_widget.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_line_graph/credit_score_update_screen.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_score_line_graph/credit_scoreline_graph_model.dart';
import 'package:privo/app/modules/credit_report/widgets/key_metrics_screen.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_widget.dart';
import 'package:privo/app/modules/credit_report/widgets/report_screen.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/know_more_widget.dart';
import 'package:privo/app/common_widgets/failure_page.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';

import '../../../res.dart';
import '../stateless_credit_score/stateless_credit_score_view.dart';
import 'credit_report_helper_mixin.dart';
import 'widgets/credit_score_processing_screen.dart';

class CreditReportScreen extends StatelessWidget {
  CreditReportScreen({Key? key}) : super(key: key);

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onBackClicked,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GetBuilder<CreditReportLogic>(builder: (logic) {
            switch (logic.currentCreditReportState) {
              case CreditReportState.loading:
                return _loadingScreen();
              case CreditReportState.knowMore: //data page  view false and appform is not empty than knowmore
                return logic.computeKnowMoreScreen();
              case CreditReportState.polling:
                return _creditReportProcessingWidget(context);
              case CreditReportState.success:
                return _creditReportSuccessScreen();
              case CreditReportState.failure:
                return _creditScoreFailureScreen();
              case CreditReportState.dashboard:
                return ReportScreen();
              case CreditReportState.accountDetails:
                return const CreditAccountDetailsScreen();
              case CreditReportState.creditOverview:
                return AllCreditLoans();
              case CreditReportState.keyMetricView:
                return KeyMetricsScreen();
              case CreditReportState.statelessKnowMore: //data page  view false and appform is empty than statelessKnowMore
                return  CreditScoreDetailsView();
              case CreditReportState.scoreUpdateStatus:
                return CreditScoreUpdateScreen();
            }
          }),
        ),
      ),
    );
  }

  Widget _loadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _creditScoreFailureScreen() {
    return FailurePage(
      title: "Something Went Wrong!",
      message:
          "Looks like there was an issue fetching your details. Please try again",
      illustration: Res.aaFailure,
      ctaTitle: "Try Again",
      onCtaClicked: () =>
          logic.computeOnTryAgainClicked(),
      onBackClicked: logic.onBackClicked,
      bottomWidget: ContactUsWidget(
        title: "Having trouble?",
        subTitle: "Contact Customer Support",
      ),
    );
  }

  Widget _creditReportProcessingWidget(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Column(
          children: [
            Expanded(
              child: PollingScreen(
                isV2: true,
                assetImagePath: Res.creditScoreInProgress,
                titleLines: const ["Retrieving your Credit Score..."],
                bodyTexts: const ["Sit tight, it's almost here!"],
                progressIndicatorText: "This usually takes about 30 seconds",
                onClosePressed: logic.onPollingClosePressed,
                stopPollingCallback: logic.stopExperianPolling,
                startPollingCallback: logic.startExperianPolling,
              ),
            ),
            const VerticalSpacer(16),
            const PoweredByWidget(
              logo: Res.experianLogo,
            ),
            const VerticalSpacer(36),
          ],
        ),
      ),
    );
  }



  Widget _successBottomWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 35.0,
      ),
      child: GradientButton(
        onPressed: logic.onSuccessContinue,
        title: "View Details",
      ),
    );
  }

  Widget _creditReportSuccessScreen() {
    return CreditScoreProcessingScreen(
      title: logic.creditScoreScale.successScreenTitle,
      bodyText: "Your Credit Score is...",
      creditScoreData: logic.creditScoreScale,
      creditScore: logic.creditReport.score.toString(),
      assetImagePath: Res.creditScoreSuccess,
      replaceProgressWidget: _successBottomWidget(),
      onBackPress: logic.onBackClicked,
    );
  }
}
