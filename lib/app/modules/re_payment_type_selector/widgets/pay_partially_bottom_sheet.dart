import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/app_text_field.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/re_payment_type_selector/re_payment_type_selector_logic.dart';
import 'package:privo/app/modules/re_payment_type_selector/widgets/pay_partially_bottom_sheet_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/components/button.dart';

class PayPartiallyBottomSheet extends StatefulWidget {
  PayPartiallyBottomSheet({super.key, required this.totalPendingAmount});

  final String totalPendingAmount;

  @override
  State<PayPartiallyBottomSheet> createState() =>
      _PayPartiallyBottomSheetState();
}

class _PayPartiallyBottomSheetState extends State<PayPartiallyBottomSheet>
    with AfterLayoutMixin {
  var paritalBottomSheetLogic = Get.put(PayPartiallyBottomSheetLogic());

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      enableCloseIconButton: true,
      onCloseClicked: (){
        Get.back(result: "");
      },
      childPadding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Partial payment",
              style: AppTextStyles.headingSMedium(
                  color: AppTextColors.brandBlueTitle),
            ),
            RichTextWidget(infoList: [
              RichTextModel(
                  text: "Make a partial amount now and the rest later.\n",
                  textStyle: AppTextStyles.bodySRegular(color: grey700)),
              RichTextModel(
                  text: "*",
                  textStyle:
                      AppTextStyles.bodySRegular(color: AppTextColors.negative)),
              RichTextModel(
                  text: "Late charges may apply",
                  textStyle: AppTextStyles.bodySRegular(color: grey700)),
            ]),
            VerticalSpacer(32.h),
            GetBuilder<PayPartiallyBottomSheetLogic>(builder: (logic) {
              return TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: logic.amountTextController,
                onChanged: logic.onPartialAmountChanged,
                maxLength: 8,
                validator: (text) => logic.validatePartialAmount(),
                style: AppTextStyles.bodyMMedium(color: grey900),
                decoration: InputDecoration(
                  labelText: "Enter the partial amount",
                  labelStyle: AppTextStyles.bodyMLight(color: grey700),
                  counterText: '',
                  isDense: true,
                  prefix: Text(
                    '₹ ',
                    style: logic.amountTextController.text.isNotEmpty
                        ? AppTextStyles.bodyMMedium(color: grey900)
                        : AppTextStyles.bodyMMedium(color: Colors.transparent),
                  ),
                  errorText: logic.errorText.isEmpty ? null : logic.errorText,
                  errorStyle: AppTextStyles.bodyXSRegular(color: red700),
                  errorMaxLines: 3,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  NoLeadingSpaceFormatter(),
                ],
              );
            }),
            VerticalSpacer(32.h),
            GetBuilder<PayPartiallyBottomSheetLogic>(builder: (logic) {
              return Button(
                buttonType: ButtonType.primary,
                buttonSize: ButtonSize.large,
                title: "Pay now",
                onPressed: logic.onPayNowPressed,
                enabled: logic.validatePartialAmountForButton(),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    paritalBottomSheetLogic.totalPendingAmount = widget.totalPendingAmount;
  }
}
