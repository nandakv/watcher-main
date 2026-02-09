import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

class NoTransactions extends StatelessWidget {
  const NoTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Expanded(
                flex: 3,
                child: SvgPicture.asset(
                  Res.nothingToSeeHere,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Text(
                  "Nothing to see here!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingMSemiBold(color: darkBlueColor),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
               Flexible(
                child: Text(
                  "We couldn't find any transactions in your account. Please change the filter to see other transactions",
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: AppTextStyles.bodySRegular(color: darkBlueColor)
                ),
              ),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
