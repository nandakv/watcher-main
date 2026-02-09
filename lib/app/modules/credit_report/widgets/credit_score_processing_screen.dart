import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import '../../../common_widgets/polling_title_widget.dart';
import '../../polling/gradient_circular_progress_indicator.dart';
import '../credit_report_helper_mixin.dart';

class CreditScoreProcessingScreen extends StatelessWidget {
  CreditScoreProcessingScreen({
    Key? key,
    this.bodyText = "",
    required this.title,
    this.assetImagePath,
    this.progressIndicatorText = "",
    this.bodyTextStyle = const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.08,
        color: Color(0xff1D478E),
        fontFamily: 'Figtree'),
    this.replaceProgressWidget,
    this.creditScore,
    this.creditScoreData,
    required this.onBackPress,
  }) : super(key: key);

  final String? creditScore;
  final String? assetImagePath;
  final String title;
  final String bodyText;
  final TextStyle bodyTextStyle;
  final String progressIndicatorText;
  final Widget? replaceProgressWidget;
  final CreditScoreScale? creditScoreData;
  final Function() onBackPress;

  Size? screenSize;

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: PollingTitleWidget(title: title),
    );
  }

  Widget _bodyWidget() {
    return Text(
      bodyText,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xff1D478E),
      ),
    );
  }

  Widget _imageWidget() {
    return SizedBox(
      height: screenSize!.height * 0.55,
      child: Stack(
        children: [
          Center(child: SvgPicture.asset(assetImagePath!)),
          if (creditScore != null && creditScoreData != null)
            Container(
              height: screenSize!.height * 0.55 * 0.45,
              padding: EdgeInsets.only(right: screenSize!.width * 0.1),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      creditScoreData!.title,
                      style: TextStyle(
                        color: creditScoreData!.color,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        height: 28 / 20,
                      ),
                    ),
                    Text(
                      creditScore!,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: creditScoreData!.color,
                        fontSize: 40,
                        height: 56 / 40,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return const Hero(
      tag: 'circle',
      child: RotationTransitionWidget(
        loadingState: LoadingState.bottomLoader,
      ),
    );
  }

  Widget _closeButton() {
    return IconButton(
      onPressed: onBackPress,
      icon: const Icon(
        Icons.clear_rounded,
        color: appBarTitleColor,
      ),
    );
  }

  Widget _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _closeButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize ??= Get.size;
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _appBar(),
          const Spacer(),
          _titleWidget(),
          verticalSpacer(10),
          _bodyWidget(),
          const Spacer(),
          _imageWidget(),
          const Spacer(flex: 2),
          if (replaceProgressWidget != null)
            replaceProgressWidget!
          else ...[
            _loadingWidget(),
            if (progressIndicatorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    progressIndicatorText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: darkBlueColor,
                      fontSize: 12,
                      height: 17 / 12,
                    ),
                  ),
                ),
              ),
          ],
          const VerticalSpacer(16),
          const PoweredByWidget(
            logo: Res.experianLogo,
          ),
          const VerticalSpacer(36),
        ],
      ),
    );
  }
}
