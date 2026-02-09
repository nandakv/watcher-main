import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/models/offer_upgrade/bank_report_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';

import '../../../../../../res.dart';
import '../../../../../theme/app_colors.dart';
///TODO :need to refactor this code
class BankAddedCardWidget extends StatelessWidget {
   BankAddedCardWidget({
    Key? key,
      required this.bankDetail,
      this.bgColor = lightBlueColor,
      this.showAdded = true})
      : super(key: key);

  final BankReport bankDetail;
  Color? bgColor;
  bool showAdded;

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      borderRadius: 8,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 8,
          top: 8,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _bankNameWidget(),
                ),
                if(showAdded)_addedWidget()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _titleValueRichText(
              title: "Account number:  ",
              value: bankDetail.accountNumber,
            ),
            if (bankDetail.ifscCode.isNotEmpty) ...[
              const SizedBox(
                height: 5,
              ),
              _titleValueRichText(
                title: "IFSC:  ",
                value: bankDetail.ifscCode,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Text _titleValueRichText({
    required String title,
    required String value,
  }) {
    return Text.rich(
      TextSpan(
          text: title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ]),
      style: const TextStyle(
        color: navyBlueColor,
      ),
    );
  }

  Container _addedWidget() {
    return Container(
      decoration: BoxDecoration(
        color: greenColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 16,
        ),
        child: Text(
          "Added",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: offWhiteColor,
          ),
        ),
      ),
    );
  }

  Padding _bankNameWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset(
                Res.default_bank,
                height: 20,
                width: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            bankDetail.bankName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: darkBlueColor,
            ),
          ),
        ],
      ),
    );
  }
}
