import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AccountDetailsWidget extends StatelessWidget {
  final String accountNumber;
  final String bankName;
  final String title;

  const AccountDetailsWidget(
      {Key? key,
      required this.accountNumber,
      required this.bankName,
      this.title = "Account used for Auto-pay registration"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _accountDetailsWidget();
  }

  Column _accountDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isNotEmpty
            ? Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.13,
                  color: darkBlueColor,
                ),
              )
            : const SizedBox(),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: _buildBankName(),
              ),
              Expanded(
                flex: 2,
                child: _buildAccountNumber(),
              )
            ],
          ),
        )
      ],
    );
  }

  Column _buildAccountNumber() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Account No.",
          style: TextStyle(
              color: accountSummaryTitleColor,
              fontSize: 10,
              letterSpacing: 0.16),
        ),
        const SizedBox(
          height: 8,
        ),
        Flexible(
          child: Text(
            accountNumber,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xff404040),
                fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }

  Row _buildBankName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          Res.default_bank,
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: Text(
            bankName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xff404040),
            ),
          ),
        ),
      ],
    );
  }
}
