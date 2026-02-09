import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/utils/multi_lpc_faq.dart';

import '../../../../res.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../on_boarding/mixins/app_form_mixin.dart';
import '../home_screen_logic.dart';

class HomeScreenAppBar extends StatelessWidget {
  HomeScreenAppBar({Key? key}) : super(key: key);

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: SvgPicture.asset(
            Res.hamburger,
            colorFilter: const ColorFilter.mode(
              navyBlueColor,
              BlendMode.srcIn,
            ),
          ),
          onTap: () {
            logic.homePageScaffoldKey.currentState?.openDrawer();
          },
        ),
        const Spacer(),
        if (logic.showHelpIcon) _helpButton(),
        const SizedBox(
          width: 24,
        ),
      ],
    );
  }

  Widget _helpButton() {
    return InkWell(
      onTap: () {
        MultiLPCFaq().openMultiLPCBottomSheet(onPressContinue: (){},isFromHomePage: true);
      },
      child: SvgPicture.asset(Res.helpAppBar),
    );
  }
}
