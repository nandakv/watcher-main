import 'package:after_layout/after_layout.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_screen.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar_api/aadhaar_api_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/webengage_event_mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/snack_bar.dart';

import 'model/privo_app_bar_model.dart';
import 'on_boarding_logic.dart';
import 'widgets/privo_app_bar/privo_app_bar.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> with AfterLayoutMixin {
  final logic = Get.find<OnBoardingLogic>();
  final verifyBankStatementLogic = Get.find<VerifyBankStatementLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return logic.onWillPop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF3F4FA),
        body: SafeArea(
          child: GetBuilder<OnBoardingLogic>(
            builder: (logic) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<OnBoardingLogic>(
                    id: logic.APP_BAR_TITLE_ID,
                    builder: (logic) {
                      return logic.showAppBar
                          ? PrivoAppBar(
                        showFAQ: true,
                        lpcCard: LPCService.instance.activeCard,
                        model: logic.showAppBarTitle
                            ? logic.updateTimeLine(logic.currentUserState)
                            : PrivoAppBarModel(
                          title: "",
                          progress: 0,
                          isAppBarVisible: true,
                          isTitleVisible: true,
                        ),
                        loanProductCode: logic.loanProductCode,
                      )
                          : const SizedBox();
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      width: double.maxFinite,
                      height: Get.height,
                      //padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: getUserStateWidget[logic.currentUserState],
                      // child: Column(
                      //   children: [
                      //     Expanded(
                      //       child: AnimatedSwitcher(
                      //         duration: const Duration(milliseconds: 350),
                      //         switchInCurve: Curves.easeIn,
                      //         switchOutCurve: Curves.easeOut,
                      //         layoutBuilder: (currentChild,
                      //             previousChildren) {
                      //           return currentChild!;
                      //         },
                      //         transitionBuilder: (child, animation) {
                      //           return SlideTransition(
                      //             position: Tween<Offset>(
                      //                 begin: const Offset(1.2, 0),
                      //                 end: const Offset(0, 0))
                      //                 .animate(animation),
                      //             child: child,
                      //           );
                      //         },
                      //         child: getUserStateWidget[logic
                      //             .currentUserState],
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onInitial();
  }
}