import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../res.dart';

class GoldenBadge extends StatelessWidget {
  final String title;
  final EdgeInsets margin;

  const GoldenBadge({Key? key, required this.title,this.margin = const EdgeInsets.only(top: 10)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFAF8E2F).withOpacity(1),
          borderRadius: BorderRadius.circular(20)),
      margin: margin,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Res.starUpgrade,
              height: 11,
              width: 10,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(title, style: _titleTextStyle),
          ],
        ),
      ),
    );
  }

  TextStyle get _titleTextStyle {
    return const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        fontFamily: 'Figtree',
        height: 14/10,
        color: Color(0xFFFFF3EB));
  }
}
