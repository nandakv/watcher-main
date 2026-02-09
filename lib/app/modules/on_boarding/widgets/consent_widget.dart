import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/theme/app_colors.dart';

class ConsentWidget extends StatelessWidget {
  final List<RichTextModel> consentTextList;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color color;
  final double horizontalPadding;
  final Color checkBoxColor;


  const ConsentWidget({
    Key? key,
    required this.consentTextList,
    required this.value,
    this.onChanged,
    this.checkBoxColor = activeButtonColor,
    this.color = const Color(0xff727272),
    this.horizontalPadding = 5
  }) : super(key: key);

  // final logic = Get.find<WorkDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SizedBox(
              width: 12,
              height: 12,
              child: Checkbox(
                activeColor: checkBoxColor,
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: RichTextWidget(
              infoList: consentTextList,
            ),
          )
        ],
      ),
    );
  }

  TextStyle get _consentTextStyle {
    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.08,
      color: color,
    );
  }
}
