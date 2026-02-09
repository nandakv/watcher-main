import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/svg_provider.dart';
import 'package:privo/res.dart';

import '../../../../models/home_screen_model.dart';
import 'offer_zone_card_state_computation_widget.dart';

class OfferZoneSectionWidget extends StatelessWidget {
  const OfferZoneSectionWidget({
    super.key,
    required this.upgradeCards,
  });

  final List<LpcCard> upgradeCards;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin:  EdgeInsets.only(bottom: 20.h),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: SvgProvider(
            Res.offerZoneHomePageSectionBGSVG,
          ),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           VerticalSpacer(16.h),
          _offerZoneTitle(),
           Text(
            "Say hello to special offers tailored exclusively for you",
            style: AppTextStyles.bodyXSMedium(color: grey900),
          ),
          if (upgradeCards.length == 1)
            Padding(
              padding:  const EdgeInsets.all(24),
              child: OfferZoneCardStateComputationWidget(
                lpcCard: upgradeCards.first,
              ),
            )
          else
            ExpandablePageView.builder(
              alignment: Alignment.centerLeft,
              controller: PageController(
                viewportFraction: 0.9,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding:  EdgeInsets.only(
                    left: 8.w,
                    bottom: 24.h,
                    top: 24.h,
                  ),
                  child: OfferZoneCardStateComputationWidget(
                    lpcCard: upgradeCards[index],
                  ),
                );
              },
              itemCount: upgradeCards.length,
            )
        ],
      ),
    );
  }

  Widget _offerZoneTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: SvgPicture.asset(
        Res.offerZoneTextSVG,
      ),
    );
  }
}
