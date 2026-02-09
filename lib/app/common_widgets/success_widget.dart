import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privo/app/theme/app_colors.dart';



class SuccessRejectWidget extends StatelessWidget {
  final String image;
  final String textMessage;
  final String subTitle;
  final String bottomLabel;
  final String bottomCTA;
  final String tryAgainCTA;

  const SuccessRejectWidget(
      {Key? key,
      required this.image,
      required this.textMessage,
      this.subTitle = "",
      this.bottomLabel = "",
      this.bottomCTA = "",
      this.tryAgainCTA = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return successRejectWidget(image, textMessage);
  }

  Widget successRejectWidget(String img, String message) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(img),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Text(
                  textMessage,
                  style: _messageTextStyle(const Color(0xff1D478E)),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Text(
                  subTitle,
                  style: _messageSubTitleTextStyle(const Color(0xff1D478E)),
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  tryAgainCTA,
                  style: _underlineTextStyle(skyBlueColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        bottomTextWidget()
      ],
    );
  }

  Widget bottomTextWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 90,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              bottomLabel,
              style: _messageTextStyle(const Color(0xff707070)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {},
              child: Text(
                bottomCTA,
                style: _underlineTextStyle(skyBlueColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _messageTextStyle(Color color) {
    return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.normal);
  }

  TextStyle _messageSubTitleTextStyle(Color color) {
    return TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.normal);
  }

  TextStyle _underlineTextStyle(Color color) {
    return TextStyle(
        decoration: TextDecoration.underline,
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.normal);
  }
}
