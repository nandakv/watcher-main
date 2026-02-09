
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoanIconContainer extends StatelessWidget {
  String? title;
  String? icon;
  String? value;

  LoanIconContainer({Key? key, this.icon, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:const EdgeInsets.only(
            left: 20.22,
            top: 11,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Icon
              SvgPicture.asset(icon ?? "assets/svg/Due_Date.svg",
                color: Colors.grey,
                height: 15,
                width: 15,
              ),
              const SizedBox(
                width: 8.54,
              ),
              //Title like Next EMI
              Text(
                title ?? "",
                style: const TextStyle(
                    fontSize: 12,
                    color: subtextColor),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 45,
            top: 4,
          ),

          child: Text(
            value ?? "",
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF363840)),
          ),
        ),
      ],
    );
  }
}
