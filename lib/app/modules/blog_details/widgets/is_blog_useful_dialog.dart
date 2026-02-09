import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';

class IsBlogUseFulDialog extends StatelessWidget {
  const IsBlogUseFulDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(16),
        decoration: _dialogDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _closeButton(),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Was this blog helpful?",
              style: TextStyle(
                  color: darkBlueColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 12,
            ),
            _likeAndDislike()
          ],
        ),
      ),
    );
  }

  BoxDecoration _dialogDecoration() {
    return const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)));
  }

  Row _likeAndDislike() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap: _onDislikeTapped,
            child: SvgPicture.asset(Res.roundedDisLikeIcon)),
        const SizedBox(
          width: 16,
        ),
        InkWell(
            onTap: _onLikeTapped, child: SvgPicture.asset(Res.roundedLikeIcon))
      ],
    );
  }

  void _onLikeTapped() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.blogUseful);
    Get.back();
  }

  void _onDislikeTapped() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.blogNotUseful);
    Get.back();
  }

  Align _closeButton() {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.clear_rounded,
          color: darkBlueColor,
        ),
      ),
    );
  }
}
