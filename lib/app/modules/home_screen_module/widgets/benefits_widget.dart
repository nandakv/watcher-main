import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/home_screen_module/model/benefits_model.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../common_widgets/gradient_border_container.dart';

class BenefitsWidget extends StatelessWidget {
  final List<BenefitsModel> benefitsList;
  const BenefitsWidget({Key? key, required this.benefitsList})
      : super(key: key);

  Widget get _benefitTitle {
    return const Text(
      "Credit Line Benefits",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: darkBlueColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _benefitTitle,
          verticalSpacer(12),
          _listofBenefits,
          verticalSpacer(32),
        ],
      ),
    );
  }

  Widget get _listofBenefits {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: benefitsList.map((benefit) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _benefitTile(benefit),
        )).toList(),
      ),
    );
  }

  Widget _benefitTile(BenefitsModel benefit) {
    return GradientBorderContainer(
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        child: Column(
          children: [
            SvgPicture.asset(benefit.iconPath),
            verticalSpacer(12),
            Text(
              benefit.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: darkBlueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
