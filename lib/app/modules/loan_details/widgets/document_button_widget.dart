import 'package:flutter/material.dart';

class DocumentButtonWidget extends StatelessWidget {
  const DocumentButtonWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF404040).withOpacity(1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: Text(
            title,
            style: _subTitleTextStyle(
                color: const Color(0xFF404040), fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  TextStyle _subTitleTextStyle(
      {FontWeight fontWeight = FontWeight.w600,
      Color color = const Color(0xFFFFF3EB)}) {
    return TextStyle(
        fontSize: 12,
        letterSpacing: 0.18,
        fontWeight: fontWeight,
        fontFamily: 'Figtree',
        color: color);
  }
}
