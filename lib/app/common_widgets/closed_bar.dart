import 'package:flutter/cupertino.dart';

class ClosedBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF32B353).withOpacity(1),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          "Closed",
          style: _subTitleTextStyle(),
        ),
      ),
    );
  }

  TextStyle _subTitleTextStyle() {
    return const TextStyle(
        fontSize: 12,
        letterSpacing: 0.18,
        fontWeight: FontWeight.w500,
        fontFamily: 'Figtree',
        color: Color(0xFFFFF3EB));
  }
}
