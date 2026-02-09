import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_failure/low_and_grow_failure_screen.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_waiting/low_and_grow_wait_screen.dart';
import 'widgets/low_and_grow_agreement/low_and_grow_agreement_screen.dart';
import 'widgets/low_and_grow_offer/low_and_grow_offer_screen.dart';
import 'widgets/low_and_grow_success/low_and_grow_success_screen.dart';

enum LowAndGrowUserStates {
  offer,
  polling,
  agreement,
  success,
  failure,
  loading
}

Map<LowAndGrowUserStates, Widget> get lowAndGrowUserState => {
      LowAndGrowUserStates.loading: const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      ),
      LowAndGrowUserStates.offer: const LowAndGrowOfferScreen(),
      LowAndGrowUserStates.polling: const LowAndGrowWaitScreen(),
      LowAndGrowUserStates.agreement: const LowAndGrowAgreementScreen(),
      LowAndGrowUserStates.success: LowAndGrowSuccessScreen(),
      LowAndGrowUserStates.failure: const LowAndGrowFailureScreen()
    };
