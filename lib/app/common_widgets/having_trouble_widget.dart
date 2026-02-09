import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/contact_details.dart';
import 'package:privo/app/common_widgets/mail_website_details.dart';
import 'package:privo/app/modules/help_support/widget/contact_us_card.dart';
import 'package:privo/app/modules/report_issue/report_issue_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HavingTroubleWidget extends StatelessWidget {
  final String screenName;
  final bool showV2ContactDetails;

  const HavingTroubleWidget({
    super.key,
    required this.screenName,
    this.showV2ContactDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Having trouble?",
          style: _havingTroubleTextStyle(),
        ),
        _bottomWidget(context)
      ],
    );
  }

  TextStyle _havingTroubleTextStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryDarkColor,
    );
  }

  Widget _bottomWidget(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          _contactCustomerSupport(context),
          _doubleArrowIcon(),
        ],
      ),
    );
  }

  WidgetSpan _contactCustomerSupport(BuildContext context) {
    return WidgetSpan(
      child: InkWell(
        onTap: () {
          if (showV2ContactDetails) {
            Get.bottomSheet(
              const BottomSheetWidget(
                childPadding: EdgeInsets.zero,
                child: ContactUsCard(),
              ),
            );
          } else {
            showHelpPopUp(context);
          }
        },
        child: Text(
          "Contact Customer Support",
          style: _customerSupportTextStyle(),
        ),
      ),
    );
  }

  TextStyle _customerSupportTextStyle() {
    return const TextStyle(
      fontSize: 12,
      fontFamily: "Figtree",
      fontWeight: FontWeight.w500,
      color: skyBlueColor,
    );
  }

  WidgetSpan _doubleArrowIcon() {
    return WidgetSpan(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SvgPicture.asset(Res.doubleArrow),
        ),
        alignment: PlaceholderAlignment.middle);
  }

  Future<dynamic> showHelpPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 35,
                          child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.clear_rounded,
                              color: appBarTitleColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ContactDetails(onTap: () {
                        launchUrlString('tel:18001038961',
                            mode: LaunchMode.externalApplication);
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MailWebSiteDetails(
                          contactType: "Mail to",
                          contactId: "support@creditsaison-in.com",
                          img: Res.mailImg,
                          onTap: () {
                            launchUrlString(
                                "mailto:grievance@creditsaison-in.com");
                          }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
