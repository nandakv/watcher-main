import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';

class KnowMoreTopWidget extends StatelessWidget {
  final String illustration;
  final String? background;
  final String title;
  final String message;

  const KnowMoreTopWidget(
      {super.key,
      required this.illustration,
      required this.title,
      this.background,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: skyBlueColor.withOpacity(0.1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Stack(
        children: [
          if (background != null)
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: SvgPicture.asset(background!),
            ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _titleWidget(),
                const VerticalSpacer(12),
                _messageText(),
                if (illustration != null) _illustrationWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _illustrationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: SvgPicture.asset(illustration!),
    );
  }

  Widget _messageText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.6,
          color: secondaryDarkColor,
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: navyBlueColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }
}
