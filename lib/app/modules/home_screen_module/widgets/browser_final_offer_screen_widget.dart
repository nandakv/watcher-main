import 'package:flutter/material.dart';

import '../../../../res.dart';
import 'home_page_top_widget.dart';

class BrowserFinalOfferScreenWidget extends StatelessWidget {
  const BrowserFinalOfferScreenWidget(
      {Key? key,
      required this.topWidget,
      required this.showHamburger,
      this.ctaButtonWidget,
      this.scaffoldKey,
      required this.bottomWidget})
      : super(key: key);

  final Widget topWidget;
  final bool showHamburger;
  final Widget? ctaButtonWidget;
  final Widget? bottomWidget;

  final GlobalKey<ScaffoldState>? scaffoldKey;

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
          Expanded(child: Center(child: bottomWidget))
        ],
      ),
    );
  }
}
