import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/multi_lpc_faq.dart';
import '../../../res.dart';
import '../../common_widgets/animated_text_widget.dart';
import '../../common_widgets/app_lottie_widget.dart';
import '../../common_widgets/polling_title_widget.dart';
import 'gradient_circular_progress_indicator.dart';

class PollingScreen extends StatelessWidget {
  const PollingScreen({
    Key? key,
    required this.bodyTexts,
    required this.titleLines,
    this.showBottomInfoText = true,
    this.assetImagePath,
    this.isV2 = false,
    this.timerWidget,
    this.bodyTextPadding = 30,
    this.progressIndicatorText =
        "It usually takes less than a minute to complete",
    this.bodyTextStyle = const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.08,
        color: Color(0xff1D478E),
        fontFamily: 'Figtree'),
    this.widgetBelowIllustration,
    this.replaceProgressWidget,
    this.onClosePressed,
    this.stopPollingCallback,
    this.startPollingCallback,
    this.enableHelpIcon = true,
    this.enableTitleSpacer = true,
    this.isClosedEnable = true
  }) : super(key: key);

  final String? assetImagePath;
  final List<String> titleLines;
  final List<String> bodyTexts;
  final TextStyle bodyTextStyle;
  final Widget? timerWidget;
  final bool showBottomInfoText;
  final bool isV2;
  final String progressIndicatorText;
  final Widget? widgetBelowIllustration;
  final Widget? replaceProgressWidget;
  final Function()? onClosePressed;
  final Function()? stopPollingCallback;
  final Function()? startPollingCallback;
  final double bodyTextPadding;
  final bool enableHelpIcon;
  final bool enableTitleSpacer;
  final bool isClosedEnable;

  @override
  Widget build(BuildContext context) {
    if (!isV2) {
      return buildV1(context);
    }
    return buildV2(context);
  }

  Widget buildV2(BuildContext context) {
    return Column(
      children: [
        if (isClosedEnable) _pollingAppBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (enableTitleSpacer) const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: titleLines
                        .map((e) => PollingTitleWidget(title: e))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      timerWidget ??
                          AnimatedTextWidget(
                            bodyTexts: bodyTexts,
                            flex: 0,
                            horizontalPadding: bodyTextPadding,
                            textStyle: bodyTextStyle,
                          ),
                      const Spacer()
                    ],
                  ),
                ),
                assetImagePath?.endsWith(".json") ?? false
                    ? AppLottieWidget(
                  assetPath: assetImagePath!,
                  boxFit: BoxFit.contain,
                )
                    : SvgPicture.asset(assetImagePath!),
                const Spacer(),
                if (widgetBelowIllustration != null) ...[
                  widgetBelowIllustration!,
                  const Spacer(),
                ],
                if (replaceProgressWidget != null)
                  replaceProgressWidget!
                else ...[
                  const Hero(
                    tag: 'circle',
                    child: RotationTransitionWidget(
                      loadingState: LoadingState.bottomLoader,
                    ),
                  ),
                  if (showBottomInfoText)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          progressIndicatorText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: darkBlueColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pollingAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Spacer(),
          if (enableHelpIcon)
            InkWell(
              onTap: () async {
                stopPollingCallback?.call();
                await MultiLPCFaq(lpcCard: LPCService.instance.activeCard)
                    .openMultiLPCBottomSheet(onPressContinue: () {});
                startPollingCallback?.call();
              },
              child: SvgPicture.asset(Res.helpAppBar),
            ),
          SizedBox(
            width: 35,
            child: IconButton(
              onPressed: () {
                onClosePressed?.call();
              },
              icon: const Icon(
                Icons.clear_rounded,
                color: appBarTitleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildV1(BuildContext context) {
    return Column(
      children: [
        _pollingAppBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(
                  flex: 2,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      titleLines[0],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: const Color(0xff004097),
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                const RotationTransitionWidget(
                  loadingState: LoadingState.progressLoader,
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      AnimatedTextWidget(
                        bodyTexts: bodyTexts,
                        flex: 0,
                        horizontalPadding: bodyTextPadding,
                        textStyle: bodyTextStyle,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                // SvgPicture.asset(Res.progressBar),
                const Spacer(
                  flex: 2,
                ),
                if (showBottomInfoText)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      progressIndicatorText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xff888686),
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
