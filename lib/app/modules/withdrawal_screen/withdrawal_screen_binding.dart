import 'package:get/get.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/widgets/insurance_container/insurance_container_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_insurance/withdraw_insurance_deatils_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_polling/withdrawal_polling_logic.dart';

import 'widgets/withdrawal_address_details/withdrawal_address_details_logic.dart';
import 'withdrawal_screen_logic.dart';

class WithdrawalScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithdrawalScreenLogic());
    Get.lazyPut(() => WithdrawalLogic());
    Get.lazyPut(() => WithdrawalAddressDetailsLogic());
    Get.lazyPut(() => WithdrawalPollingLogic());
    Get.lazyPut(() => InsuranceContainerLogic());
    Get.lazyPut(() => WithdrawInsuranceDetailsLogic());
  }
}
