import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_agreement/low_and_grow_agreement_logic.dart';

import '../../../on_boarding/model/privo_app_bar_model.dart';
import '../../../on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import 'widgets/low_and_grow_special_offer_card.dart';
import '../../../../common_widgets/gradient_button.dart';
import '../../../../firebase/analytics.dart';
import '../../../../services/privo_pdf_service/privo_pdf_widget_view.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../low_and_grow_logic.dart';

class LowAndGrowAgreementScreen extends StatefulWidget {
  const LowAndGrowAgreementScreen({Key? key}) : super(key: key);

  @override
  State<LowAndGrowAgreementScreen> createState() =>
      _LowAndGrowAgreementScreenState();
}

class _LowAndGrowAgreementScreenState extends State<LowAndGrowAgreementScreen>
    with AfterLayoutMixin {
  final logic = Get.find<LowAndGrowAgreementLogic>();
  final lowAndGrowLogic = Get.find<LowAndGrowLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          PrivoAppBar(
              model: PrivoAppBarModel(
                  title: '',
                  isTitleVisible: false,
                  progress: 0.0,
                  onClosePressed: () {
                    Get.back();
                    AppAnalytics.trackWebEngageEventWithAttribute(
                        eventName: WebEngageConstants.lgLineAgreementCancelled);
                  },
                  appBarText: 'Upgrade Limit'),
              showFAQ: true),
          Expanded(
            child: GetBuilder<LowAndGrowAgreementLogic>(
                id: "low_and_grow_agreement_id",
                builder: (logic) {
                  return logic.isPageLoading
                      ? _loadingWidget()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SpecialOfferCard(
                                specialOffer: lowAndGrowLogic
                                    .computeSpecialOfferDetails(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: PrivoPDFWidget(
                                  fileName: logic.fileName,
                                  url: logic.pdfDownloadURL,
                                ),
                              ),
                              GetBuilder<LowAndGrowAgreementLogic>(
                                  id: "low_and_grow_accept_button_id",
                                  builder: (logic) {
                                    return Column(
                                      children: [
                                        GradientButton(
                                          bottomPadding: 32,
                                          isLoading: logic.isButtonLoading,
                                          onPressed: () {
                                            logic.onAcceptPressed();
                                          },
                                          title: "Accept",
                                        ),
                                        if (!logic.isButtonLoading)
                                          InkWell(
                                            onTap: () {
                                              AppAnalytics
                                                  .trackWebEngageEventWithAttribute(
                                                      eventName: WebEngageConstants
                                                          .lgLineAgreementCancelled);
                                              Get.back();
                                            },
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Text(
                                                  "Cancel",
                                                  style: _titleTextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        );
                }),
          ),
        ],
      ),
    ));
  }

  TextStyle get appBarTextStyle {
    return GoogleFonts.poppins(
      fontSize: 14,
      color: const Color(0xFF161742),
      letterSpacing: 0.11,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle _titleTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      letterSpacing: 0.18,
      fontWeight: fontWeight,
      color: const Color(0xff1D478E),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.afterLayout();
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
