import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common_widgets/gradient_button.dart';
import '../../common_widgets/spacer_widgets.dart';
import '../../theme/app_colors.dart';
import 'fin_sights_logic.dart';

class FinsightsTransactionError extends StatelessWidget {
  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 90.w, vertical: 60.h),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_outlined,
            color: grey400,
          ),
          VerticalSpacer(4.h),
          const Text(
            "An error occurred! Please click refresh to reload the graph",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: secondaryDarkColor,
            ),
          ),
          VerticalSpacer(16.h),
          GetBuilder<FinSightsLogic>(
            id: logic.REFRESH_ERROR_KEY,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: GradientButton(
                  onPressed: () {
                    logic.getFinSightsOverview();
                  },
                  title: "Refresh",
                  isLoading: logic.isPageLoading,
                ),
              );
            }
          )
        ],
      ),
    );
  }
}
