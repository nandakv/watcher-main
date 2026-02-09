import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/home_page_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/home_page_right_arrow_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';

class OfferExpiryAlert extends StatelessWidget {
  OfferExpiryAlert({Key? key, required this.lpcCard}) : super(key: key);

  final LpcCard lpcCard;

  get logic => Get.find<PrimaryHomeScreenCardLogic>(tag: lpcCard.appFormId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFe6f7fd),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _lpcTitle(),
                verticalSpacer(8),
                _infoTextWidget(),
                verticalSpacer(37),
                _ctaButton()
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(Res.offerExpiryAlert))
        ],
      ),
    );
  }

  Widget _lpcTitle() {
    return Text(
      lpcCard.loanProductName,
      style: const TextStyle(
          color: darkBlueColor, fontWeight: FontWeight.w600, fontSize: 12),
    );
  }

  Widget _ctaButton() {
    return HomePageButton(
      onPressed: (){},
      title: 'Withdraw now',
      foregroundColor: Colors.white,
      backgroundColor: navyBlueColor,
    );
  }

  Widget _infoTextWidget() {
    return const Text(
      "Your offer is about to expire, \ntake action now!",
      style: TextStyle(
        fontSize: 10,
        height: 1.4,
        color: primaryDarkColor,
      ),
    );
  }
}
