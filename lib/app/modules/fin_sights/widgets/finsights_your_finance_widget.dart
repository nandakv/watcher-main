import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/components/pill_button.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';

import '../finsights_transaction_error.dart';
import 'finsights_your_finance_bar_chart.dart';

class FinsightsYourFinanceWidget extends StatelessWidget {
  FinsightsYourFinanceWidget({super.key});

  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinSightsLogic>(
      id: logic.YOUR_FINANCE_WIDGET_KEY,
      builder: (logic) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your Finances").headingSMedium(color: navyBlueColor),
              const VerticalSpacer(16),
              if (logic.overviewModel.months.length == 6) ...[
                _monthSelectionWidget(),
                const VerticalSpacer(16),
              ],
              logic.overviewModel.months.isEmpty
                  ? FinsightsTransactionError()
                  : GradientBorderContainer(
                      width: double.infinity,
                      borderRadius: 8,
                      child: FinsightsYourFinanceBarChart(),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _monthSelectionWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PillButton(
          text: "Last 3 months",
          onTap: logic.onTapLast3Months,
          isSelected: logic.last3MonthsSelected,
        ),
        const HorizontalSpacer(8),
        PillButton(
          text: "Last 6 months",
          onTap: logic.onTapLast6Months,
          isSelected: !logic.last3MonthsSelected,
        ),
      ],
    );
  }
}
