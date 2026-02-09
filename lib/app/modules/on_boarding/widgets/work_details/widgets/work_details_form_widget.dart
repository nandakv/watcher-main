import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/common_text_fields/text_field_decoration.dart';
import 'package:privo/app/common_widgets/horizontal_option_chooser_widget/horizontal_option_chooser_widget_view.dart';
import 'package:privo/app/common_widgets/horizontal_option_chooser_widget/horizontal_option_item.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';
import 'package:privo/app/common_widgets/privo_text_form_field/privo_text_form_field.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/user_personal_details.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/widgets/work_details_field_validator.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/work_details_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/res.dart';
import '../../../../../common_widgets/forms/base_field_validator.dart';

class WorkDetailsFormWidget extends StatelessWidget
    with WorkDetailsFieldValidators {
  final logic = Get.find<WorkDetailsLogic>();

  WorkDetailsFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: logic.workDetailsFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingStepOfWidget(
            title: "Work Details",
          ),
          const VerticalSpacer(40),
          if (logic.employmentType == EmploymentType.none) ...[
            const Text(
              "Employment Type",
              style: TextStyle(
                color: primaryDarkColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const VerticalSpacer(16),
            GetBuilder<WorkDetailsLogic>(
              id: logic.EMPLOYMENT_TYPE_WIDGET_ID,
              builder: (logic) {
                return HorizontalOptionChooserWidget(
                  mainAxisAlignment: MainAxisAlignment.start,
                  items: [
                    HorizontalOptionItem(
                      title: "Self Employed",
                      icon: Res.selfEmployedIcon,
                    ),
                    HorizontalOptionItem(
                      title: "Salaried",
                      icon: Res.salariedIcon,
                    ),
                  ],
                  onTap: (value) => logic.isButtonLoading
                      ? null
                      : logic.onSelectedEmploymentTypeIndex(value),
                  currentIndex: logic.selectedEmploymentType,
                );
              },
            ),
            const VerticalSpacer(30),
          ],
          _formWidget(),
        ],
      ),
    );
  }

  Widget _formWidget() {
    return GetBuilder<WorkDetailsLogic>(
      id: logic.FORM_WIDGET_ID,
      builder: (logic) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logic.employmentType != EmploymentType.none) ...[
              if (logic.employmentType == EmploymentType.salaried) ...[
                salariedTextField(),
                const VerticalSpacer(50),
              ],
              PrivoTextFormField(
                id: 'EMPLOYMENT_TYPE_ID',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: logic.incomeController,
                validator:(val) => incomeValidator(val,logic.incomeController,logic.validateIncome),
                onChanged: (value) => logic.workDetailsOnChange(
                  value: value,
                ),
                maxLength: 12,
                inputFormatters: [
                  NumberToRupeesFormatter(),
                ],
                keyboardType: TextInputType.number,
                enabled: !logic.isButtonLoading,
                prefixSVGIcon: Res.netMonthlyIncomeTFIconSVG,
                decoration: textFieldDecoration(
                  label: "Net Monthly Income (₹)",
                  hint: "e.g. ₹ 50,000",
                  counterWidget: const SizedBox.shrink(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Income Type",
                style: TextStyle(
                  color: primaryDarkColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const VerticalSpacer(16),
              GetBuilder<WorkDetailsLogic>(
                id: logic.INCOME_TYPE_WIDGET_ID,
                builder: (logic) {
                  return HorizontalOptionChooserWidget(
                    items: [
                      HorizontalOptionItem(
                        title: "Bank Transfer",
                        icon: Res.bankTransferIconSVG,
                      ),
                      HorizontalOptionItem(
                        title: "Cash",
                        icon: Res.cashIconSVG,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    onTap: (value) => logic.isButtonLoading
                        ? null
                        : logic.onIncomeChanged(value),
                    currentIndex: logic.selectedIncomeType,
                  );
                },
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget salariedTextField() {
    return PrivoTextFormField(
      id: logic.COMPANY_NAME_TEXT_FIELD_ID,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: logic.companyNameController,
      validator: validateCompanyName,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      enabled: !logic.isButtonLoading,
      readOnly: true,
      onTap: logic.onTapCompanyNameField,
      inputFormatters: [NoLeadingSpaceFormatter()],
      prefixSVGIcon: Res.businessEntityTFSvg,
      decoration: textFieldDecoration(
        label: "Company Name",
        hint: "e.g. Kisetsu finance",
        suffixIcon: const Icon(Icons.chevron_right),
      ),
    );
  }
}
