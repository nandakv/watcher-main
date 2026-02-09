import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class MaskDataWidget extends StatelessWidget {
  MaskDataWidget({
    super.key,
    required this.text,
    required this.styleBuilder,
  });

  final logic = Get.find<FinSightsLogic>();
  final String text;
  final Widget Function(String text) styleBuilder;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinSightsLogic>(
      id: logic.MASKWIDGET_KEY,
      builder: (logic) {
        return styleBuilder(logic.showData ? text : logic.maskedText);
      },
    );
  }
}
