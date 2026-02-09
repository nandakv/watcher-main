import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/common_text_fields/pincode_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/residence_type_field.dart';
import 'package:privo/app/common_widgets/forms/applicant_form.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/personal_details_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../common_widgets/common_text_fields/email_field.dart';
import '../../../../common_widgets/common_text_fields/full_name_field.dart';
import '../../../../common_widgets/common_text_fields/pan_field.dart';
import '../../../../common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import 'widgets/personal_details_dob_field/personal_details_dob_field.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen>
    with AfterLayoutMixin {
  final logic = Get.find<PersonalDetailsLogic>();

  Widget _skeletonWidget() {
    return const SkeletonLoadingWidget(
      skeletonLoadingType: SkeletonLoadingType.personalDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonalDetailsLogic>(
      builder: (logic) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child:
              logic.isDataLoading ? _skeletonWidget() : _personalDetailsForm(),
        );
      },
    );
  }

  Widget _personalDetailsForm() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _onBoardingStepWidget(),
                const VerticalSpacer(12),
                _formWidget(),
                const VerticalSpacer(50),
              ],
            ),
          ),
        ),
        _ctaButton(),
        const VerticalSpacer(20),
      ],
    );
  }

  Widget _onBoardingStepWidget() {
    return const OnboardingStepOfWidget(
      title: "Personal Details",
      // appState: "0",
      // currentStep: "1",
      // totalStep: "3",
      subTitle: "About You",
    );
  }

  Widget _formWidget() {
    return Form(
      key: logic.personalDetailsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _aboutYouForm(),
          const VerticalSpacer(40),
          _sectionHeader("Address Details"),
          const VerticalSpacer(12),
          PincodeField(
            formFieldAttributes: FormFieldAttributes(
              controller: logic.pinCodeController,
              onChanged: (value) => logic.areFieldsValid(),
              isEnabled: !logic.isLoading,
            ),
          ),
          const VerticalSpacer(40),
          ResidenceTypeField(
            formFieldAttributes: FormFieldAttributes(
              controller: logic.residenceTypeController,
              onChanged: (value) => logic.areFieldsValid(),
              isEnabled: !logic.isLoading,
              isMandatory: logic.isPartnerFlow,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _employmentTypeSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _sectionHeader("Employment Type"),
  //       const VerticalSpacer(8),
  //       _employmentTipWidget(),
  //       const VerticalSpacer(16),
  //       _employmentTypeSelectionField(),
  //     ],
  //   );
  // }

  // Widget _employmentTypeSelectionField() {
  //   return IgnorePointer(
  //     ignoring: logic.isLoading,
  //     child: GetBuilder<PersonalDetailsLogic>(
  //         id: logic.EMPLOYMENT_TYPE_ID,
  //         builder: (logic) {
  //           return HorizontalOptionChooserWidget(
  //             onTap: logic.onTapEmploymentType,
  //             currentIndex: logic.employmentTypeIndex,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             items: [
  //               // if partner flow hide business owner
  //               if (!logic.isPartnerFlow)
  //                 HorizontalOptionItem(
  //                   title: "Business\nOwner",
  //                   icon: Res.businessOwnerIcon,
  //                 ),
  //               HorizontalOptionItem(
  //                 title: "Self Employed",
  //                 icon: Res.selfEmployedIcon,
  //               ),
  //               HorizontalOptionItem(
  //                 title: "Salaried",
  //                 icon: Res.salariedIcon,
  //               ),
  //             ],
  //           );
  //         }),
  //   );
  // }
  //
  // Widget _employmentTipWidget() {
  //   return RichTextWidget(infoList: [
  //     RichTextModel(
  //       text: "Tip:",
  //       textStyle: const TextStyle(
  //           fontWeight: FontWeight.w700, color: darkBlueColor, fontSize: 10),
  //     ),
  //     RichTextModel(
  //       text:
  //           "'Self Employed' for freelancers/gig workers; 'Business Owner' for proprietors/partners",
  //       textStyle: const TextStyle(color: darkBlueColor, fontSize: 10),
  //     )
  //   ]);
  // }

  Widget _aboutYouForm() {
    return ApplicantForm(
      fullNameField: FullNameField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.fullNameController,
          isEnabled: !logic.isLoading,
          onChanged: (value) => logic.areFieldsValid(),
        ),
      ),
      dobField: PersonalDetailsDOBField(
        onChange: logic.onDobChanged,
        isEnabled: logic.isLoading,
      ),
      panField: PanField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.panController,
          isEnabled: !logic.isLoading,
          onChanged: (value) => logic.areFieldsValid(),
        ),
      ),
      emailField: EmailField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.emailController,
          isEnabled: !logic.isLoading,
          onChanged: (value) => logic.areFieldsValid(),
        ),
      ),
    );
  }

  Widget _sectionHeader(String header) {
    return Text(
      header,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.8,
        color: primaryDarkColor,
      ),
    );
  }

  Widget _ctaButton() {
    return PrivoButton(
      title: "Next",
      onPressed: logic.onPersonalDetailsContinueTapped,
      enabled: logic.isPersonalDetailsFormFilled,
      isLoading: logic.isLoading,
    );
  }

  DateTime? datetime;

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }
}
