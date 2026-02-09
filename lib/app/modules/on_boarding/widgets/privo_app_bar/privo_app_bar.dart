import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/model/privo_app_bar_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/app_bar_bottom_divider.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/utils/multi_lpc_faq.dart';

import '../../../../../res.dart';

class PrivoAppBar extends StatelessWidget {
  const PrivoAppBar({
    Key? key,
    required this.model,
    this.loanProductCode = LoanProductCode.clp,
    this.showFAQ = false,
    this.lpcCard,
  }) : super(key: key);

  final PrivoAppBarModel model;
  final bool showFAQ;
  final LoanProductCode loanProductCode;
  final LpcCard? lpcCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.isAppBarVisible) ...[
            _buildAppBarWidget(),
            const AppBarBottomDivider(),
          ]

          // if (model.title.isNotEmpty && model.subTitle.isNotEmpty)
          //   const SizedBox(
          //     height: 30,
          //   ),
          // model.isTitleVisible ? _buildTitleWidget() : const SizedBox(),

          ///Uncomment when we implement timeline bar
          // Container(
          //   width: Get.width,
          //   height: 6,
          //   decoration: BoxDecoration(
          //     color: Colors.green[300],
          //     borderRadius: BorderRadius.circular(50),
          //   ),
          // ),

          // Stack(
          //   children: [
          //     Container(
          //       width: Get.width,
          //       height: 6,
          //       decoration: BoxDecoration(
          //           color: const Color(0xffEFFDF1),
          //           borderRadius: BorderRadius.circular(50)),
          //     ),
          //     AnimatedContainer(
          //       duration: const Duration(milliseconds: 500),
          //       width: Get.width * model.progress,
          //       height: 6,
          //       decoration: BoxDecoration(
          //           color: const Color(0xff8BDB97),
          //           borderRadius: BorderRadius.circular(50)),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildAppBarWidget() {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.only(left: 32, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            _getAppBarTitle(),
            style: GoogleFonts.poppins(
                color: appBarTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          if (showFAQ) _helpButton(),
          _closeButton(),
        ],
      ),
    );
  }

  Widget _helpButton() {
    return InkWell(
      onTap: () {
        MultiLPCFaq(
          lpcCard: lpcCard,
        ).openMultiLPCBottomSheet(
          onPressContinue: () {},
        );
      },
      child: SvgPicture.asset(Res.helpAppBar),
    );
  }

  Widget _closeButton() {
    return SizedBox(
      width: 35,
      child: IconButton(
        onPressed: () {
          if (model.onClosePressed != null) {
            model.onClosePressed!();
          } else {
            Get.back();
          }
        },
        icon: const Icon(
          Icons.clear_rounded,
          color: appBarTitleColor,
        ),
      ),
    );
  }

  Padding _buildTitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.subTitle,
            style: const TextStyle(
                color: darkBlueColor,
                fontSize: 10,
                letterSpacing: 0.16,
                fontWeight: FontWeight.w600),
          ),
          Text(
            model.title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.14,
                color: darkBlueColor),
          ),
          const SizedBox(
            height: 21,
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    if (model.appBarText.isNotEmpty) return model.appBarText;
    Map<LoanProductCode, String> loanProductMapData = {
      LoanProductCode.sbd: "Setup Business Loan",
      LoanProductCode.sbl: "Setup Business Loan",
      LoanProductCode.upl: "Setup Personal Loan",
      LoanProductCode.clp: "Setup Credit Line",
    };
    return loanProductMapData[loanProductCode] ?? "Setup Credit Line";
  }
}
