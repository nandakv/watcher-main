import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_insurance/withdraw_insurance_deatils_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../firebase/analytics.dart';
import '../../../../models/withdrawal_calculation_model.dart';
import '../../../../utils/web_engage_constant.dart';

class WithdrawInsuranceDetailsPage extends StatelessWidget {
  WithdrawInsuranceDetailsPage({
    Key? key,
  }) : super(key: key);

  final logic = Get.find<WithdrawInsuranceDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => logic.onBackAndClosePressed(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                _appBar(),
                const SizedBox(
                  height: 25,
                ),
                _policyDetailsContainer(),
                const SizedBox(
                  height: 20,
                ),
                _policyBenefitWidget(),
                const SizedBox(
                  height: 20,
                ),
                _howToClaimWidget(),
                const SizedBox(
                  height: 25,
                ),
                _customerSupportWidget(),
                const SizedBox(
                  height: 32,
                ),
                _moreInfoWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _appBar() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Insurance Details",
            style: GoogleFonts.poppins(
              color: navyBlueColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
          constraints: const BoxConstraints(
            maxWidth: 28,
            maxHeight: 28,
          ),
          onPressed: logic.onBackAndClosePressed,
          icon: SvgPicture.asset(Res.close_mark_svg),
        ),
      ],
    );
  }

  Column _customerSupportWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer support",
          style: _headerTextStyle(),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            AppAnalytics.trackWebEngageEventWithAttribute(
                eventName: WebEngageConstants.numberSupportClicked);
            logic.onPhoneTapped(
              logic.insuranceDetails.customerSupportContacts.phone
                  .replaceAll(" ", ""),
            );
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff284689),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(Res.phoneImg),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "24x7 toll free helpline",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: primaryDarkColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      logic.insuranceDetails.customerSupportContacts.phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: darkBlueColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () {
            AppAnalytics.trackWebEngageEventWithAttribute(
                eventName:WebEngageConstants.emailSupportClicked);
            logic.onEmailTapped(
                logic.insuranceDetails.customerSupportContacts.email);
          },
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff284689),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(Res.mailImg),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email to",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: primaryDarkColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      logic.insuranceDetails.customerSupportContacts.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: darkBlueColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _policyDetailsContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: navyBlueColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(0.18),
            1: FlexColumnWidth(0.82),
          },
          children: logic.insuranceDetails.policyDetails
              .map((e) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          e.title,
                          style: _tableTitleTextStyle(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          e.text,
                          style: _tableValueTextStyle(),
                        ),
                      )
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }

  TextStyle _tableTitleTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: navyBlueColor,
    );
  }

  TextStyle _tableValueTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: navyBlueColor,
    );
  }

  Column _policyBenefitWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Policy Benefits",
          style: _headerTextStyle(),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Click on each benefit to know more",
          style: _clickHereTextStyle(),
        ),
        const SizedBox(
          height: 15,
        ),
        Wrap(
          runSpacing: 15,
          spacing: 10,
          children: logic.insuranceDetails.policyBenefits
              .map((e) => _policyBenefitIcon(e))
              .toList(),
        ),
      ],
    );
  }

  TextStyle _clickHereTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w400,
      color: darkBlueColor,
      fontSize: 10,
    );
  }

  Widget _policyBenefitIcon(PolicyBenefit policyBenefit) {
    return SizedBox(
      width: 60,
      child: InkWell(
        onTap: () => logic.openPolicyBenefitBottomSheet(policyBenefit),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: navyBlueColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(policyBenefit.icon),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              policyBenefit.benefitTitle,
              style: _benefitTextStyle(),
              maxLines: 2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  TextStyle _benefitTextStyle() {
    return const TextStyle(
      color: darkBlueColor,
      fontWeight: FontWeight.w500,
      fontSize: 8,
    );
  }

  Column _howToClaimWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How to claim?",
          style: _headerTextStyle(),
        ),
        const SizedBox(
          height: 15,
        ),
        ListView.separated(
          itemBuilder: (context, index) {
            return Text(
              logic.insuranceDetails.howTo[index],
              style: _howToTextStyle(),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemCount: logic.insuranceDetails.howTo.length,
          shrinkWrap: true,
        ),
      ],
    );
  }

  TextStyle _howToTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: primaryDarkColor,
      letterSpacing: 0.23,
      height: 1.2,
    );
  }

  TextStyle _headerTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: primaryDarkColor,
    );
  }

  Column _moreInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "For more information",
          style: _headerTextStyle(),
        ),
        const SizedBox(
          height: 4,
        ),
        InkWell(
          onTap: () {
            launchUrlString(
              logic.onPressInsuranceProductGlossary(),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Text(
            "Insurance Product Glossary",
            style: _linkTextStyle(),
          ),
        ),
      ],
    );
  }

  TextStyle _linkTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: skyBlueColor,
      fontFamily: 'Figtree',
      decoration: TextDecoration.underline,
    );
  }
}
