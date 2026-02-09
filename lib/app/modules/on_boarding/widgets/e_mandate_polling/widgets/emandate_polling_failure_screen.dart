import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/contact_details.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/mail_website_details.dart';
import 'package:privo/app/common_widgets/polling_title_widget.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/model/privo_app_bar_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/privo_app_bar.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../e_mandate/widgets/bank_details_card.dart';
import '../e_mandate_polling_logic.dart';

class EmandateFailureScreen extends StatelessWidget {
  EmandateFailureScreen({Key? key}) : super(key: key);

  var logic = Get.find<EMandatePollingLogic>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset(
                Res.eMandateFailureSVG,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 34),
                child: Text(
                  logic.failureMessage.title,
                  textAlign: TextAlign.center,
                  style: titleTextStyle(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(logic.failureMessage.subTitle,
                    textAlign: TextAlign.center, style: subTitleTextStyle()),
              ),
              const SizedBox(
                height: 20,
              ),
              if (logic.isTPVFailure)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: BankDetailsCard(
                    accountNumber: logic.accountNumber,
                    bankName: logic.bankName,
                    title: "Account used for Bank Verification",
                    showInfoWidget: false,
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: GradientButton(
                  onPressed: () {
                    logic.onTryAgainPressed();
                  },
                  edgeInsets: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 45,
                  ),
                  fillWidth: false,
                  buttonTheme: AppButtonTheme.dark,
                  title: "Try Again",
                ),
              ),
              const Spacer(),
              logic.computeShowHelpMessage() ?   Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: skyBlueColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: lightSkyBlueColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Res.bankIconDarkBlueCircleSVG,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            text:
                                "If the bank details are incorrect, please contact your ",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: darkBlueColor,
                              fontFamily: "Figtree",
                            ),
                            children: [
                              TextSpan(
                                text: "sales representative.",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: darkBlueColor,
                                  fontFamily: "Figtree",
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ) : const SizedBox(),
              // InkWell(
              //   onTap: () {
              //     showHelpPopUp(context);
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SvgPicture.asset(Res.iconneed_help),
              //       const SizedBox(
              //         width: 5,
              //       ),
              //       const Text(
              //         "Need more help?",
              //         style: TextStyle(
              //           color: Color.fromRGBO(91, 196, 240, 1),
              //           fontSize: 12,
              //           letterSpacing: 0.16,
              //           decoration: TextDecoration.underline,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
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
                      child: ContactDetails(
                        onTap: () {
                          launchUrlString('tel:18001038961',
                              mode: LaunchMode.externalApplication);
                        },
                      ),
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

  Align helpWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFFFF3EB).withOpacity(1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(7),
          color: const Color(0xFFFFF3EB),
        ),
        child: RichText(
          text: TextSpan(
            style: _consentTextStyle,
            children: <TextSpan>[
              TextSpan(
                  text:
                      'If the bank details are incorrect, please contact your ',
                  style: briTextStyle(fontWeight: FontWeight.w300)),
              TextSpan(text: 'sales representative.', style: briTextStyle()),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _consentTextStyle {
    return GoogleFonts.montserrat(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.16,
        color: const Color(0xff363840));
  }

  TextStyle briTextStyle({FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        color: const Color(0xff161742),
        fontSize: 11,
        fontFamily: 'Figtree',
        letterSpacing: 0.16);
  }

  TextStyle titleTextStyle() {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: navyBlueColor,
    );
  }

  TextStyle subTitleTextStyle() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: darkBlueColor,
    );
  }
}
