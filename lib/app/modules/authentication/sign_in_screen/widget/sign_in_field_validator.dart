import 'package:privo/app/common_widgets/forms/base_field_validator.dart';

mixin SignInFieldValidator {
  String? validatePhoneNumber(String? value) {
    if (value != null && (value.isEmpty || value.length != 10)) {
      return "Enter a valid number";
    }
    return null;
  }

  String? validateMobileNumber(String? value) {
    if (value != null) {
      if (value.length != 10) {
        return "Enter a valid number";
      } else if (!RegExp(r"^[6-9]{1}[0-9]{9}$").hasMatch(value)) {
        return "Enter a valid number";
      }
    }
    return null;
  }
}
