import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/know_more_benefits.dart';
import 'package:privo/app/modules/fin_sights/widgets/security_first.dart';
import 'package:privo/app/modules/fin_sights/widgets/three_step_process_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class KnowMoreBodyWidget extends StatelessWidget {
  const KnowMoreBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Track transactions and monitor finances effortlessly, backed by secure and reliable technology",
          textAlign: TextAlign.center,
          style: _textStyle(),
        ),
        const VerticalSpacer(40),
        KnowMoreBenefits(
          smartBenefits: smartBenefits(),
        ),
        const VerticalSpacer(40),
      ],
    );
  }

  List<SmartBenefitsModel> smartBenefits() {
    return [
      SmartBenefitsModel(
          title: "Holistic financial overview",
          icon: Res.financialOverview,
          subTitle:
              "View all your banking accounts and financial details in one place"),
      SmartBenefitsModel(
          title: "Personalised & efficient insights",
          icon: Res.insights,
          subTitle: "Get valuable insights tailored to your spending habits"),
      SmartBenefitsModel(
          title: "Enhanced credit",
          icon: Res.enhancedCredit,
          subTitle: "Access higher credit limits with ease and flexibility"),
      SmartBenefitsModel(
          title: "Seamless future financing",
          icon: Res.seamless,
          subTitle: "Get funds faster with seamless processing"),
    ];
  }

  TextStyle _textStyle() {
    return const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400, color: secondaryDarkColor);
  }
}
