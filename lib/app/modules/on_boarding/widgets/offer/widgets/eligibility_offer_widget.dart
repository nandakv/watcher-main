import 'package:flutter/material.dart';
import 'package:privo/res.dart';
import '../../../../home_screen_module/widgets/home_page_top_widget.dart';
import 'browser_home_bottom_widget.dart';

class EligibilityOfferScreenWidget extends StatelessWidget {
  final Widget topWidget;
  final bool showHamburger;
  final Widget? ctaButtonWidget;
  final String bottomTitleText;
  final String bottomSubtitleText;

  final GlobalKey<ScaffoldState>? scaffoldKey;
  const EligibilityOfferScreenWidget(
      {Key? key,
      required this.topWidget,
      this.scaffoldKey,
      this.ctaButtonWidget,
      this.showHamburger = true,
      required this.bottomTitleText,
      required this.bottomSubtitleText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          HomeScreenTopWidget(
            showHamburger: showHamburger,
            scaffoldKey: scaffoldKey,
            infoText: "",
            widget: topWidget,
            background: Res.confetti,
          ),
          Expanded(child: Center(child: _bottomWidget()))
        ],
      ),
    );
  }

  Widget _bottomWidget() {
    return BrowserToAppBottomWidget(
      ctaButtonWidget: ctaButtonWidget,
      bottomSubtitleText: bottomSubtitleText,
      bottomTitleText: bottomTitleText,
    );
  }
}
