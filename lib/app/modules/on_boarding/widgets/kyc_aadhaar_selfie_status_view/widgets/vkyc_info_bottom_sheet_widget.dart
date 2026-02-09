import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class VKYCInfoBottomSheetWidget extends StatelessWidget {
  VKYCInfoBottomSheetWidget({Key? key}) : super(key: key);

  final Map<String, String> _infoMap = {
    Res.vkyc_wifi_svg: 'Stable Internet Connection',
    Res.vkyc_pan_svg: 'Keep your original PAN card accessible',
    Res.vkyc_bulb_svg: 'Good lighting and a quiet environment',
    Res.vkyc_access_svg: 'Grant access to Camera and Microphone'
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: SvgPicture.asset(Res.close_x_mark_svg),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Video-KYC Verification',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: darkBlueColor),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  'For a seamless verification process, please ensure:',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: statementOfAccountDateColor,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 24,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _infoMap.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _tile(
                      image: _infoMap.keys.toList()[index],
                      text: _infoMap.values.toList()[index],
                    );
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                GradientButton(
                  onPressed: () => Get.back(result: true),
                  title: 'Connect with Agent',
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({required String image, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            image,
            colorFilter: ColorFilter.mode(
                darkBlueColor.withOpacity(0.7), BlendMode.srcIn),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: navyBlueColor,
            ),
          ),
        ),
      ],
    );
  }
}
