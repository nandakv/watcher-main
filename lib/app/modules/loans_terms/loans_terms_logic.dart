import 'package:get/get.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/routes/app_pages.dart';

class LoansTermsLogic extends GetxController {
  onPressContinue() async {
    await AppAuthProvider.setLoanTermsShown();
    Get.offNamed(Routes.SIGN_IN_SCREEN);
  }
}
