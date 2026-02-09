import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/financial_tools_widget.dart';
import 'package:privo/app/modules/non_eligible_finsights/non_eligible_finsights_analytics_mixin.dart';
import 'package:privo/app/modules/non_eligible_finsights/non_eligible_finsights_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import 'package:privo/res.dart';

import '../../../data/provider/auth_provider.dart';
import '../../../routes/app_pages.dart';

class FinancialTools extends StatelessWidget {
  final logic = Get.find<HomeScreenLogic>();

  FinancialTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            "Financial Tools",
            style: AppTextStyles.headingXSMedium(color: appBarTitleColor),
          ),
          VerticalSpacer(12.h),
          _computeCards(),
        ],
      ),
    );
  }

  Widget _computeCards() {
    final financialTools = logic.multiLPCCardsModel.financialTools;

    final hasCreditScore = financialTools.creditScore != null;
    final hasFinsights = financialTools.finSights != null;

    final isFinsightsLarge = hasCreditScore;

    final finsightsCard = hasFinsights
        ? _finsightsCard(
            financialTools.finSights!,
            hasCreditScore
                ? FinancialToolType.finsightsLong
                : FinancialToolType.finsightsRegular,)
        : _nonEligibleFinSightsCard(
            hasCreditScore
                ? FinancialToolType.nonEligibleFinSightLong
                : FinancialToolType.nonEligibleFinSightRegular,
          );

    if (!hasFinsights && hasCreditScore) {
      logic.logfinsightsHomeScreenLoadedNEFNE();
    }

    final cards = <Widget>[
      finsightsCard,
      if (hasCreditScore)
        _creditScoreCard(
            financialTools.creditScore!),
    ];

    final emiCard = _emiCalculatorCard(
      cards.isEmpty
          ? FinancialToolType.emiCalculatorWide
          : FinancialToolType.emiCalculatorRegular,
    );
    cards.add(emiCard);

    return isFinsightsLarge
        ? Row(
            children: [
              Expanded(child: cards.removeAt(0)),
              HorizontalSpacer(12.w),
              Expanded(
                child: Column(
                  children:
                      cards.expand((c) => [c, VerticalSpacer(12.h)]).toList()
                        ..removeLast(),
                ),
              ),
            ],
          )
        : Row(
            children: cards
                .expand((c) => [Expanded(child: c), HorizontalSpacer(12.w)])
                .toList()
              ..removeLast(),
          );
  }

  Widget _finsightsCard(FinSightsModel finsightsModel, FinancialToolType type) {
    return Stack(
      children: [
        FinancialToolsWidget(
          isLocked: finsightsModel.isLocked,
          badge: _computeFinsightsBadge(finsightsModel),
          tool: type,
          onTap: () {
            if (!finsightsModel.isLocked) logic.onTapFinSights(finsightsModel);
          },
        ),
      ],
    );
  }

  Widget _creditScoreCard(
      CreditScoreModel creditScoreModel) {
    return Stack(
      children: [
        FinancialToolsWidget(
            isLocked: creditScoreModel.isLocked,
            badge: creditScoreModel.refreshAvailable
                ? FinancialToolBadge.refresh
                : null,
            tool: FinancialToolType.creditScore,
            onTap: () {
              if (!creditScoreModel.isLocked) logic.goToCreditReport();
            }),
      ],
    );
  }

  Widget _emiCalculatorCard(FinancialToolType type) {
    return FinancialToolsWidget(
      tool: type,
      onTap: () {
        Get.toNamed(Routes.EMI_CALCULATOR);
      },
    );
  }

  _nonEligibleFinSightsCard(FinancialToolType type) {
    return FutureBuilder<FinancialToolBadge?>(
      future: computeFinancialToolBadge(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final financialToolBadge = snapshot.data;

        return FinancialToolsWidget(
          badge: financialToolBadge,
          bgColor: primarySubtleColor,
          tool: type,
          onTap: () async {
            await logic.onNonFinSightHomeClick();
          },
        );
      },
    );
  }

  Future<FinancialToolBadge?> computeFinancialToolBadge() async {
    final isOnWaitList = await AppAuthProvider.finsightsWaitList;
    return isOnWaitList
        ? FinancialToolBadge.exclusive
        : FinancialToolBadge.comingSoon;
  }

  FinancialToolBadge? _computeFinsightsBadge(FinSightsModel finsightsModel) {
    switch (finsightsModel.tag) {
      case "New Update":
        return FinancialToolBadge.newUpdate;
      case "Incomplete":
        return FinancialToolBadge.incomplete;
      case "New":
        return FinancialToolBadge.newTool;
      default:
        return null;
    }
  }
}
