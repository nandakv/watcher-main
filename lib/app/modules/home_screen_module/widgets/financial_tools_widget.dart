import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';
import '../../../theme/app_colors.dart';

enum FinancialToolBadge {
  newTool(
    badgeColor: blue300,
    badgeText: "New",
    badgeTextColor: blue1200,
  ),
  refresh(
    badgeColor: secondaryYellow200,
    badgeText: "Refresh",
    badgeTextColor: secondaryYellow900,
  ),
  incomplete(
    badgeColor: grey300,
    badgeText: "Incomplete",
    badgeTextColor: grey900,
  ),
  exclusive(
    badgeColor: secondaryYellow200,
    badgeText: "Exclusive",
    badgeTextColor: secondaryYellow900,
  ),
  comingSoon(
    badgeColor: grey300,
    badgeText: "Coming soon",
    badgeTextColor: grey900,
  ),
  newUpdate(
    badgeColor: green100,
    badgeText: "New Update",
    badgeTextColor: green800,
  );

  const FinancialToolBadge(
      {required this.badgeColor,
      required this.badgeText,
      required this.badgeTextColor});

  final Color badgeColor;
  final String badgeText;
  final Color badgeTextColor;
}

enum FinancialToolCardSize {
  long(cardHeight: 240, imageHeight: 155),
  wide(imageHeight: 82, contentRightPadding: 143),
  regular(imageHeight: 60);

  const FinancialToolCardSize({
    this.cardHeight = 114,
    required this.imageHeight,
    this.contentRightPadding = 12,
  });

  final double cardHeight;
  final double imageHeight;
  final double contentRightPadding;
}

enum FinancialToolType {
  finsightsRegular(
    title: "Bank Account Tracker",
    subtitle: "View and manage all your bank accounts",
    image: Res.bankAccountRegular,
  ),
  finsightsLong(
    title: "Bank Account Tracker",
    subtitle: "View and manage all your bank accounts in one place",
    image: Res.bankAccountLong,
    cardSize: FinancialToolCardSize.long,
  ),
  creditScore(
    title: "Credit Score",
    subtitle: "Get your free credit score",
    image: Res.creditScoreFinancialTools,
  ),
  emiCalculatorRegular(
    title: "EMI Calculator",
    subtitle: "Estimate your EMIs instantly",
    image: Res.emiCalculatorFinancialTools,
  ),
  emiCalculatorWide(
    title: "EMI Calculator",
    subtitle:
        "Estimate of your EMIs instantly based on loan amount, interest rate, and tenure",
    image: Res.emiCalculatoLargeFinancialTools,
    cardSize: FinancialToolCardSize.wide,
  ),
  nonEligibleFinSightRegular(
    title: "FinSights",
    subtitle: "Join the waitlist to gain financial insights ",
    image: Res.nonEligibleFinsights,
  ),
  nonEligibleFinSightLong(
    title: "FinSights",
    subtitle: "Join the waitlist to gain financial insights ",
    image: Res.nonEligibleBgImg,
    cardSize: FinancialToolCardSize.long,
  );

  const FinancialToolType({
    required this.title,
    required this.subtitle,
    required this.image,
    this.cardSize = FinancialToolCardSize.regular,
  });

  final String title;
  final String subtitle;
  final String image;
  final FinancialToolCardSize cardSize;
}

class FinancialToolsWidget extends StatelessWidget {
  final FinancialToolBadge? badge;
  final FinancialToolType tool;
  final Function() onTap;
  final Color bgColor;
  final bool isLocked;

  FinancialToolsWidget({
    super.key,
    this.badge,
    required this.tool,
    required this.onTap,
    this.bgColor = Colors.white,
    this.isLocked = false,
  });

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: tool.cardSize.cardHeight.h,
            decoration: _cardDecoration(),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                _backgroundImage(),
                _content(),
              ],
            ),
          ),
          isLocked ? _lockToolCard() : const SizedBox()
        ],
      ),
    );
  }

  Widget _content() {
    return Container(
      padding: EdgeInsets.only(
        top: 12.w,
        bottom: 12.w,
        left: 12.w,
        right: tool.cardSize.contentRightPadding.w,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tool.title,
            style: AppTextStyles.bodySSemiBold(color: navyBlueColor),
          ),
          VerticalSpacer(4.h),
          FutureBuilder<bool>(
            future: logic.isUserOnFinsightsWaitList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return Text(
                _computeTitle(snapshot),
                style: AppTextStyles.bodyXSRegular(
                    color: AppTextColors.neutralBody),
              );
            },
          ),
          const Spacer(),
          _badge(),
        ],
      ),
    );
  }

  Widget _backgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.r)),
      child: SvgPicture.asset(
        tool.image,
        width: double.infinity,
        height: tool.cardSize.imageHeight.h,
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8.r),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          blurRadius: 4,
          spreadRadius: 0,
          offset: Offset(0, 0),
        ),
      ],
    );
  }

  Widget _badge() {
    if (badge == null) {
      return const SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: badge!.badgeColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        badge!.badgeText,
        style: AppTextStyles.bodyXSRegular(color: badge!.badgeTextColor),
      ),
    );
  }

  String _computeTitle(AsyncSnapshot<bool> snapshot) {
    switch (tool) {
      case FinancialToolType.finsightsRegular:
      case FinancialToolType.finsightsLong:
      case FinancialToolType.creditScore:
      case FinancialToolType.emiCalculatorRegular:
      case FinancialToolType.emiCalculatorWide:
        return tool.subtitle;
      case FinancialToolType.nonEligibleFinSightRegular:
      case FinancialToolType.nonEligibleFinSightLong:
        return snapshot.data!
            ? tool.subtitle
            : "You are currently added to the waitlist";
    }
  }

  Widget _lockToolCard() {
    return SizedBox(
      height: tool.cardSize.cardHeight.h,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.8),
          gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0.9)
              ]),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            tool.cardSize == FinancialToolCardSize.long
                ? SizedBox(
                    height: tool.cardSize.cardHeight.h / 4,
                  )
                : const SizedBox(),
            Flexible(
              flex: 3,
              child: Column(
                children: [
                  tool.cardSize == FinancialToolCardSize.long
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SvgPicture.asset(
                            Res.lock,
                            height: 64.h,
                            width: 64.w,
                          ),
                        )
                      : const SVGIcon(
                          size: SVGIconSize.extraLarge, icon: Res.lock),
                  Text(
                    'Feature Locked',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySSemiBold(color: blue1600),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    child: Text(
                      'Pay your pending dues to access ${computeText()}',
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyles.bodyXSRegular(color: primaryDarkColor),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  computeText() {
    switch (tool) {
      case FinancialToolType.finsightsLong:
        return "Finsights";
      case FinancialToolType.finsightsRegular:
        return "Finsights";
      case FinancialToolType.creditScore:
        return "Credit Score";
    }
  }
}
