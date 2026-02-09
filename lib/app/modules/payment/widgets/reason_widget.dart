import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/payment/payment_logic.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';

class ReasonWidget extends StatelessWidget {

  final logic = Get.find<PaymentLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentLogic>(
      id: logic.REASON_TEXTFIELD,
      builder: (logic) {
        return Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: logic.reasonController,
              validator: logic.reasonValidator,
              onTap: logic.onTapReason,
              readOnly: true,
              decoration: _reasonInputDecoration(
                label: logic.computeReasonHintText(),
                suffixIcon: Res.chevron_down_svg,
                isMandatory: true,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            logic.reasonController.text == "Other" || logic.reasonController.text == "Others"
                ? TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: logic.otherReasonController,
              maxLength: 250,
              inputFormatters: [
                NoSpecialCharacterFormatter(),
              ],
              decoration: _reasonInputDecoration(
                label: "Mention the reason",
              ),
            )
                : const SizedBox()
          ],
        );
      },
    );
  }

  InputDecoration _reasonInputDecoration(
      {required String label, String? suffixIcon, bool isMandatory = false}) {
    return InputDecoration(
      label: RichText(
        text: TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: 'Figtree',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF707070),
              letterSpacing: 0.16,
            ),
            children: isMandatory
                ? const [
              TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: Colors.red,
                  )),
            ]
                : []),
      ),
      suffixIconConstraints: const BoxConstraints(
        maxWidth: 36,
      ),
      contentPadding: const EdgeInsets.only(bottom: 5),
      suffixIcon: suffixIcon == null
          ? null
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SvgPicture.asset(suffixIcon),
      ),
    );
  }
}
