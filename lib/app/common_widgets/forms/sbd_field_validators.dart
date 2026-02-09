import 'package:privo/app/common_widgets/forms/base_field_validator.dart';

mixin SBDFieldValidators on BaseFieldValidators {
  String? ownerShipTypeValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Select an Ownership Type";
    }
    return null;
  }

  String? registrationDateValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Select a Registration Date";
    }
    return null;
  }

  String? businessEntityNameValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Company Name Required";
    }
    if (value != null && value.length > 160) {
      return "Character Exceeded: Name is too long";
    }
    return null;
  }

  String? businessPanValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Please Enter Business PAN";
    }
    RegExp businessPanRegEx =
        RegExp(r'[A-Za-z]{3}[Ff][A-Za-z][0-9]{4}[A-Za-z]{1}');
    if (value!.trim().isEmpty || !businessPanRegEx.hasMatch(value.trim())) {
      return "Please enter a valid Business PAN.";
    }
    return null;
  }

  String? designationValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Select a designation";
    }
    return null;
  }

  String? shareHoldingValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Shareholding % is required";
    }
    int share = int.parse(value!);
    if (share > 100) {
      return "Shareholding % should be less than 100%";
    }
    return null;
  }
}
