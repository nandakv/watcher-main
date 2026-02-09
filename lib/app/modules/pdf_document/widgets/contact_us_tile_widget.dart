import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/help_support/widget/contact_us_card.dart';
import 'package:privo/app/modules/loan_details/loan_details_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShowCustomerSupportBottomSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  const ShowCustomerSupportBottomSheet(
      {super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: AppTextStyles.headingSMedium(
              color: AppTextColors.brandBlueTitle,
            ),
          ),
        ),
        VerticalSpacer(12.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            subTitle,
            textAlign: TextAlign.start,
            style: AppTextStyles.bodySRegular(
              color: AppTextColors.neutralBody,
            ),
          ),
        ),
        VerticalSpacer(24.h),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              color: primaryLightColor),
          child: const ContactUsTileWidget(style: ContactUsSvgStyle.outline),
        ),
      ],
    );
  }
}

class ContactUsTileWidget extends StatelessWidget {
  final ContactUsSvgStyle style;
  const ContactUsTileWidget({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (style == ContactUsSvgStyle.outline) VerticalSpacer(12.h),
        ContactUsTile(
          iconPath: (style == ContactUsSvgStyle.outline)
              ? Res.newPhoneSvg
              : Res.phoneImg,
          title: "Helpline (9:30am - 6:30pm)",
          subtitle: "1800-1038-961",
          onTap: () {
            launchUrlString('tel:18001038961',
                mode: LaunchMode.externalApplication);
          },
        ),
        ContactUsTile(
          iconPath: (style == ContactUsSvgStyle.outline)
              ? Res.newMailSvg
              : Res.mailImg,
          title: "Mail to",
          subtitle: "support@creditsaison-in.com",
          onTap: () {
            launchUrlString("mailto:support@creditsaison-in.com");
          },
        ),
        if (style == ContactUsSvgStyle.outline) VerticalSpacer(12.h),
      ],
    );
  }
}
