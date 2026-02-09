import 'package:privo/app/common_widgets/forms/base_field_validator.dart';

mixin PersonalDetailsFieldValidators {
  String? nameValidator(String? value) {
    if (value!.trim().isEmpty) return "Full name is required";
    if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value.trim())) {
      return "Avoid special characters and numbers";
    }
    if (value.trim().length < 3) {
      return "Enter minimum 3 characters";
    }
    if (!value.trim().contains(" ")) return "Full name is required";
    return null;
  }

  String? dobValidator(String? value) {
    if (value != null && value.isEmpty) {
      return "Date of Birth is required";
    }
    return null;
  }

  String? panValidator(String? value,
      [List<String>? otherApplicantsPanNumbers]) {
    if (value != null && value.isEmpty) return "PAN is required";
    RegExp individualPanRegEx =
        RegExp(r'[A-Za-z]{3}[Pp][A-Za-z][0-9]{4}[A-Za-z]{1}');
    if (value!.trim().isEmpty || !individualPanRegEx.hasMatch(value.trim())) {
      return "Enter a valid PAN";
    }
    if (otherApplicantsPanNumbers != null &&
        otherApplicantsPanNumbers.contains(value.trim())) {
      return "PAN is already being used in previous applicant";
    }
    return null;
  }

  String? phoneNumberValidator(
    String? value,
    List<String>? otherApplicantsPhoneNumbers,
  ) {
    final RegExp phoneRegExp = RegExp(r'^\d{10}$');
    if (value != null && value.isEmpty) {
      return "Please Enter Phone Number";
    }
    if (!(phoneRegExp.hasMatch(value!))) {
      return "Enter Proper Phone Number";
    }
    if (otherApplicantsPhoneNumbers != null &&
        otherApplicantsPhoneNumbers.contains(value.trim())) {
      return "Mobile number is already being used in previous applicant";
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return "Email is required";
    }
    if (!_isEmail(value!)) return "Enter a valid email";
    return null;
  }

  bool _isEmail(String value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,6}$';
    return RegExp(pattern).hasMatch(value);
  }

  String? pinCodeValidator(String? value) {
    if (value!.trim().isEmpty) return "Pincode is required";
    if (value.length != 6) {
      return "Complete your pincode";
    } else if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value.trim())) {
      return "Enter a valid pincode";
    }
    return null;
  }
}