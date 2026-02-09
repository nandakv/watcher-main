import '../../../../common_widgets/forms/base_field_validator.dart';

mixin AadhaarFieldValidators {
  String? aadhaarNumberValidator(String? value) {
    if (value!.isEmpty) {
      return "Aadhaar number is required";
    } else if (value.replaceAll(' ', '').length != 12) {
      return "Complete your Aadhaar number";
    }
    return null;
  }

  String? otpValidator(String? value) {
    if (value!.length == 6) {
      return null;
    } else {
      return "Enter the correct OTP";
    }
  }
}
