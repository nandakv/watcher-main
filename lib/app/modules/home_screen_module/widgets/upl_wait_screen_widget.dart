import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/polling_title_widget.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/home_page_top_widget.dart';

import '../../../../res.dart';
import '../../../common_widgets/gradient_button.dart';
import '../../polling/gradient_circular_progress_indicator.dart';
import 'home_loan_page.dart';

class UPLWaitScreenWidget extends StatelessWidget {
  UPLWaitScreenWidget({
    Key? key,
    required this.uplWaitScreenModel,
  }) : super(key: key);

  final UPLWaitScreenModel uplWaitScreenModel;
  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return HomeScreenTopWidget(
      infoText: "",
      showHamburger: false,
      widget: Container(
        color: const Color(0xffFFF3EB),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(
          bottom: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 20,
            ),

            ///PLDSA wait screen (contains icon,title,subtitle)
            UPLPreFulfillmentWaitHomePageWidget(
              title: uplWaitScreenModel.title,
              subTitle: uplWaitScreenModel.message,
            ),
            bottomLoadingIndicator()
          ],
        ),
      ),
    );
  }

  Widget bottomLoadingIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          RotationTransitionWidget(
            loadingState: LoadingState.bottomLoader,
            buttonTheme: AppButtonTheme.dark,
          ),
        ],
      ),
    );
  }
}
