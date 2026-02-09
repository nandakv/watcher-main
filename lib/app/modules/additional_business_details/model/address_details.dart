import 'package:privo/app/common_widgets/forms/model/address_form_controller.dart';

class AddressDetails {
  String addressLine1 = "";
  String addressLine2 = "";
  String pincode = "";
  String type;

  AddressDetails({
    this.addressLine1 = "",
    this.addressLine2 = "",
    this.pincode = "",
    required this.type,
  });

  updateAddressData(AddressFormController controller) {
    addressLine1 = controller.addressLine1Controller.text;
    addressLine2 = controller.addressLine2Controller.text;
    pincode = controller.pincodeController.text;
  }

  @override
  String toString() {
    return "$addressLine1, $addressLine2, \nPincode- $pincode";
  }

  bool isCompleted() {
    /// if any one is also empty then it is not completed
    return addressLine1.isNotEmpty &&
        addressLine2.isNotEmpty &&
        pincode.isNotEmpty;
  }

  bool isPartialFilled() {
    return addressLine1.isNotEmpty ||
        addressLine2.isNotEmpty ||
        pincode.isNotEmpty;
  }

  bool isEmpty() {
    return addressLine1.isEmpty && addressLine2.isEmpty && pincode.isEmpty;
  }

  Map<String, String> toJson() {
    return {
      "type": type,
      "lineOne": addressLine1,
      "lineTwo": addressLine2,
      "pincode": pincode,
    };
  }

  AddressDetails.fromJson(Map<String, dynamic> json, {required this.type}) {
    addressLine1 = json['line1'] ?? "";
    addressLine2 = json['line2'] ?? "";
    pincode = json['pinCode'] ?? "";
  }
}
