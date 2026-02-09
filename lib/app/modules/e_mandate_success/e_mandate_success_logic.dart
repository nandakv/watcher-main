import 'package:get/get.dart';

class EMandateSuccessLogic extends GetxController {

  @override
  void onReady() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
    super.onReady();
  }

}
