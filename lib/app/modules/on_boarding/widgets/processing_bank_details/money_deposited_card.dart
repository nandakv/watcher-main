import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MoneyDepositedCard extends StatelessWidget {
  const MoneyDepositedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      child: Row(
        children:  [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: moneyCardCheckColor
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 6),
              child: Icon(Icons.check,color: Colors.white,),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
           Flexible(
            child: Text(
              "Account verification is successful!\n₹1 has been deposited to your account",
              textAlign: TextAlign.left,
              style: buildTextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
              fontSize: 12,
              letterSpacing: 0.11,
              fontStyle: FontStyle.normal,
              color: Color(0xFF344157)
            );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      color: moneyDepositedColor,
      borderRadius: BorderRadius.circular(8),
    );
  }
}
