import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class TotalPayableDetailsBottomSheet extends StatelessWidget {
  final LoanDetailsModel loanDetailsModel;

  const TotalPayableDetailsBottomSheet({
    super.key,
    required this.loanDetailsModel
  });

  @override
  Widget build(BuildContext context) {

    return BottomSheetWidget(
      enableCloseIconButton: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total payable',
            style: AppTextStyles.headingSMedium(
                color: AppTextColors.brandBlueTitle),
          ),
          SizedBox(height: 12.h),

          // Card for Total Amount Payable
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Container(
                  color: blue200,
                  padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                  child: _buildRow(
                    'Total amount payable (A)',
                    AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
                        loanDetailsModel.totalPayable.totalAmountPayable),
                    isSubtitle: false,
                  ),
                ),
                Container(
                  color: blue100,
                  padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
                  child: Column(
                    children: [
                      _buildRow(
                        'Principal',
                        AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(double.parse(loanDetailsModel.loanAmount)),
                      ),
                      SizedBox(height: 8.h),
                      _buildRow(
                        'Interest',
                        AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(double.parse(loanDetailsModel.totalProfit)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Container(
                  color: blue200,
                  padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                  child: _buildRow(
                    'Amount paid (B)',
                    AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(loanDetailsModel.totalPayable.amountPaid),
                    isSubtitle: false,
                  ),
                ),
                Container(
                  color: blue100,
                  padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
                  child: Column(
                    children: [
                      _buildRow(
                        'Principal paid',
                        AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(double.parse(loanDetailsModel.totalPrincipalPaid)),
                      ),
                      SizedBox(height: 8.h),
                      _buildRow(
                        'Interest paid',
                        AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(double.parse(loanDetailsModel.totalInterestPaid)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(
              color: AppBackgroundColors.neutralLightSubtle,
              height: 1.h,
            ),
          ),
          _buildRow(
            'Amount payable (A-B)',
            AppFunctions()
                .parseNumberToCommaFormatWithRupeeSymbol(loanDetailsModel.totalPayable.amountPayable),
            isSubtitle: false,
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isSubtitle = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: isSubtitle
                ? AppTextStyles.bodySRegular(color: AppTextColors.neutralBody)
                : AppTextStyles.bodySMedium(
                color: AppTextColors.neutralDarkBody)),
        Text(value,
            style: AppTextStyles.bodySSemiBold(
                color: AppTextColors.neutralDarkBody)),
      ],
    );
  }
}