import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../res.dart';
import '../../../common_widgets/polling_title_widget.dart';

class CreditScoreFailureScreen extends StatelessWidget {
  const CreditScoreFailureScreen({Key? key}) : super(key: key);

  Widget _closeButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 35,
          child: IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.clear_rounded,
              color: appBarTitleColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: PollingTitleWidget(title: "Credit Score Check Failed"),
    );
  }

  Widget _bodyWidget() {
    return const Text("Don't worry, you can try again later.",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xff1D478E),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: offWhiteColor,
      child: Column(
        children: [
          _closeButton(),
          const Spacer(),
          _titleWidget(),
          verticalSpacer(16),
          _bodyWidget(),
          const Spacer(),
          SvgPicture.asset(Res.piggy_bank_failure_svg),
          const Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }
}
