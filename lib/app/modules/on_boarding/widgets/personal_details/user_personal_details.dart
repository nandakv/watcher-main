import '../../../../common_widgets/privo_text_editing_controller.dart';

enum EmploymentType {
  businessOwner("Business Owner"),
  selfEmployed("Self Employed"),
  salaried("Salaried"),
  none("");

  final String name;
  const EmploymentType(this.name);
}

class UserPersonalDetails {
  PrivoTextEditingController fullNameController = PrivoTextEditingController();
  PrivoTextEditingController dobController = PrivoTextEditingController();
  PrivoTextEditingController panController = PrivoTextEditingController();
  PrivoTextEditingController phoneNumberController =
      PrivoTextEditingController();
  PrivoTextEditingController pinCodeController = PrivoTextEditingController();
  PrivoTextEditingController emailController = PrivoTextEditingController();
  PrivoTextEditingController residenceTypeController =
      PrivoTextEditingController();
  // PrivoTextEditingController employmentTypeController =
  // PrivoTextEditingController();

  // int? employmentTypeIndex;
  bool isPartnerFlow = false;

  // EmploymentType getEmploymentSelectionType() {
  //   if (isPartnerFlow) {
  //     switch (employmentTypeIndex) {
  //       case 0:
  //         return EmploymentType.selfEmployed;
  //       case 1:
  //         return EmploymentType.salaried;
  //       default:
  //         return EmploymentType.none;
  //     }
  //   } else {
  //     switch (employmentTypeIndex) {
  //       case 0:
  //         return EmploymentType.businessOwner;
  //       case 1:
  //         return EmploymentType.selfEmployed;
  //       case 2:
  //         return EmploymentType.salaried;
  //       default:
  //         return EmploymentType.none;
  //     }
  //   }
  // }
}
