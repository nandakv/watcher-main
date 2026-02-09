import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/info_pop_up/lib/info_popup.dart';
import 'package:privo/res.dart';

import '../../../../loan_details/widgets/info_bottom_sheet.dart';

class WithdrawalInfoPopUp extends StatelessWidget {
  WithdrawalInfoPopUp({Key? key, required this.bodyText, required this.title})
      : super(key: key);
  String bodyText;
  String title;

  InfoPopupController? infoPopupController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          InfoBottomSheet(title: title, text: bodyText),
        );
      },
      child: SvgPicture.asset(
        Res.info_icon,
        height: 15,
        width: 15,
      ),
    );
  }

  TextStyle _popUpTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 10,
      letterSpacing: 0.16,
    );
  }
}
