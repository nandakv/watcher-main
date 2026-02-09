import 'package:get/get.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';

mixin WithdrawalFieldValidator {
  String? validatePurpose(String? value) {
    if (value != null) {
      return value.isEmpty ? "Select a purpose" : null;
    } else {
      return "Select a purpose";
    }
  }

  String? validateState(String? value) {
    if (value == null ||
        value.trim().isEmpty ||
        value.contains("Select your State")) {
      return "Select a state";
    }
    return null;
  }

  String? validateAddressTextField(String? value) {
    if (value!.trim().isEmpty) return "Address is required";
    //if(!containsFiveWords(value)) return "Address should be minimum 4-5 words";
    if (value.isPhoneNumber) return "Enter your Address";
    return null;
  }

  bool containsFiveWords(String input) {
    // Split the input string by spaces, removing empty strings
    List<String> words = input
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    // Check if the length of the word list is exactly 5
    return words.length == 5;
  }

  String? validateCity(String? value, List<String> listOfCities) {
    if (value == null ||
        value.trim().isEmpty ||
        value.contains("Select your City")) {
      return "Select a city";
    }
    if (!listOfCities.contains(value)) return "Select a city";
    return null;
  }
}
