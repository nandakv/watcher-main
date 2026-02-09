import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/common_text_fields/email_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/full_name_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/pan_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/phone_number_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/pincode_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/sbd_desingation_field.dart';
import 'package:privo/app/common_widgets/common_text_fields/sbd_shareholding_field.dart';
import 'package:privo/app/common_widgets/forms/applicant_form.dart';
import 'package:privo/app/common_widgets/forms/model/form_field_attributes.dart';
import 'package:privo/app/common_widgets/forms/ownership_details_form.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/privo_text_editing_controller.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/widgets/about_co_applicant/add_co_applicant_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/final_offer_polling/final_offer_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/widgets/personal_details_dob_field/personal_details_dob_field.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AddCoApplicantPage extends StatefulWidget {
  CoApplicantFields coApplicantFields;

  AddCoApplicantPage({Key? key, required this.coApplicantFields})
      : super(key: key);

  @override
  State<AddCoApplicantPage> createState() => _AddCoApplicantPageState();
}

class _AddCoApplicantPageState extends State<AddCoApplicantPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: widget.coApplicantFields.onCloseCoApplicantForm,
            icon: SvgPicture.asset(Res.close_x_mark_svg),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Co-applicant Details",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: navyBlueColor,
                  ),
                ),
                const VerticalSpacer(40),
                const Text(
                  "About  Co-applicant",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: primaryDarkColor,
                  ),
                ),
                const VerticalSpacer(20),
                _applicantForm(),
                const VerticalSpacer(18),
                PincodeField(
                  formFieldAttributes: FormFieldAttributes(
                    controller: widget.coApplicantFields.pinCodeController,
                    isEnabled: true,
                    onChanged: (value) =>
                        widget.coApplicantFields.validateCoApplicantForm(),
                  ),
                  labelText: "Correspondance Address Pincode",
                ),
                const VerticalSpacer(50),
                OwnerShipDetailsForm(
                  designationField: SBDDesignationField(
                    attributes: FormFieldAttributes(
                      controller: widget
                          .coApplicantFields.coApplicantDesignationController,
                      isEnabled: true,
                      onChanged: (value) =>
                          widget.coApplicantFields.validateCoApplicantForm(),
                    ),
                  ),
                  shareHoldingField: SBDShareHoldingField(
                    attributes: FormFieldAttributes(
                      errorText: widget.coApplicantFields.shareHoldingErrorText,
                      controller: widget
                          .coApplicantFields.coApplicantShareHoldingController,
                      isEnabled: true,
                      onChanged: (value) =>
                          widget.coApplicantFields.validateCoApplicantForm(),
                    ),
                  ),
                ),
                const VerticalSpacer(50),
              ],
            ),
          ),
        ),
        const VerticalSpacer(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: GetBuilder<FinalOfferPollingLogic>(
            id: "CO_APPLICANT_BUTTON_ID",
            builder: (_) {
              return GradientButton(
                enabled: widget.coApplicantFields.coApplicantButtonEnabled,
                onPressed: widget.coApplicantFields.onCoApplicantSavePressed,
                title: "Save",
              );
            },
          ),
        ),
        const VerticalSpacer(10),
      ],
    );
  }

  ApplicantForm _applicantForm() {
    return ApplicantForm(
      fullNameField: FullNameField(
        formFieldAttributes: FormFieldAttributes(
          controller: widget.coApplicantFields.fullNameController,
          isEnabled: true,
          onChanged: (value) =>
              widget.coApplicantFields.validateCoApplicantForm(),
        ),
      ),
      dobField: PersonalDetailsDOBField(
        onChange: (value) {
          widget.coApplicantFields.dobController.text = value;
          widget.coApplicantFields.validateCoApplicantForm();
        },
      ),
      panField: PanField(
        formFieldAttributes: FormFieldAttributes(
          controller: widget.coApplicantFields.panController,
          isEnabled: true,
          onChanged: (value) =>
              widget.coApplicantFields.validateCoApplicantForm(),
        ),
        otherApplicantsPanNumbers:
            widget.coApplicantFields.otherApplicantsPanNumbers,
      ),
      emailField: EmailField(
        formFieldAttributes: FormFieldAttributes(
          controller: widget.coApplicantFields.emailController,
          isEnabled: true,
          onChanged: (value) =>
              widget.coApplicantFields.validateCoApplicantForm(),
        ),
      ),
      phoneNumberField: PhoneNumberField(
        formFieldAttributes: FormFieldAttributes(
          controller: widget.coApplicantFields.phoneNumberController,
          isEnabled: true,
          onChanged: (value) =>
              widget.coApplicantFields.validateCoApplicantForm(),
        ),
        otherApplicantsMobileNumbers:
            widget.coApplicantFields.otherApplicantsMobileNumbers,
      ),
    );
  }

  @override
  void initState() {
    final logic = Get.put(AddCoApplicantLogic());
  }
}

class CoApplicantFields {
  final Function() validateCoApplicantForm;
  final Function()? onCloseCoApplicantForm;
  final Function() onCoApplicantSavePressed;
  final bool coApplicantButtonEnabled;
  final PrivoTextEditingController emailController;
  final PrivoTextEditingController panController;
  final PrivoTextEditingController dobController;
  final PrivoTextEditingController fullNameController;
  final PrivoTextEditingController phoneNumberController;
  final PrivoTextEditingController coApplicantDesignationController;
  final PrivoTextEditingController coApplicantShareHoldingController;
  final PrivoTextEditingController pinCodeController;
  final String? shareHoldingErrorText;
  final List<String> otherApplicantsPanNumbers;
  final List<String> otherApplicantsMobileNumbers;

  CoApplicantFields({
    required this.validateCoApplicantForm,
    required this.emailController,
    required this.coApplicantButtonEnabled,
    required this.panController,
    required this.dobController,
    required this.onCoApplicantSavePressed,
    required this.fullNameController,
    required this.phoneNumberController,
    required this.coApplicantDesignationController,
    required this.coApplicantShareHoldingController,
    required this.pinCodeController,
    required this.onCloseCoApplicantForm,
    this.shareHoldingErrorText,
    required this.otherApplicantsMobileNumbers,
    required this.otherApplicantsPanNumbers,
  });
}
