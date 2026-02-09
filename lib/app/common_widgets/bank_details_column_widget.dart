import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/modules/on_boarding/widgets/search_screen/bank_logo_mixin.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import '../../res.dart';
import '../theme/app_colors.dart';

class BankDetailsColumnWidget extends StatelessWidget with BankLogoMixin {
  BankDetailsColumnWidget({
    Key? key,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
  }) : super(key: key);

  final String bankName;
  final String accountNumber;
  final String ifscCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bankNameWidget(),
        SizedBox(
          height: 10.h,
        ),
        _titleValueRichText(
          title: "Account number:  ",
          value: accountNumber,
        ),
        if (ifscCode.isNotEmpty) ...[
          SizedBox(
            height: 5.h,
          ),
          _titleValueRichText(
            title: "IFSC:  ",
            value: ifscCode,
          ),
        ],
      ],
    );
  }

  Text _titleValueRichText({
    required String title,
    required String value,
  }) {
    return Text.rich(
      TextSpan(
          text: title,
          style: AppTextStyles.bodyXSRegular(color: navyBlueColor),
          children: [
            TextSpan(
              text: value,
              style: AppTextStyles.bodySMedium(color: navyBlueColor),
            )
          ]),
      style: const TextStyle(
        color: navyBlueColor,
      ),
    );
  }

  Padding _bankNameWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0.5, 0.5),
                  blurRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: SvgPicture.asset(
                bankName.isNotEmpty
                    ? getBankLogo(perfiosBankName: bankName)
                    : Res.default_bank,
                height: 20.h,
                width: 20.w,
              ),
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            bankName,
            style: AppTextStyles.bodyMMedium(color: darkBlueColor),
          ),
        ],
      ),
    );
  }
}
