import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_insurance/withdraw_insurance_details_page.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_view.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_polling/withdrawal_polling_view.dart';

import 'widgets/withdraw_success_widget.dart';
import 'widgets/withdrawal_address_details/withdrawal_address_details_view.dart';

enum WithdrawalScreen {
  loading,
  withdraw,
  addressDetails,
  polling,
  success,
}

Map<WithdrawalScreen, Widget> get getWithdrawalScreen => {
      WithdrawalScreen.loading: const Center(
        child: CircularProgressIndicator(),
      ),
      WithdrawalScreen.withdraw: const WithdrawalView(),
      WithdrawalScreen.addressDetails: WithdrawalAddressDetailsView(),
      WithdrawalScreen.polling: WithdrawalPollingPage(),
      WithdrawalScreen.success: WithDrawSuccess(),
    };
