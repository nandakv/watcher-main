import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/sign_in_screen_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

class RichTextConsentCheckBox extends StatelessWidget {
  RichTextConsentCheckBox(
      {Key? key,
      required this.consentTextList,
      required this.consentCheckBoxValue,
      this.onChanged})
      : super(key: key);


  bool consentCheckBoxValue;
  void Function(bool?)? onChanged;
  final List<RichTextModel> consentTextList;

  Widget _checkBoxWidget() {
    return Checkbox(
      visualDensity: const VisualDensity(
        horizontal: -4.0,
        vertical: -4.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.r),
      ),
      checkColor: Colors.white,
      side: const BorderSide(color: darkBlueColor, width: 2),
      value: consentCheckBoxValue,
      onChanged: onChanged,
      activeColor: darkBlueColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _checkBoxWidget(),
        const SizedBox(
          width: 4,
        ),
        Expanded(child: _richTextWidget()),
      ],
    );
  }

  Widget _richTextWidget() {
    return RichTextWidget(
      infoList: consentTextList,
    );
  }
}
