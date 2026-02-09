import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/theme/app_colors.dart';

class CircleIconWidget extends StatelessWidget {
  CircleIconWidget({
    Key? key,
    required this.index,
     this.title,
    this.subTitle,
    required this.onTap,
    required this.currentIndex,
    required this.asset_path,
  }) : super(key: key);

  final int index;
  final String? subTitle;
  final Function onTap;
  final String? title;
  final int currentIndex;
  final String asset_path;




  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            height: 110,
            width:  110,
            child: SvgPicture.asset(
              currentIndex != index
                  ? asset_path
                  : asset_path,
              fit: BoxFit.scaleDown,
            ),
            decoration: animatedContainerBoxDecoration(),
          ),
          const SizedBox(
            height: 24,
          ),
          Column(
            children: [
              Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: titleTextStyle(),
              ),
              Text(
                subTitle ?? "",
                textAlign: TextAlign.center,
                style: subTitleTextStyle(),
              ),
            ],
          )
        ],
      ),
      ),
    );
  }

  TextStyle subTitleTextStyle() {
    return TextStyle(
      fontSize: 10,
      color: currentIndex == index ? personalLoanTextColor : const Color(0xff4A4B53),
      letterSpacing: 0.08,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle titleTextStyle() {
    return TextStyle(
      fontSize: 14,
      color: currentIndex == index ? personalLoanTextColor : const Color(0xff4A4B53),
      letterSpacing: 0.11,
      fontWeight: currentIndex != index
          ? FontWeight.normal
          : FontWeight.w600,
    );
  }

  BoxDecoration animatedContainerBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
            color: currentIndex == index
                ? personalLoanTextColor
                : employmentNonSelectedBorder,
            width: 1),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(2, 4))
        ]);
  }
}