import 'package:flutter/cupertino.dart';

import '../../../../../common_widgets/forms/base_field_validator.dart';

mixin WorkDetailsFieldValidators {
  final int COMPANY_NAME_LENGTH = 3;
 final int EMPLOYER_NAME_MAX_LENGTH = 256;



  String? validateCompanyName(String? value) {
    if (value!.trim().isEmpty) {
      return "Company name required";
    } else if (value.length < COMPANY_NAME_LENGTH) {
      return "Enter complete company name";
    } else if (value.length >= EMPLOYER_NAME_MAX_LENGTH) {
      return "Name is too long";
    }
    return null;
  }


 String? incomeValidator(String? value,TextEditingController incomeController,bool validateIncome) {
   if (value!.isEmpty) return "Income is required";
   if (double.parse(incomeController.text.replaceAll(',', '')) < 10000) {
     return "Enter a valid income";
   }
   if (!validateIncome) return "Enter a valid income";
   return null;
 }

}
