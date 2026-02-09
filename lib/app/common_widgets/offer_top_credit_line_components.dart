import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

class OfferTopCreditLineComponents extends StatelessWidget {
  final String processingFee;
  final String interest;
  final String oldInterest;
  final String tenure;

  const OfferTopCreditLineComponents(
      {Key? key,
      required this.interest,
      this.oldInterest = "",
      required this.processingFee,
      required this.tenure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 25),
      decoration: BoxDecoration(
        color: const Color(0xff161742).withOpacity(.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 6,
                child: offerComponent(title: 'Processing Fee', value: processingFee)),
            const VerticalDivider(
              color: Color(0xffFFF3EB),
              thickness: 0.4,
            ),
            Expanded(
              flex: 6,
              child: offerComponent(
                title: 'Rate Of Interest',
                value: interest,
                oldValue: oldInterest,
              ),
            ),
            const VerticalDivider(
              color: Color(0xffFFF3EB),
              thickness: 0.4,
            ),
            Expanded(
                flex:7,
                child: offerComponent(title: 'Tenure', value: tenure)),
          ],
        ),
      ),
    );
  }

  Widget offerComponent({
    required String title,
    required String value,
    String oldValue = "",
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xffFFF3EB),
                fontWeight: FontWeight.w400,
                fontSize: 8,
                fontFamily: 'Figtree'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xffFFF3EB),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontFamily: 'Figtree'),
            ),
            if (oldValue.isNotEmpty)
              Text(
                " $oldValue%",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: offWhiteColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
