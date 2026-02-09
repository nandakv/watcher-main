import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../../res.dart';
import '../../../../../common_widgets/bottom_sheet_widget.dart';

class VKYCErrorBottomSheetWidget extends StatefulWidget {
  const VKYCErrorBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<VKYCErrorBottomSheetWidget> createState() =>
      _VKYCErrorBottomSheetWidgetState();
}

class _VKYCErrorBottomSheetWidgetState
    extends State<VKYCErrorBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      onCloseClicked: () => Get.back(result: false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              SvgPicture.asset(Res.vkycError),
              verticalSpacer(16),
              const Text(
                'Something went wrong!',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: darkBlueColor),
              ),
              verticalSpacer(10),
              const Text(
                "Please make sure you have a strong internet network. Incase if it doesn’t work close the Privo application and open to try again ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryDarkColor,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              verticalSpacer(20),
              GradientButton(
                onPressed: () => Get.back(result: true),
                title: 'Retry VKYC',
              ),
              verticalSpacer(14),
            ],
          ),
        ],
      ),
    );
  }
}
