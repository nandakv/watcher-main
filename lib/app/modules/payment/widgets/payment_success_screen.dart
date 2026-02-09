import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/success_screen.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/home_screen_module/widgets/info_message_widget.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/modules/payment/model/payment_success_model.dart';
import 'package:privo/app/modules/payment/widgets/payment_details_top_widget.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/components/button.dart';

import '../../../../res.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/app_functions.dart';
import 'loan_breakdown_widget.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late LoanBreakdownModel loanBreakdownData;
  late PaymentSuccessModel paymentSuccessModel;

  @override
  void initState() {
    super.initState();
    _initializeVariables();
  }

  _initializeVariables() {
    paymentSuccessModel = Get.arguments;
    if (!paymentSuccessModel.isWithdrawalBlocked) {
      AppFunctions().showInAppReview(paymentSuccessModel.appRatingPromptEvent);
    }
    loanBreakdownData = LoanBreakdownModel(
      backgroundColor: primarySubtleColor,
      borderRadiusGeometry: BorderRadius.circular(8.r),
      breakdownRowData: [
        LoanBreakdownRowData(
            key: paymentSuccessModel.refIdKey,
            keyTextStyle: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralDarkBody),
            valueTextStyle: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralDarkBody),
            value: paymentSuccessModel.refIdValue),
        LoanBreakdownRowData(
          key: "Payment time",
          value: formatDateTime(DateTime.now()),
          keyTextStyle:
              AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody),
          valueTextStyle:
              AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody),
        ),
      ],
    );
  }

  String formatDateTime(DateTime dateTime) {
    String formatted = DateFormat("hh:mm a, d MMM ''yy").format(dateTime);
    return formatted.replaceAll('AM', 'am').replaceAll('PM', 'pm');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _paymentSuccessTopWidget(),
              Text(
                paymentSuccessModel.amount,
                style: AppTextStyles.headingXLSemiBold(color: navyBlueColor),
              ),
              Text(
                "Payment successful!\nYour request will be processed soon ",
                style: AppTextStyles.bodySMedium(
                    color: AppTextColors.neutralBody),
                textAlign: TextAlign.center,
              ),
              VerticalSpacer(48.h),
              _paymentBreakdown(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: _bottomInfoWidget(),
              ),
              const Spacer(),
              _goToHomeWidget(),
              VerticalSpacer(32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoMessage() {
    return paymentSuccessModel.infoMessage.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: InfoMessageWidget(
              infoMessage: paymentSuccessModel.infoMessage,
              infoIcon: Res.info_bulb,
              bgColor: const Color(0xff183F77),
              borderRadius: 12,
            ),
          )
        : const SizedBox();
  }

  Widget _bottomInfoWidget() {
    return Text(
      paymentSuccessModel.bottomInfoText,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 10,
        fontFamily: 'Figtree',
        color: secondaryDarkColor,
      ),
    );
  }

  Widget _goToHomeWidget() {
    return Button(
      buttonType: ButtonType.primary,
      buttonSize: ButtonSize.large,
      title: "Go home",
      onPressed: () {
        Get.offAllNamed(Routes.HOME_SCREEN);
        paymentSuccessModel.onGoToHomeClicked();
      },
    );
  }

  Widget _paymentSuccessTopWidget() {
    return SuccessScreen(
      title: "",
      img: Res.paymentSuccessIcon,
      enableCloseIconButton: true,
      subTitle: "",
      onCloseClicked: () {
        Get.back();
        paymentSuccessModel.onCloseClicked();
      },
    );
  }

  Widget _paymentBreakdown() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 24.w),
      child: LoanBreakdownWidget(
        breakdownModel: loanBreakdownData,
      ),
    );
  }
}
