import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/account_details_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import '../../../../../common_widgets/info_bulb_widget.dart';

class BankDetailsCard extends StatelessWidget {
  String accountNumber;
  String bankName;
  bool showInfoWidget;
  String title;

  BankDetailsCard({
    Key? key,
    required this.accountNumber,
    required this.bankName,
    this.showInfoWidget = true,
    this.title = "Account used for Auto-pay registration",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
            child: AccountDetailsWidget(
              accountNumber: accountNumber,
              bankName: bankName,
              title: title,
            ),
          ),
          if (showInfoWidget)
            const InfoBulbWidget(
              text:
                  "Keep bank account and debit card/net banking details handy to set up autopay",
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
        ],
      ),
    );
  }
}
