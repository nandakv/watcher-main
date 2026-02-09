import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/nudge_badge_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/modules/payment/payment_view.dart';
import 'package:privo/app/modules/payment/widgets/loan_breakdown_widget.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/badges/cs_badge.dart';

import '../../../../res.dart';
import '../../../theme/app_colors.dart';
import '../../on_boarding/model/privo_app_bar_model.dart';
import '../../on_boarding/widgets/privo_app_bar/privo_app_bar.dart';

class FinalPaymentWidget extends StatelessWidget {
  final String appbarTitle;
  final String? infoMessage;
  final Widget? consentWidget;
  final Widget? ctaWidget;
  final Widget? body;
  final Widget? topWidget;
  final LoanBreakdownModel tableData;
  final Function? onClosePressed;
  final bool showLPCinAppBar;
  final Widget? breakdownWidget;

  const FinalPaymentWidget(
      {Key? key,
      required this.appbarTitle,
      this.consentWidget,
      this.ctaWidget,
      this.body,
      required this.tableData,
      this.topWidget,
      this.showLPCinAppBar = false,
      this.onClosePressed,
        this.breakdownWidget,
      this.infoMessage})
      : super(key: key);

  Widget _appbar() {
    return Material(
      color: Colors.white,
      shadowColor: const Color(0xFF3B3B3E1A),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _closeButton(),
            HorizontalSpacer(16.w),
            Text.rich(
              TextSpan(
                text: appbarTitle,
                children: [
                  if (showLPCinAppBar)
                    TextSpan(
                      text:
                          " (${LPCService.instance.activeCard?.loanProductName})",
                      style: AppTextStyles.headingSMedium(color: blue1200),
                    ),
                ],
              ),
              style: AppTextStyles.headingSMedium(color: blue1600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _closeButton() {
    return InkWell(
      onTap: () {
        onClosePressed?.call();
      },
      child: SvgPicture.asset(Res.arrowBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _appbar(),
            Divider(
              color: grey300,
              height: 0.6.h,
            ),
            const SizedBox(
              height: 26,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            topWidget ?? const SizedBox(),
                            breakdownWidget ?? LoanBreakdownWidget(
                                    breakdownModel: tableData,
                                  ),
                            verticalSpacer(20),
                            body ?? const SizedBox(),
                            verticalSpacer(18),
                            if (infoMessage != null) _infoWidget()
                          ],
                        ),
                      )),
                    ),
                    consentWidget ?? const SizedBox(),
                    const SizedBox(
                      height: 16,
                    ),
                    ctaWidget ?? const SizedBox(),
                    const SizedBox(
                      height: 10,
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

  Widget _infoWidget() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xffFFF3EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: navyBlueColor,
            child: SvgPicture.asset(Res.info_bulb),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              infoMessage!,
              style: const TextStyle(fontSize: 10, height: 1.4),
            ),
          )
        ],
      ),
    );
  }

}
