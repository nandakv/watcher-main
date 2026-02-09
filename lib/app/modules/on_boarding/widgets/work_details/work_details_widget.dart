import 'package:after_layout/after_layout.dart';

import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/widgets/co_applicant_details/co_applicant_details_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/widgets/work_details_form_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/work_details/work_details_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/consent_text_widget.dart';
import '../../../../common_widgets/shimmer_loading/skeleton_loading_widget.dart';

class WorkDetailsWidget extends StatefulWidget {
  const WorkDetailsWidget({Key? key}) : super(key: key);

  @override
  State<WorkDetailsWidget> createState() => _WorkDetailsWidgetState();
}

class _WorkDetailsWidgetState extends State<WorkDetailsWidget>
    with AfterLayoutMixin {
  final logic = Get.find<WorkDetailsLogic>();

  String consentNote =
      'I confirm that my annual household income is greater than ₹ 3,00,000 (i.e., ₹ 25,000 per month or more)';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GetBuilder<WorkDetailsLogic>(
        builder: (logic) {
          if (logic.isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SkeletonLoadingWidget(
                skeletonLoadingType: SkeletonLoadingType.workDetails,
              ),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: WorkDetailsFormWidget(),
                ),
              ),

              ///consent widget + CTA
              const VerticalSpacer(10),
              GetBuilder<WorkDetailsLogic>(
                id: logic.WORKDETAILS_CHECK_BOX_KEY,
                builder: (logic) {
                  return ConsentTextWidget(
                    value: logic.isConsentChecked,
                    onChanged: (value) => logic.isButtonLoading
                        ? null
                        : logic.toggleIsChecked(value!),
                    consentText: consentNote,
                    checkBoxState: CheckBoxState.postRegCheckBox,
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GetBuilder<WorkDetailsLogic>(
                id: logic.BUTTON_ID,
                builder: (logic) {
                  return GradientButton(
                    title: "Next",
                    onPressed: logic.onWorkDetailsContinueTapped,
                    isLoading: logic.isButtonLoading,
                    enabled: logic.isConsentChecked
                        ? logic.isWorkDetailsFormFilled
                        : false,
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout();
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
        fontSize: 12, letterSpacing: 0.11, color: titleTextColor);
  }

  InputDecoration buildInputDecoration(
      {required String image,
      required String labelText,
      required String hintText,
      required isSvg}) {
    return InputDecoration(
        labelText: labelText,
        hintText: hintText,
        counterText: '',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        filled: true,
        fillColor: const Color(0xFFF0F4F9),
        border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)));
  }
}
