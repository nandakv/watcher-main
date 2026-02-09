import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../common_widgets/polling_title_widget.dart';
import '../../../../polling/gradient_circular_progress_indicator.dart';

class KYCTransitionWidget extends StatelessWidget {
  final String title;
  final String message;
  final String imagePath;
  final String bottomText;

  const KYCTransitionWidget(
      {Key? key,
      required this.title,
      required this.message,
      required this.bottomText,
      required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          _titleWidget(),
          verticalSpacer(16),
          _messageWidget(),
          const Spacer(),
          SvgPicture.asset(imagePath),
          const Spacer(flex: 5),
          const RotationTransitionWidget(
            loadingState: LoadingState.bottomLoader,
          ),
          verticalSpacer(16),
          _bottomInfoWidget(),
          verticalSpacer(20),
        ],
      ),
    );
  }

  Padding _titleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: PollingTitleWidget(title: title),
    );
  }

  Text _bottomInfoWidget() {
    return Text(
      bottomText,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 11,
        color: darkBlueColor,
      ),
    );
  }

  Padding _messageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 41.0),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 12,
          height: 1.6,
          color: darkBlueColor,
        ),
      ),
    );
  }
}
