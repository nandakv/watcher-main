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
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/co_applicant_list_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/about_co_applicant/add_co_applicant_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/final_offer_polling/final_offer_polling_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/widgets/personal_details_dob_field/personal_details_dob_field.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AddCoApplicantPage extends StatefulWidget {
  bool isMultiCoApplicant;
  CoApplicantDetail? coApplicantDetail;
  final String applicantPan;
  final String applicantNumber;

  AddCoApplicantPage(
      {Key? key,
      this.coApplicantDetail,
      this.isMultiCoApplicant = false,
      required this.applicantPan,
      required this.applicantNumber})
      : super(key: key);

  @override
  State<AddCoApplicantPage> createState() => _AddCoApplicantPageState();
}

class _AddCoApplicantPageState extends State<AddCoApplicantPage> {
  var logic = Get.find<AddCoApplicantLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddCoApplicantLogic>(builder: (logic) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: logic.addCoApplicantAbstractClass?.onClosed,
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
                      controller: logic.pinCodeController,
                      isEnabled: true,
                      onChanged: (value) => logic.validateCoApplicantForm(),
                    ),
                    labelText: "Correspondance Address Pincode",
                  ),
                  const VerticalSpacer(50),
                  OwnerShipDetailsForm(
                    designationField: SBDDesignationField(
                      attributes: FormFieldAttributes(
                        controller: logic.coApplicantDesignationController,
                        isEnabled: true,
                        onChanged: (value) => logic.validateCoApplicantForm(),
                      ),
                    ),
                    shareHoldingField: SBDShareHoldingField(
                      attributes: FormFieldAttributes(
                        controller: logic.coApplicantShareHoldingController,
                        isEnabled: true,
                        onChanged: (value) => logic.validateCoApplicantForm(),
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
                  enabled: logic.coApplicantButtonEnabled,
                  onPressed: () {
                    logic.onSavePressed(widget.isMultiCoApplicant);
                  },
                  title: "Save",
                );
              },
            ),
          ),
          const VerticalSpacer(10),
        ],
      );
    });
  }

  ApplicantForm _applicantForm() {
    return ApplicantForm(
      fullNameField: FullNameField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.fullNameController,
          isEnabled: true,
          onChanged: (value) => logic.validateCoApplicantForm(),
        ),
      ),
      dobField: PersonalDetailsDOBField(
        onChange: (value) {
          logic.dobController.text = value;
          logic.validateCoApplicantForm();
        },
      ),
      panField: PanField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.panController,
          isEnabled: true,
          onChanged: (value) => logic.validateCoApplicantForm(),
        ),
        otherApplicantsPanNumbers: [widget.applicantPan],
      ),
      emailField: EmailField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.emailController,
          isEnabled: true,
          onChanged: (value) => logic.validateCoApplicantForm(),
        ),
      ),
      phoneNumberField: PhoneNumberField(
        formFieldAttributes: FormFieldAttributes(
          controller: logic.phoneNumberController,
          isEnabled: true,
          onChanged: (value) => logic.validateCoApplicantForm(),
        ),
        otherApplicantsMobileNumbers: [widget.applicantNumber],
      ),
    );
  }

  @override
  void initState() {
    logic.onInitialized(
        coApplicantDetail: widget.coApplicantDetail,
        applicantPan: widget.applicantPan,
        applicantMobileNumber: widget.applicantNumber);
  }
}
