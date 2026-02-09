import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';

import '../../../../res.dart';
import '../../../common_widgets/spacer_widgets.dart';
import '../../../theme/app_colors.dart';
import '../fin_sights_logic.dart';

class FinsightsDataVisibilityLabelWidget extends StatefulWidget {
  FinsightsDataVisibilityLabelWidget({super.key});

  @override
  State<FinsightsDataVisibilityLabelWidget> createState() =>
      _FinsightsDataVisibilityLabelWidgetState();
}

class _FinsightsDataVisibilityLabelWidgetState
    extends State<FinsightsDataVisibilityLabelWidget> with AfterLayoutMixin {
  final logic = Get.find<FinSightsLogic>();

  final _textKey = GlobalKey();
  double _textWidth = 100;

  @override
  Widget build(BuildContext context) {
    ///we need height to add stack in a column
    return InkWell(
      onTap: logic.toggleDataVisibility,
      child: SizedBox(
        height: 32,

        ///we need stack to make animated positioned work
        child: Stack(
          children: [
            GetBuilder<FinSightsLogic>(
              id: logic.HIDE_INFORMATION_WIDGET_KEY,
              builder: (logic) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  right: logic.showHideInformationWidget ? 0 : -_textWidth,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: darkBlueColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GetBuilder<FinSightsLogic>(
                            id: logic.MASKWIDGET_KEY,
                            builder: (logic) {
                              return SvgPicture.asset(
                                logic.showData
                                    ? Res.finsightsDashboardClosedEyeIconSvg
                                    : Res.finsightsDashboardEyeIconSvg,
                              );
                            },
                          ),
                        ),
                        const HorizontalSpacer(4),
                        SizedBox(
                          key: _textKey,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: const Text(
                              "Unhide information",
                            ).bodyXSRegular(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Get.log("_textKey = $_textKey");
    if (_textKey.currentContext != null &&
        _textKey.currentContext!.size != null) {
      _textWidth = _textKey.currentContext!.size!.width;
      Get.log("_textWidth = $_textWidth");
      logic.update([logic.HIDE_INFORMATION_WIDGET_KEY]);
    }
  }
}
