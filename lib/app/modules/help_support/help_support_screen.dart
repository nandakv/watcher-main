import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/contact_details.dart';
import 'package:privo/app/common_widgets/mail_website_details.dart';
import 'package:privo/app/modules/faq/widget/faq_tile.dart';
import 'package:privo/app/modules/help_support/help_support_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/app_bar_bottom_divider.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../res.dart';
import '../../common_widgets/line_separator.dart';
import '../../common_widgets/raise_an_issue/raise_an_issue_widget.dart';
import '../navigation_drawer/navigation_drawer_view.dart';
import 'help_constant_text.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final logic = Get.find<HelpAndSupportLogic>();

  Widget get _loanCancellationWidget {
    return InkWell(
      onTap: logic.onLoanCancellationClicked,
      child: Column(
        children: [
          const LineSeparator(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Loan Cancellation",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: darkBlueColor,
                    )),
                const Icon(
                  Icons.chevron_right,
                  weight: 2,
                  color: secondaryDarkColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onBackPressed,
      child: Scaffold(
        key: logic.homePageScaffoldKey,
        drawer: const NavigationDrawerPage(
          rowIndex: 4,
          key: Key("help_and_support"),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Text(
            helpAndSupport,
            style: appBarTextStyle,
          ),
          elevation: 0,
          shadowColor: const Color(0xFF3B3B3E1A),
          titleSpacing: logic.isUserFromLoanDetails ? -30 : -2,
          leading: logic.isUserFromLoanDetails
              ? const SizedBox()
              : _appDrawerWidget(),
          actions: [
            logic.isUserFromLoanDetails ? _closeIconWidget() : const SizedBox(),
          ],
        ),
        body: Column(
          children: [
            const AppBarBottomDivider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    faqS(),
                    const SizedBox(
                      height: 24,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        moreFaqList(),
                        if (logic.showLoanCancellation) _loanCancellationWidget,
                        const LineSeparator(),
                        const SizedBox(
                          height: 22,
                        ),
                        _raiseIssueWidget(),
                        enquiry(),
                        const SizedBox(
                          height: 40,
                        ),
                        const LineSeparator(),
                        const SizedBox(
                          height: 30,
                        ),
                        grievanceMail(),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _raiseIssueWidget() {
    return GetBuilder<HelpAndSupportLogic>(
        id: logic.RAISE_AN_ISSUE_ID,
        builder: (logic) {
          if (logic.isReportIssueEnabled) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: RaiseAnIssueCard(
                onTap: logic.onRaiseIssueTapped,
              ),
            );
          }
          return const SizedBox();
        });
  }

  IconButton _closeIconWidget() {
    return IconButton(
      onPressed: Get.back,
      icon: const Icon(
        Icons.clear_rounded,
        color: appBarTitleColor,
      ),
    );
  }

  Widget _appDrawerWidget() {
    return InkWell(
      onTap: logic.openDrawer,
      child: SvgPicture.asset(Res.hamburger),
    );
  }

  Widget enquiry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            "Need more help?",
            style:
                commonTextStyle(12, FontWeight.normal, const Color(0xFF363840)),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ContactDetails(
          onTap: logic.onContactDetailsClicked,
        ),
        const SizedBox(
          height: 16,
        ),
        MailWebSiteDetails(
          contactType: "Mail to",
          contactId: "support@creditsaison-in.com",
          img: Res.mailImg,
          onTap: logic.onEmailClicked,
        ),
        const SizedBox(
          height: 16,
        ),
        MailWebSiteDetails(
          contactType: "Website",
          contactId: "www.privo.in",
          img: Res.web_svg,
          onTap: () {
            launchUrlString("https://www.privo.in",
                mode: LaunchMode.externalApplication);
          },
        ),
      ],
    );
  }

  Widget moreFaqList() {
    return ListView.builder(
        itemCount: logic.faqs.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FAQTile(
              question: logic.faqs[index].question,
              answer: logic.faqs[index].answer,
              isExpanded: index == 0,
            ),
          );
        });
  }

  Widget imgContainer(String img) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff284689),
        borderRadius: BorderRadius.circular(9),
      ),
      height: 40,
      width: 37,
      child: Padding(
          padding: const EdgeInsets.all(10), child: SvgPicture.asset(img)),
    );
  }

  Widget faqS() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            frequentlyAskedQuestion, style: faqTitleTextStyle,
            //    commonTextStyle(14, FontWeight.w600, const Color(0xFF3B3B3E1A)),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        instantCredit(),
      ],
    );
  }

  TextStyle get faqTitleTextStyle {
    return GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: const Color(0x4C151742),
    );
  }

  Widget instantCredit() {
    return Container(
      // height: 127,
      // width: 312,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffE1F1FF),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What is Privo Instant Loan?",
            style: headingTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            creditLineDefinition,
            style: blueLineTextStyle,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget grievanceMail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              "To report issue or grievance mail to",
              style: blueLineTextStyle,
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                launchUrlString("mailto:grievance@creditsaison-in.com");
              },
              child: Text(
                "grievance@creditsaison-in.com",
                style: headingTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get lightTextStyle {
    return GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      color: const Color(0xff707070),
    );
  }

  TextStyle get boldTextStyle {
    return GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: .11,
        color: const Color(0xff004097));
  }

  TextStyle get headingTextStyle {
    return const TextStyle(
        fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xFF404040));
  }

  TextStyle get blueLineTextStyle {
    return const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: Color(0xFF1D478E),
        height: 1.4);
  }

  TextStyle get appBarTextStyle => GoogleFonts.poppins(
        fontSize: 14,
        color: const Color(0xFF161742),
        letterSpacing: 0.11,
        fontWeight: FontWeight.w500,
      );

  TextStyle commonTextStyle(
      double fontSize, FontWeight fontWeight, Color color) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }
}
