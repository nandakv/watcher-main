import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/lead_details.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/user_personal_details.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/user_work_details.dart';

import '../../../data/provider/auth_provider.dart';
import '../widgets/work_details/work_details_logic.dart';

enum Name { first, last }

class UserDetailsMixin {
  int SELF_EMPLOYED_INDEX = 8;
  int SALARIED_INDEX = 6;

  Map<Name, String> getFirstLastName(String name) {
    List<String> names = name.split(" ");

    String firstName = "";
    String lastName = "";

    for (int i = 0; i < names.length; i++) {
      if (i == 0) {
        firstName = names[i];
      } else {
        lastName = lastName + " " + names[i];
      }
    }

    Map<Name, String> firstAndLastNames = {};
    firstAndLastNames[Name.first] = firstName;
    firstAndLastNames[Name.last] = lastName.trim();

    Get.log("firstname = $firstName");
    Get.log("lastname = ${lastName.trim()}");
    return firstAndLastNames;
  }

  FutureOr<Map> computePersonalDetailsApiBody({
    required UserPersonalDetails personalDetails,
    LeadDetails? leadDetails,
    bool sendExperianConsent = false,
  }) async {
    Map<Name, String> nameDetails =
        getFirstLastName(personalDetails.fullNameController.text.trim());
    String value = personalDetails.dobController.text;
    DateTime birthDate = DateFormat("dd/MM/yyyy").parse(value);
    if (personalDetails.isPartnerFlow) {
      Map data = {
        "firstName": {
          /// Backend requirement to check isEdited for fullName instead of firstName
          "is_edited": personalDetails.fullNameController.isUpdated(),
          "value": nameDetails[Name.first]
        },
        "lastName": {
          /// Backend requirement to check isEdited for fullName instead of lastName
          "is_edited": personalDetails.fullNameController.isUpdated(),
          "value": nameDetails[Name.last]
        },
        "dob": {
          "is_edited": personalDetails.dobController.isUpdated(),
          "value": DateFormat("yyyy-MM-dd").format(birthDate)
        },
        "panCardId": {
          "is_edited": personalDetails.panController.isUpdated(),
          "value": personalDetails.panController.text
        },
        "pinCode": {
          "is_edited": personalDetails.pinCodeController.isUpdated(),
          "value": personalDetails.pinCodeController.text
        },
        "personalEmail": {
          "is_edited": personalDetails.emailController.isUpdated(),
          "value": personalDetails.emailController.text
        },
        "ownership": {
          "is_edited": personalDetails.residenceTypeController.isUpdated(),
          "value": personalDetails.residenceTypeController.text
        }
      };
      return data;
    } else {
      String utmData = await AppAuthProvider.utmDeepLinkData;
      Map data = {
        "firstName": nameDetails[Name.first],
        "middleName": "",
        "lastName": nameDetails[Name.last],
        "dob": DateFormat("yyyy-MM-dd").format(birthDate),
        "panCardId": personalDetails.panController.text.trim(),
        "pinCode": personalDetails.pinCodeController.text.trim(),
        "personalEmail": personalDetails.emailController.text,
        "phoneNumber": await AppAuthProvider.phoneNumber,
        "residenceType": personalDetails.residenceTypeController.text,
        "requestedAmount": leadDetails?.desiredAmount,
        "requestedTenure": leadDetails?.tenure ?? 0,
        "purpose": leadDetails?.purpose ?? "",
        "metadata": {
          if (utmData.isNotEmpty) "utm": jsonDecode(utmData),
        }
      };

      // For SBD users who has not given D2C consent we show bottom sheet to ask for consent
      if (sendExperianConsent) {
        data['experianD2Cconsent'] = true;
      }

      return data;
    }
  }

  _fetchEmploymentTypeIndex(EmploymentType employmentType) {
    if (employmentType == EmploymentType.salaried) {
      return SALARIED_INDEX;
    } else if (employmentType == EmploymentType.selfEmployed) {
      return SELF_EMPLOYED_INDEX;
    }
  }

  Map computeWorkDetailsApiBody(UserWorkDetails userWorkDetails) {
    if (userWorkDetails.isPartnerFlow) {
      Map body = {
        "salaryDepositMethod": {
          "is_edited": true,
          "value":
              _computeSalaryDepositString(userWorkDetails.selectedIncomeType!)
        },
        "employer": {
          "is_edited": userWorkDetails.companyNameController.isUpdated(),
          "value": userWorkDetails.companyNameController.text,
          if (userWorkDetails.employmentType != EmploymentType.selfEmployed)
            "customEmployerName": userWorkDetails.searchResult.manual,
        },
        "income": {
          "is_edited": userWorkDetails.incomeController.isUpdated(),
          "value": double.parse(
              userWorkDetails.incomeController.text.replaceAll(',', ''))
        },
      };
      return body;
    } else {
      Map body = {
        "salaryType": _fetchEmploymentTypeIndex(userWorkDetails.employmentType),
        "income": double.parse(
            userWorkDetails.incomeController.text.replaceAll(',', '')),
        "salaryDepositMethod":
            _computeSalaryDepositString(userWorkDetails.selectedIncomeType!),
      };
      if (userWorkDetails.employmentType != EmploymentType.selfEmployed) {
        body.addAll({
          "employerName": userWorkDetails.companyNameController.text.trim(),
          "customEmployerName": userWorkDetails.searchResult.manual,
        });
      }
      return body;
    }
  }

  String _computeSalaryDepositString(int selectedIndex) {
    return selectedIndex == 0 ? "Bank Transfer" : "Cash";
  }
}
