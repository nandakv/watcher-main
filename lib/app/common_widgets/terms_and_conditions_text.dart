import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/flavors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text:
                'By continuing, you agree to Credit Saison India Mobile App’s ',
            style: const TextStyle(
                color: navyBlueColor,
                letterSpacing: 0.16,
                fontSize: 10,
                fontWeight: FontWeight.w400),
            children: [
              TextSpan(
                text: 'Terms and Conditions',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrlString(
                        F.envVariables.termsAndConditionUrl,
                        mode: LaunchMode.externalApplication,
                      ),
                style: const TextStyle(
                  color: Color(0xff91D5EA),
                  decoration: TextDecoration.underline,
                ),
              ),
              const TextSpan(
                text: ' and ',
              ),
              TextSpan(
                text: 'Privacy Policy',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrlString(
                        F.envVariables.privacyPolicyUrl,
                        mode: LaunchMode.externalApplication,
                      ),
                style: const TextStyle(
                  color: Color(0xff91D5EA),
                  decoration: TextDecoration.underline,
                ),
              ),
              const TextSpan(
                text:
                    '  and authorize our representatives and agents to contact me and to receive communication via SMS, Email, Phone and WhatsApp for transactional or promotional information',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
