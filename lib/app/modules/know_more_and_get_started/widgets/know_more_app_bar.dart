import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/multi_lpc_faq.dart';

import '../../../../res.dart';

class KnowMoreAppBar extends StatelessWidget {
  const KnowMoreAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: skyBlueColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _helpSupportButton(),
          _closeButton(),
          const HorizontalSpacer(14),
        ],
      ),
    );
  }

  Widget _helpSupportButton() {
    return InkWell(
      onTap: () => MultiLPCFaq(lpcCard: LPCService.instance.activeCard)
          .openMultiLPCBottomSheet(onPressContinue: () {}),
      child: SvgPicture.asset(Res.helpAppBar),
    );
  }

  Widget _closeButton() {
    return SizedBox(
      width: 35,
      child: IconButton(
        onPressed: Get.back,
        icon: const Icon(
          Icons.clear_rounded,
          color: appBarTitleColor,
        ),
      ),
    );
  }
}
