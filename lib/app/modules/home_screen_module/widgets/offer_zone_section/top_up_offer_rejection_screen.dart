import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/multi_lpc_faq.dart';

import '../../../../../res.dart';
import '../../../../common_widgets/spacer_widgets.dart';
import '../../../../theme/app_colors.dart';

class TopUpOfferRejectionScreen extends StatelessWidget {
  const TopUpOfferRejectionScreen({super.key});

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () async {
              await MultiLPCFaq(lpcCard: LPCService.instance.activeCard)
                  .openMultiLPCBottomSheet(onPressContinue: () {});
            },
            child: SvgPicture.asset(Res.helpAppBar),
          ),
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(Res.close_mark_svg),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              _appBar(),
              const Spacer(),
              SvgPicture.asset(Res.topUpRejectionSVG),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _textBody(),
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }

  Column _textBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "We Are Sorry!",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: appBarTitleColor,
          ),
        ),
        const VerticalSpacer(16),
        const Text(
          "Based on our careful assessment, it seems you are not currently eligible for the top-up. We encourage you to reapply after some time",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: darkBlueColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
