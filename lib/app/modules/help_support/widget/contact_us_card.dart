import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../res.dart';

class ContactUsCard extends StatelessWidget {
  final Function()? onCallClicked;
  final Function()? onEmailClicked;

  const ContactUsCard({Key? key, this.onCallClicked, this.onEmailClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select your preferred option",
              ).headingSMedium(color: darkBlueColor),
              verticalSpacer(32),
              ContactUsTile(
                iconPath: Res.phoneImg,
                title: "Helpline (9:30am - 6:30pm)",
                subtitle: "1800-1038-961",
                onTap: () {
                  launchUrlString('tel:18001038961',
                      mode: LaunchMode.externalApplication);
                  onCallClicked?.call();
                },
              ),
              ContactUsTile(
                iconPath: Res.mailImg,
                title: "Mail to",
                subtitle: "support@creditsaison-in.com",
                onTap: () {
                  launchUrlString("mailto:support@creditsaison-in.com");
                  onEmailClicked?.call();
                },
              ),
              verticalSpacer(12),
              const Divider(
                height: 1,
                thickness: 0.6,
                color: secondaryDarkColor,
              ),
              verticalSpacer(16),
              Center(child: _grievanceMail()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _grievanceMail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "To report issue or grievance mail to",
            style: TextStyle(
              color: darkBlueColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: () {
              launchUrlString("mailto:grievance@creditsaison-in.com");
            },
            child: const Text(
              "grievance@creditsaison-in.com",
              style: TextStyle(
                color: primaryDarkColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactUsTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final Function() onTap;

  const ContactUsTile(
      {Key? key,
      required this.iconPath,
      required this.title,
      required this.subtitle,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 16,
              ),
              child: SvgPicture.asset(
                iconPath,
                color: primaryDarkColor,
                width: 18,
                height: 18,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: secondaryDarkColor,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: primaryDarkColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.9,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
