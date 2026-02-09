import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/home_page_top_widget.dart';

import '../../../../res.dart';
import '../../../theme/app_colors.dart';

///this is a temporary home page widget to block onboarding for ios users
class HomeScreenIosBetaWidget extends StatelessWidget {
  HomeScreenIosBetaWidget({Key? key}) : super(key: key);

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return HomeScreenTopWidget(
      infoText: "",
      showHamburger: true,
      background: "",
      scaffoldKey: logic.homePageScaffoldKey,
      widget: Expanded(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SvgPicture.asset(
                  Res.applicationInProgress,
                  height: 200,
                  width: 200,
                ),
              ),
              Text(
                "Currently,",
                textAlign: TextAlign.center,
                style: _rejectionTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "You don’t have any loans with us",
                textAlign: TextAlign.center,
                style: _rejectionTextStyle.copyWith(
                    fontSize: 14,
                    letterSpacing: 0.22,
                    fontWeight: FontWeight.normal),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _rejectionTextStyle {
    return const TextStyle(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.26,
        fontSize: 16,
        color: preRegistrationEnabledGradientColor1);
  }
}
