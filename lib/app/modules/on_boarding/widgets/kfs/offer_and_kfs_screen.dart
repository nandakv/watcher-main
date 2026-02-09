import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/top_up_loan_breakdown.dart';
import '../../../../services/privo_pdf_service/privo_pdf_widget_view.dart';
import '../../../../theme/app_colors.dart';
import '../../model/privo_app_bar_model.dart';
import '../consent_check/consent_check.dart';
import '../offer/offer_screen.dart';
import '../offer/widgets/cross_sell_breakdown_widget.dart';
import '../privo_app_bar/privo_app_bar.dart';
import '../offer/offer_logic.dart';

class OfferAndKFSScreen  extends StatefulWidget {
  const OfferAndKFSScreen({Key? key}) : super(key: key);

  @override
  State<OfferAndKFSScreen> createState() => _OfferAndKFSScreenState();
}

class _OfferAndKFSScreenState extends State<OfferAndKFSScreen>
    with AfterLayoutMixin {
  final offerLogic = Get.find<OfferLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<OfferLogic>(
          builder: (logic) {
            return Container(color: Colors.white,
                child: _bodyWidget(offerLogic));
          },
        ),
      ),
    );
  }

  Widget _bodyWidget(OfferLogic offerLogic) {
    switch (offerLogic.kfsScreenState) {
      case KfsScreenState.offer:
        return const OfferScreen();
      case KfsScreenState.loading:
        return _loadingWidget();
      case KfsScreenState.consentOne:
        return _consentOneWidget();
      case KfsScreenState.consentTwo:
        return _consentTwoWidget();
      case KfsScreenState.topUpLoanBreakDown:
        return TopUpLoanBreakDown();
    }
  }
 //KFS Consent 1 of 2
  Column _consentOneWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 30, top: 30,bottom: 15),
            child: Text(
              offerLogic.consentPageTitle,
              style: _consentPageTextStyle(),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              child: _consentOneBody(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: GradientButton(
            title: "Agree and Confirm",
            onPressed: offerLogic.onconsentOneCtaClick,
          ),
        ),
      ],
    );
  }

  TextStyle _consentPageTextStyle() {
    return GoogleFonts.poppins(
        fontWeight: FontWeight.w600, fontSize: 14, color: navyBlueColor);
  }

  Widget _consentOneBody() {
    switch (offerLogic.offerServiceType) {
      case OfferServiceType.insurance:
        return CrossSellBreakDownWidget(
          title: 'Insurance Details',
          detailsList:
              offerLogic.insuranceDetails!.initInsuranceDetailsItemList(),
          clausesList: offerLogic.insuranceDetails!.clauses,
          knowMoreClicked: true,
          renderType: RenderType.section,
        );
      case OfferServiceType.healthcare:
        return CrossSellBreakDownWidget(
          title: 'Healthcare Package Details',
          clausesList: offerLogic.vasDetails!.clauses,
          detailsList: offerLogic.vasDetails!.initHealthcareDetailsItemList(),
          knowMoreClicked: true,
          renderType: RenderType.section,
        );
      case OfferServiceType.insuranceHealthcare:
        return Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            CrossSellBreakDownWidget(
              title: 'Insurance Details',
              detailsList:
                  offerLogic.insuranceDetails!.initInsuranceDetailsItemList(),
              knowMoreClicked: true,
              offerServiceType: OfferServiceType.insuranceHealthcare,
              renderType: RenderType.section,
            ),
            CrossSellBreakDownWidget(
              title: 'Healthcare Package Details',
              detailsList:
                  offerLogic.vasDetails!.initHealthcareDetailsItemList(),
              clausesList: offerLogic.insuranceDetails!.clauses +
                  offerLogic.vasDetails!.clauses,
              knowMoreClicked: true,
              offerServiceType: OfferServiceType.healthcare,
              renderType: RenderType.section,
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  //KFS loading
  Column _loadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        verticalSpacer(20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            'Your Key Fact Statement is loading. Please wait for a few seconds.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: darkBlueColor,
                fontSize: 12,
                fontFamily: 'Figtree',
                letterSpacing: .8),
          ),
        ),
      ],
    );
  }

  //KFS Consent 2 of 2
  Column _consentTwoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpacer(20),
        if (offerLogic.consentPageTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Text(
              offerLogic.consentPageTitle,
              style: _consentPageTextStyle(),
            ),
          ),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Text(
            'Key Fact Statement',
            style:GoogleFonts.poppins(
              color: primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: PrivoPDFWidget(
            fileName: offerLogic.fileName,
            url: offerLogic.pdfDownloadURL,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _checkBoxWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GetBuilder<OfferLogic>(
              id: 'button',
              builder: (logic) {
                return GradientButton(
                  isLoading: offerLogic.isButtonLoading,
                  title: "Agree and Confirm",
                  enabled: logic.consentCheckBoxValue ? true : false,
                  onPressed: () => logic.onKycProceed(),
                );
              }),
        ),
        verticalSpacer(20)
      ],
    );
  }

  GetBuilder<OfferLogic> _checkBoxWidget() {
    return GetBuilder<OfferLogic>(
          id: 'checkBox',
          builder: (offerLogic) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CheckBoxWithText(
                  value: offerLogic.consentCheckBoxValue,
                  onChanged: (value) {
                    if (value != null) {
                      offerLogic.consentCheckBoxValue = value;
                    }
                  },
                  consentText:
                      "I have reviewed the Key Fact Sheet, including the APR computation and repayment schedule, and hereby consent to Kisetsu Saison Finance India Pvt. Ltd. to proceed with my loan application."),
            );
          });
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    return offerLogic.afterLayout();
  }
}
