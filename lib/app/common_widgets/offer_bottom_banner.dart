import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/offer_banner_model.dart';
import 'package:privo/app/common_widgets/page_swipe_indicator.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';

class OfferBottomBanner extends StatelessWidget {
  OfferBottomBanner({Key? key}) : super(key: key);

  final logic = Get.find<OfferLogic>();

  @override
  Widget build(BuildContext context) {
    double bannerHeight = MediaQuery.of(context).size.height;
    double bannerWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          "Borrow. Spend. Repay. Reuse",
          style: GoogleFonts.poppins(
            color: const Color(0xff161742),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
              viewportFraction: .9,
              aspectRatio: bannerWidth / (bannerHeight * 0.12),
              onPageChanged: (i, r) {
                logic.onPageSwiped(i);
              },
              autoPlay: false,
              enableInfiniteScroll: false),
          items: getBannerWidgetList(),
        ),
        PageSwipeIndicator(currentIndex: logic.currentIndex.toDouble()),
      ],
    );
  }

  int computeFlexForSwiper(double bannerHeight) {
    return bannerHeight > 600 ? 4 : 7;
  }

  List<Widget> getBannerWidgetList() {
    return logic.offerBannerList.map((offerBannerItem) {
      return bannerWidget(
        offerBannerModel: offerBannerItem,
      );
    }).toList();
  }

  Container bannerWidget({
    required OfferBannerModel offerBannerModel,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffAF8E2F), width: 1),
      ),
      child: Row(
        children: [
          SvgPicture.asset(offerBannerModel.img,width: 42,height: 42,),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Text(
              offerBannerModel.title,
              style: _bannerTitleStyle(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _bannerTitleStyle() {
    return GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: const Color(0xff161742),
    );
  }
}
