import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/blue_background.dart';
import 'package:privo/flavors.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../res.dart';
import '../../common_widgets/gradient_button.dart';
import '../../common_widgets/terms_and_conditions_text.dart';
import 'loans_terms_logic.dart';

class LoansTermsScreen extends StatelessWidget {
  final logic = Get.find<LoansTermsLogic>();

  LoansTermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlueBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 25,
            right: 25,
            bottom: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "About Credit Saison India: Loan App",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Credit Line ranges from ₹20,000 to ₹500,000\n"
                        "Tenure: Min. 3 months | Max. 60 months\n"
                        "Interest rate: Min 9.99% pa | Max 35.99% pa\n"
                        "Processing fee - Min 1% | Max 3%*",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          height: 2,
                          letterSpacing: 0.30,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          SvgPicture.asset(Res.green_shield_svg),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            child: Text(
                              "Here is an illustration of how the loan terms could look like if you have an existing loan from Kisetsu Saison (India) Pvt Ltd.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Principal amount: ₹100,000\n"
                        "Tenure: 12 months\n"
                        "Interest rate: 14% p.a\n"
                        "EMI: ₹8,979\n"
                        "Interest Payable: ₹8,979\n"
                        "Processing fee (@1% + GST): ₹1,180\n"
                        "Total cost of loan: ₹107,748\n"
                        "Total amount disbursed: 98,628\n"
                        "BPI (Broken period interest): 192\n"
                        "APR: 16.65%",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          height: 2,
                          letterSpacing: 0.30,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Credit Saison India Mobile App's ",
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.16,
                    fontSize: 10,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms and Conditions',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrlString(
                              F.envVariables.termsAndConditionUrl,
                              mode: LaunchMode.inAppWebView,
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GradientButton(
                onPressed: logic.onPressContinue,
                title: "Continue",
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14
                ),
                buttonTheme: AppButtonTheme.light,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
