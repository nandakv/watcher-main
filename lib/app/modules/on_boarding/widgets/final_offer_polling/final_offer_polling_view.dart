import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/about_co_applicant_details.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/having_trouble_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/document_upload_tile/document_upload_tile.dart';
import 'package:privo/app/modules/document_upload_tile/document_upload_tile_logic.dart';
import 'package:privo/app/modules/document_upload_tile/model/document_upload_tile_details.dart';
import 'package:privo/app/modules/on_boarding/widgets/about_co_applicant/add_co_applicant_page.dart';
import 'package:privo/app/modules/on_boarding/widgets/final_offer_polling/final_offer_polling_logic.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class FinalOfferPollingPage extends StatefulWidget {
  const FinalOfferPollingPage({Key? key}) : super(key: key);

  @override
  State<FinalOfferPollingPage> createState() => _FinalOfferPollingPageState();
}

class _FinalOfferPollingPageState extends State<FinalOfferPollingPage>
    with AfterLayoutMixin {
  final logic = Get.find<FinalOfferPollingLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onPopInvoked,
      child: GetBuilder<FinalOfferPollingLogic>(
        builder: (logic) {
          switch (logic.finalOfferPollingState) {
            case FinalOfferPollingState.finalOfferInProgress:
              return _finalOfferPolling();
            case FinalOfferPollingState.additionalDetails:
              return _additionalDetails();
            case FinalOfferPollingState.coApplicant:
              return _coApplicant();
            case FinalOfferPollingState.loading:
              return _loading();
          }
        },
      ),
    );
  }

  Column _loading() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotationTransitionWidget(loadingState: LoadingState.progressLoader)
      ],
    );
  }

  GetBuilder<FinalOfferPollingLogic> _coApplicant() {
    return GetBuilder<FinalOfferPollingLogic>(builder: (logic) {
      return AddCoApplicantPage(
        coApplicantDetail: logic.coApplicantDetailsList.isNotEmpty
            ? logic.coApplicantDetailsList.first
            : null,
        applicantNumber: logic.applicantNumber,
        applicantPan: logic.applicantPan,
      );
    });
  }

  Widget _additionalDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const VerticalSpacer(32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (logic.shouldShowCoApplicantDetails()) ...[
                    AboutCoApplicantDetails(
                      title: logic.coApplicantDetailsList.isNotEmpty
                          ? "Co-applicant Details"
                          : "About Co-Applicant",
                      onTapCoApplicantEdit: logic.onCoApplicantEdit,
                      coApplicantDetailsList: logic.coApplicantDetailsList,
                      onTapAddCoApplicant: logic.onTapAddCoApplicant,
                    ),
                    verticalSpacer(56),
                  ],
                  const Text(
                    "Documents",
                    style: TextStyle(
                      color: navyBlueColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  verticalSpacer(6),
                  const Text(
                    "Upload files PDF, JPEG, PNG formats under 20 MB. Ensure clarity and name files descriptively",
                    style: TextStyle(
                        fontSize: 10, height: 1.3, color: darkBlueColor),
                  ),
                  verticalSpacer(16),
                  DocumentUploadTile(
                    documentUploadTileDetails: DocumentUploadTileDetails(
                      isFromFinalOffer: true,
                      entityId: '',
                      hideAddDeleteIcon: true,
                      tag: DocumentUploadTileLogic.FINAL_OFFER_POLLING_TAG,
                      title: "Additional Document",
                      onAllFileDeleted: () async {
                        logic.validateForm();
                      },
                      onChanged: logic.validateForm,
                      docSection: logic.docSection,
                      isUntagged: false,
                      onInfoTapped: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalSpacer(30),
          GetBuilder<FinalOfferPollingLogic>(
            id: logic.BUTTON_ID,
            builder: (_) {
              return GradientButton(
                enabled: logic.buttonEnabled,
                isLoading: logic.isButtonLoading,
                bottomPadding: 30,
                onPressed: logic.onFinalOfferAddCoApplicant,
                title: "Add",
              );
            },
          ),
        ],
      ),
    );
  }

  PollingScreen _finalOfferPolling() {
    return PollingScreen(
      isV2: true,
      bodyTextPadding: 10,
      assetImagePath: Res.offer_polling,
      titleLines: logic.titleTexts,
      bodyTexts: logic.bodyTexts,
      onClosePressed: logic.onClosePressed,
      widgetBelowIllustration: _additionalDetailsWidget(),
      replaceProgressWidget: HavingTroubleWidget(
        screenName: "FINAL_OFFER_POLLING",
      ),
    );
  }

  Widget _additionalDetailsWidget() {
    return InkWell(
      onTap: logic.onAdditionalDetailsClicked,
      child: Container(
        decoration: _additonalDetailsDecoration(),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _additonalDetailsTitle(),
            verticalSpacer(8),
            _subTitle(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _additonalDetailsDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        width: 1,
        color: darkBlueColor,
      ),
    );
  }

  Text _subTitle() {
    return const Text(
      "In case Credit Saison India reaches out for any additional details to generate final offer, add your details",
      style: TextStyle(
          color: secondaryDarkColor, fontWeight: FontWeight.w500, fontSize: 10),
    );
  }

  Row _additonalDetailsTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Provide additional details "),
        SvgPicture.asset(Res.pollingArrow)
      ],
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
