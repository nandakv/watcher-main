import 'package:get/get.dart';

class CreditScoreConsentLogic extends GetxController {

  bool isConsentRequired = true;
  bool _isConsentChecked = false;
  final Function(bool)? onConsentChanged;

  CreditScoreConsentLogic({this.onConsentChanged});

  bool get isConsentChecked => _isConsentChecked;

  set isConsentChecked(bool value) {
    _isConsentChecked = value;
    onConsentChanged?.call(_isConsentChecked);
    update();
  }

  void onConsentValueChanged(bool? value) {
    if (value != null) {
      isConsentChecked = value;
    }
  }
}