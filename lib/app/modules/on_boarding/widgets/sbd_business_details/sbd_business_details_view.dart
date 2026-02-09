import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/forms/business_details_form.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';

import '../../../../../res.dart';
import '../../../../common_widgets/forms/model/form_field_attributes.dart';
import '../../../../common_widgets/horizontal_option_chooser_widget/horizontal_option_chooser_widget_view.dart';
import '../../../../common_widgets/horizontal_option_chooser_widget/horizontal_option_item.dart';
import '../../../../common_widgets/onboarding_step_of_widget.dart';
import '../../../../theme/app_colors.dart';
import 'sbd_business_details_logic.dart';

class SBDBusinessDetailsView extends StatefulWidget {
  const SBDBusinessDetailsView({Key? key}) : super(key: key);

  @override
  State<SBDBusinessDetailsView> createState() => _SBDBusinessDetailsViewState();
}

class _SBDBusinessDetailsViewState extends State<SBDBusinessDetailsView>
    with AfterLayoutMixin {
  final logic = Get.find<SBDBusinessDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: logic.businessDetailsFormKey,
                child: GetBuilder<SBDBusinessDetailsLogic>(
                  id: logic.BUSINESS_ENTITY_TYPE_ID,
                  builder: (logic) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OnboardingStepOfWidget(
                          title: "Business Details",
                          // appState: "2",
                          // currentStep: "2",
                          // totalStep: "3",
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        const Text(
                          "Business Entity Type",
                          style: TextStyle(
                            color: primaryDarkColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        HorizontalOptionChooserWidget(
                          onTap: !logic.isButtonLoading
                              ? logic.onTapHorizontalItem
                              : null,
                          currentIndex: logic.businessEntitySelectedIndex,
                          items: [
                            HorizontalOptionItem(
                              title: "Sole\nProprietor",
                              icon: Res.soleProprietorIconSVG,
                            ),
                            HorizontalOptionItem(
                              title: "Partnership",
                              icon: Res.partnerShipIconSVG,
                            ),
                            HorizontalOptionItem(
                              title: "Limited Liability\nPartnership (LLP)",
                              icon: Res.llpIconSVG,
                            ),
                          ],
                        ),
                        if (logic.businessEntitySelectedIndex != null) ...[
                          _formFields(),
                        ],
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          GetBuilder<SBDBusinessDetailsLogic>(
            id: logic.BUTTON_ID,
            builder: (logic) {
              return GradientButton(
                onPressed: logic.onNextPressed,
                enabled: logic.buttonEnabled,
                title: "Next",
                isLoading: logic.isButtonLoading,
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

  Widget _formFields() {
    return BusinessDetailsForm(
      businessName: FormFieldAttributes(
        controller: logic.businessEntityNameController,
        isEnabled: !logic.isButtonLoading,
        onChanged: (value) => logic.validateButton(),
      ),
      businessPan: FormFieldAttributes(
        controller: logic.businessPanController,
        isEnabled: !logic.isButtonLoading,
        onChanged: (value) => logic.validateButton(),
      ),
      ownerShipType: FormFieldAttributes(
        controller: logic.ownerShipTypeController,
        isEnabled: !logic.isButtonLoading,
        onChanged: (value) => logic.validateButton(),
      ),
      pincode: FormFieldAttributes(
        controller: logic.pincodeController,
        isEnabled: !logic.isButtonLoading,
        onChanged: (value) => logic.validateButton(),
      ),
      registrationDate: FormFieldAttributes(
        controller: logic.registrationDateController,
        isEnabled: !logic.isButtonLoading,
        onChanged: (value) => logic.validateButton(),
      ),
      showBusinessPan:
          logic.businessEntitySelectedIndex != logic.SOLE_PROPRIETOR,
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
