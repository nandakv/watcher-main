import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_widget/benefits_list.dart';
import 'package:privo/app/modules/home_screen_module/widgets/benefits_widget.dart';

import 'home_page_bottom_widget.dart';
import 'home_screen_app_bar.dart';

class HomeScreenSuccessWidget extends StatelessWidget {
  final Widget homePageWidget;
  final bool showAppbar;

  HomeScreenSuccessWidget({
    Key? key,
    required this.homePageWidget,
    this.showAppbar = true,
  }) : super(key: key);

  final logic = Get.find<HomeScreenLogic>();

  Widget _getHomePageWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          homePageWidget,
          HomePageBottomWidget(),
          const SizedBox(
            height: kToolbarHeight + 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (showAppbar) ? HomeScreenAppBar() : verticalSpacer(55),
              Expanded(
                child: _getHomePageWidget(),
              ),
            ],
          ),
          _bottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return GetBuilder<HomeScreenLogic>(
      id: logic.BOTTOM_BAR_KEY,
      builder: (logic) {
        return logic.bottomNavVisibility ? _bnvWidget(logic) : const SizedBox();
      },
    );
  }

  Positioned _bnvWidget(HomeScreenLogic logic) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          child: Container(
            decoration: _bottomNavigationBarDecoration(),
            child: Row(
              children: [
                _bnvIcon(
                  icon: Res.homePageBNVHomeIconSVG,
                  onPressed: () {},
                  title: "Home",
                  isActive: true,
                ),
                _bnvIcon(
                  icon: Res.homePageBNVLoanIconSVG,
                  onPressed: () => logic.goToServicingScreen(0),
                  title: "All Loans",
                  isActive: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _bottomNavigationBarDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(
          color: Color(0xFFE6E7EB),
          width: 1,
        ),
      ),
    );
  }

  Expanded _bnvIcon({
    required String title,
    required String icon,
    required Function onPressed,
    required bool isActive,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onPressed(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(icon),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: isActive ? darkBlueColor : secondaryDarkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
