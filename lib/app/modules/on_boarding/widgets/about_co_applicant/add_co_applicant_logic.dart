import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/personal_details_field_validators.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';
import 'package:privo/app/common_widgets/privo_text_editing_controller.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/co_applicant_list_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/about_co_applicant/add_co_applicant_abstract_class.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/widgets/personal_details_dob_field/personal_details_dob_field_logic.dart';

import '../co_applicant_details/co_applicant_details_analytics.dart';

class AddCoApplicantLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        BaseFieldValidators,
        SBDFieldValidators,
        PersonalDetailsFieldValidators,
        AppAnalyticsMixin,
        CoApplicantDetailsAnalytics {
  AddCoApplicantHandler? addCoApplicantAbstractClass;

  AddCoApplicantLogic({this.addCoApplicantAbstractClass});

  // Instances of PrivoTextEditingController
  PrivoTextEditingController emailController = PrivoTextEditingController();
  PrivoTextEditingController panController = PrivoTextEditingController();
  PrivoTextEditingController dobController = PrivoTextEditingController();
  PrivoTextEditingController fullNameController = PrivoTextEditingController();
  PrivoTextEditingController phoneNumberController =
      PrivoTextEditingController();
  PrivoTextEditingController coApplicantDesignationController =
      PrivoTextEditingController();
  PrivoTextEditingController coApplicantShareHoldingController =
      PrivoTextEditingController();
  PrivoTextEditingController pinCodeController = PrivoTextEditingController();

  String applicantPan = "";
  String applicantMobileNumber = "";

  List<CoApplicantDetail> coApplicantDetailsList = [];

  bool _coApplicantButtonEnabled = false;

  bool get coApplicantButtonEnabled => _coApplicantButtonEnabled;

  set coApplicantButtonEnabled(bool value) {
    _coApplicantButtonEnabled = value;
    update();
  }

  onCoApplicantSavePressed(bool isMultiCoApplicant) {
    logInputEvents(true);
    CoApplicantDetail coApplicantDetail = CoApplicantDetail(
        pan: panController.text,
        firstName: fullNameController.text.split(" ").first,
        middleName: "",
        lastName:
            fullNameController.text.split(" ").sublist(1).join(" ").trim(),
        dob: dobController.text,
        email: emailController.text,
        phone: phoneNumberController.text,
        pincode: pinCodeController.text,
        designation: coApplicantDesignationController.text,
        shareholding: coApplicantShareHoldingController.text);

    if (isMultiCoApplicant) {
      coApplicantDetailsList.add(coApplicantDetail);
    } else {
      coApplicantDetailsList = [coApplicantDetail];
    }
    _resetCoApplicantControllers();
    update();
  }

  void _resetCoApplicantControllers() {
    panController.text = "";
    fullNameController.text = "";
    dobController.text = "";
    emailController.text = "";
    phoneNumberController.text = "";
    pinCodeController.text = "";
    coApplicantDesignationController.text = "";
    coApplicantShareHoldingController.text = "";
  }

  validateCoApplicantForm() {
    coApplicantButtonEnabled =
        isFieldValid(nameValidator(fullNameController.text)) &&
            isFieldValid(dobValidator(dobController.text)) &&
            isFieldValid(panValidator(panController.text, [applicantPan])) &&
            isFieldValid(phoneNumberValidator(
                phoneNumberController.text, [applicantMobileNumber])) &&
            isFieldValid(emailValidator(emailController.text)) &&
            isFieldValid(pinCodeValidator(pinCodeController.text)) &&
            isFieldValid(
                designationValidator(coApplicantDesignationController.text)) &&
            isFieldValid(
                shareHoldingValidator(coApplicantShareHoldingController.text));
  }

  DateFormat format = DateFormat("dd/MM/yyyy");

  _prefillDob() {
    final personalDetailsDOBFieldLogic =
        Get.find<PersonalDetailsDOBFieldLogic>();
    final DateTime datetime = format.parse(
      dobController.text,
    );
    personalDetailsDOBFieldLogic.dobManager.dayManager
        .setText(datetime.day.toString());
    personalDetailsDOBFieldLogic.dobManager.monthManager
        .setText(datetime.month.toString());
    personalDetailsDOBFieldLogic.dobManager.yearManager
        .setText(datetime.year.toString());
  }

  void onInitialized(
      {CoApplicantDetail? coApplicantDetail,
      required String applicantPan,
      required String applicantMobileNumber}) {
    if (coApplicantDetail != null) {
      panController.text = coApplicantDetail.pan;
      fullNameController.text =
          "${coApplicantDetail.firstName} ${coApplicantDetail.lastName}";
      dobController.text = coApplicantDetail.dob;
      _prefillDob();
      emailController.text = coApplicantDetail.email;
      phoneNumberController.text = coApplicantDetail.phone;
      pinCodeController.text = coApplicantDetail.pincode;
      coApplicantDesignationController.text = coApplicantDetail.designation;
      coApplicantShareHoldingController.text = coApplicantDetail.shareholding;

      validateCoApplicantForm();
    }

    this.applicantPan = applicantPan;
    this.applicantMobileNumber = applicantMobileNumber;
  }

  onSavePressed(bool isMultiCoApplicant) {
    onCoApplicantSavePressed(isMultiCoApplicant);
    addCoApplicantAbstractClass?.onSavePressed(coApplicantDetailsList);
  }
}
