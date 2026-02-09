import 'package:lottie/lottie.dart';
import 'package:privo/app/common_widgets/app_lottie_widget.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/res.dart';

enum ResultPageState { success,processing }

enum ResultPageImageType { lottie, svg, generic }

class ResultPage extends StatelessWidget {
  const ResultPage(
      {Key? key,
      required this.title,
      required this.subTitle,
      this.assetImage = Res.Relax,
      required this.resultPageImageType,
      this.state = ResultPageState.success})
      : super(key: key);

  final String title;
  final String subTitle;
  final String assetImage;
  final ResultPageState state;
  final ResultPageImageType resultPageImageType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _bodyIllustration(),
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: Color(0xFF707070),
              strokeWidth: 1,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _titleTextWidget(),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _subTitleText(),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }

  Color _titleTextColor() {
    switch (state) {
      case ResultPageState.success:
        return greenTextColor;
      case ResultPageState.processing:
        return const Color(0xFF3B3B3E);
      default:
        return titleTextColor;
    }
  }

  Color _subTitleTextColor() {
    switch (state) {
      case ResultPageState.success:
        return greenTextColor;
      case ResultPageState.processing:
        return mainTextColor;
      default:
        return mainTextColor;
    }
  }

  Widget _titleTextWidget() {
    switch (state) {
      case ResultPageState.processing:
        return Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF344157),
              fontSize: 16,
              letterSpacing: 0.18),
        );
      default:
        return Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: _titleTextColor(), fontSize: 16, letterSpacing: 0.15),
        );
    }
  }

  Widget _subTitleText() {
    switch (state) {
      case ResultPageState.processing:
        return Text(
          subTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: _titleTextColor(), fontSize: 14, letterSpacing: 0.15),
        );
      default:
        return Text(
          subTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _subTitleTextColor(),
              fontSize: 24,
              letterSpacing: 0.18),
        );
    }
  }

  Widget _bodyIllustration() {
    switch (resultPageImageType) {
      case ResultPageImageType.lottie:
        return AppLottieWidget(assetPath: assetImage);
      case ResultPageImageType.svg:
        return SvgPicture.asset(assetImage);
      case ResultPageImageType.generic:
        return Image.asset(assetImage);
    }
  }
}
