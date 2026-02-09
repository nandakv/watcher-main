import 'package:get/get.dart';

class PrivoTextFormFieldLogic extends GetxController {
  bool _isError = false;

  bool get isError => _isError;

  set isError(bool value) {
    _isError = value;
    update();
  }

  clear() {
    _isError = false;
  }
}
