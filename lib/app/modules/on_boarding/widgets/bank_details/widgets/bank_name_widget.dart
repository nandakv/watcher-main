import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/res.dart';

import '../../../../../utils/no_leading_space_formatter.dart';
import '../bank_details_logic.dart';

class BankNameSearchWidget extends StatelessWidget {
  final Widget? icon;
  final bool isMandatory;
  BankNameSearchWidget({Key? key, this.icon, this.isMandatory = false})
      : super(key: key);

  final logic = Get.find<BankDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return PrivoTextFormField(
      id: "BANK_SELECTION_TEXT_FIELD",
      readOnly: true,
      onTap: logic.onTapBankNameWidget,
      enabled: logic.enableTextField(logic.isBankNameFilled),
      controller: logic.bankNameController,
      prefixSVGIcon: Res.bankSelectionTFSvg,
      decoration: InputDecoration(
        hintText: logic.computeSelectText(),
        suffixIcon: const Icon(
          Icons.chevron_right,
          size: 20,
        ),
        // hintStyle: _hintTextStyle(),
        // labelStyle: _hintTextStyle(),
        label: _textFieldLabel(logic.computeSelectText()),
      ),
      inputFormatters: [NoLeadingSpaceFormatter()],
    );
  }

  Widget _textFieldLabel(String lableText) {
    return RichText(
      text: TextSpan(
        text: lableText,
        style: _hintTextStyle(),
        children: isMandatory
            ? const [
                TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: Color(0xffEE3D4B),
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.16,
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  TextStyle _hintTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.34,
      color: Color(0xff707070),
    );
  }
}
