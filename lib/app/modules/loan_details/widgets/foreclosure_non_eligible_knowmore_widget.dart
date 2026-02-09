import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../res.dart';
import '../../../common_widgets/bottom_sheet_widget.dart';
import '../../../common_widgets/rich_text_widget.dart';
import '../../../common_widgets/spacer_widgets.dart';
import '../../../firebase/analytics.dart';
import '../../../models/rich_text_model.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/web_engage_constant.dart';
import '../../faq/faq_page.dart';
import '../../faq/faq_utility.dart';

class ForeclosureNonEligibleKnowMoreWidget extends StatelessWidget {
  const ForeclosureNonEligibleKnowMoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Res.informationOutlined,
            width: 56.w,
            height: 56.w,
          ),
          VerticalSpacer(16.h),
          RichTextWidget(
            textAlign: TextAlign.left,
            infoList: [
              RichTextModel(
                text:
                "Foreclosure means paying off your entire loan amount before its scheduled end date. You can make the payment on the app. However, please be aware that this process may involve foreclosure charges. Learn more with",
                textStyle: AppTextStyles.bodySRegular(
                  color: AppTextColors.neutralBody,
                ),
              ),
              RichTextModel(
                text: " FAQs",
                textStyle: AppTextStyles.bodySRegular(
                  color: AppTextColors.link,
                ),
                onTap: () async {
                  AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: WebEngageConstants.seeMoreFAQ,
                    attributeName: {
                      "faq_prepay": true,
                    },
                  );
                  await Get.to(
                        () => FAQPage(
                      faqModel: FAQUtility().foreClosureFAQs,
                    ),
                  );
                  AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: WebEngageConstants.closeScreen,
                    attributeName: {
                      "close_faq_prepay": true,
                    },
                  );
                },
              ),
            ],
          ),
          VerticalSpacer(24.h),
        ],
      ),
    );
  }

}