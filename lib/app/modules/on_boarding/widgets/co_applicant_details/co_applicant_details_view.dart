import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/about_co_applicant_details.dart';
import 'package:privo/app/common_widgets/common_text_fields/sbd_desingation_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/sbd_shareholding_field.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/forms/ownership_details_form.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/co_applicant_list_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/widgets/add_co_applicant_page.dart';

import '../../../../theme/app_colors.dart';

class CoApplicantDetailsView extends StatefulWidget {
  const CoApplicantDetailsView({Key? key}) : super(key: key);

  @override
  State<CoApplicantDetailsView> createState() => _CoApplicantDetailsViewState();
}

class _CoApplicantDetailsViewState extends State<CoApplicantDetailsView>
    with AfterLayoutMixin {
  final logic = Get.find<CoApplicantDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoApplicantDetailsLogic>(
      id: logic.PAGE_ID,
      builder: (logic) {
        return PopScope(
          canPop: logic.coApplicantState == CoApplicantState.businessDetails,
          onPopInvoked: (didPop) {
            if (logic.coApplicantState == CoApplicantState.coApplicant) {
              logic.onCloseAddCoApplicantPage();
              return;
            }
          },
          child: _computeState(),
        );
      },
    );
  }

  Widget _computeState() {
    switch (logic.coApplicantState) {
      case CoApplicantState.loading:
        return const Center(child: CircularProgressIndicator());
      case CoApplicantState.businessDetails:
        return _businessDetailsWidget();
      case CoApplicantState.coApplicant:
        return GetBuilder<CoApplicantDetailsLogic>(
          builder: (logic) {
            return AddCoApplicantPage(
              coApplicantFields: CoApplicantFields(
                validateCoApplicantForm: logic.validateCoApplicantForm,
                emailController: logic.emailController,
                panController: logic.panController,
                dobController: logic.dobController,
                fullNameController: logic.fullNameController,
                phoneNumberController: logic.phoneNumberController,
                coApplicantDesignationController:
                    logic.coApplicantDesignationController,
                coApplicantShareHoldingController:
                    logic.coApplicantShareHoldingController,
                pinCodeController: logic.pinCodeController,
                coApplicantButtonEnabled: logic.coApplicantButtonEnabled,
                onCloseCoApplicantForm: logic.onCloseAddCoApplicantPage,
                onCoApplicantSavePressed: logic.onCoApplicantSavePressed,
                shareHoldingErrorText: logic.shareHoldingErrorText,
                otherApplicantsPanNumbers: logic.otherApplicantsPanNumbers,
                otherApplicantsMobileNumbers:
                    logic.otherApplicantsMobileNumbers,
              ),
            );
          },
        );
    }
  }

  Padding _businessDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GetBuilder<CoApplicantDetailsLogic>(
                id: logic.OWNERSHIP_DETAILS_FORM,
                builder: (logic) {
                  return _formWidget();
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GetBuilder<CoApplicantDetailsLogic>(
            id: logic.BUTTON_ID,
            builder: (logic) {
              return GradientButton(
                onPressed: logic.onNextTapped,
                title: "Next",
                enabled: logic.buttonEnabled,
                isLoading: logic.buttonLoading,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Column _formWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const OnboardingStepOfWidget(
          title: "Business Details",
        ),
        const SizedBox(
          height: 40,
        ),
        OwnerShipDetailsForm(
          designationField: SBDDesignationField(
            attributes: FormFieldAttributes(
              controller: logic.designationController,
              isEnabled: !logic.buttonLoading,
              onChanged: (value) => logic.validateForm(),
            ),
          ),
          shareHoldingField: SBDShareHoldingField(
            attributes: FormFieldAttributes(
              errorText: logic.shareHoldingErrorText,
              controller: logic.shareHoldingController,
              isEnabled: !logic.buttonLoading,
              onChanged: (value) => logic.validateForm(),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        AboutCoApplicantDetails(
          coApplicantDetailsList: logic.coApplicantDetailsList,
          onTapCoApplicantEdit: (CoApplicantDetail detail, int index) {
            !logic.buttonLoading
                ? logic.onTapCoApplicantEdit(detail, index)
                : null;
          },
          title: logic.coApplicantDetailsList.isNotEmpty
              ? "Co-applicant Details"
              : "About Co-Applicant",
          onTapAddCoApplicant: logic.onTapAddCoApplicant,
        ),
        const VerticalSpacer(20),
        if (logic.coApplicantDetailsList.length < 3)
          Center(
            child: TextButton(
              onPressed:
                  !logic.buttonLoading ? logic.onTapMoreCoApplicant : null,
              child: Text(
                "Add More Co-applicants",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: logic.coApplicantDetailsList.isEmpty
                      ? lightGrayColor
                      : darkBlueColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
