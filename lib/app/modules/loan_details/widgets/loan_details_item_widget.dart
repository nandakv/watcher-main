import 'package:flutter/material.dart';

class LoanDetailsItemWidget extends StatelessWidget {
  final Widget firstItem;
  final Widget secondItem;
  final double itemSpace;

  const LoanDetailsItemWidget(
      {Key? key,
      required this.firstItem,
      required this.secondItem,
      this.itemSpace = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: firstItem,
        ),
        SizedBox(
          width: itemSpace,
        ),
        Flexible(
          flex: 1,
          child: secondItem,
        ),
      ],
    );
  }
}
