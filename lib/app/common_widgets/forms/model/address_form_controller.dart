import 'package:privo/app/common_widgets/privo_text_editing_controller.dart';
import 'package:privo/app/modules/additional_business_details/model/address_details.dart';

class AddressFormController {
  final PrivoTextEditingController addressLine1Controller =
      PrivoTextEditingController();
  final PrivoTextEditingController addressLine2Controller =
      PrivoTextEditingController();
  final PrivoTextEditingController pincodeController =
      PrivoTextEditingController();

  bool isPincodeEditable = true;

  prefillAddressData(AddressDetails addressDetails) {
    addressLine1Controller.text = addressDetails.addressLine1;
    addressLine2Controller.text = addressDetails.addressLine2;
    pincodeController.text = addressDetails.pincode;
  }

  bool isEmpty() {
    return addressLine1Controller.text.isEmpty &&
        addressLine2Controller.text.isEmpty &&
        _isPincodeEmpty();
  }

  // if pincode is not editable, then the value will be prefilled.Hence ignoring the validation
  bool _isPincodeEmpty() {
    if (isPincodeEditable == true) {
      return pincodeController.text.isEmpty;
    }
    return true;
  }

  reset() {
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    pincodeController.clear();
  }

  bool isValid() {
    return isAddressLineValid(addressLine1Controller) &&
        isAddressLineValid(addressLine2Controller) &&
        pincodeController.text.length == 6 &&
        pincodeController.text.isNotEmpty &&
        pincodeController.text[0] != '0';
  }

  bool isAddressLineValid(PrivoTextEditingController controller) {
    // minimum of 5 characters and maximum of 50
    int textlength = controller.text.trim().length;
    return textlength >= 5 && textlength <= 50;
  }
}
