import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_screen_maps.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/multi_lpc_faq.dart';
import 'package:privo/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/skeletons/skeletons.dart';

import 'withdrawal_screen_logic.dart';

class WithdrawalScreenPage extends StatefulWidget {
  const WithdrawalScreenPage({Key? key}) : super(key: key);

  @override
  State<WithdrawalScreenPage> createState() => _WithdrawalScreenPageState();
}

class _WithdrawalScreenPageState extends State<WithdrawalScreenPage> {
  final logic = Get.find<WithdrawalScreenLogic>();

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarBrightness: Brightness.light,
  //     statusBarIconBrightness: Brightness.light,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onWillPopScope,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              GetBuilder<WithdrawalScreenLogic>(
                builder: (logic) {
                  return _computeAppBarVisibility(logic)
                      ? const SizedBox()
                      : _appBarWidget();
                },
              ),
              Expanded(
                child: _computeWithdrawalScreen(logic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _computeAppBarVisibility(WithdrawalScreenLogic logic) {
    return logic.currentWithdrawalScreen == WithdrawalScreen.polling ||
        logic.currentWithdrawalScreen == WithdrawalScreen.success;
  }

  Widget _computeWithdrawalScreen(WithdrawalScreenLogic logic) {
    return GetBuilder<WithdrawalScreenLogic>(builder: (logic) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        layoutBuilder: (currentChild, previousChildren) {
          return currentChild!;
        },
        transitionBuilder: (child, animation) {
          return _transitionWidget(animation, child);
        },
        child: getWithdrawalScreen[logic.currentWithdrawalScreen],
      );
    });
  }

  SlideTransition _transitionWidget(Animation<double> animation, Widget child) {
    return SlideTransition(
      position:
          Tween<Offset>(begin: const Offset(1.2, 0), end: const Offset(0, 0))
              .animate(animation),
      child: child,
    );
  }

  Material _appBarWidget() {
    return Material(
      elevation: 0.6,
      color: Colors.white,
      shadowColor: const Color(0xFFE2E2E2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Withdraw",
              style: GoogleFonts.poppins(
                  color: appBarTitleColor,
                  fontSize: 14,
                  letterSpacing: 0.14,
                  fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            _helpButton(),
            SizedBox(
              width: 28,
              child: IconButton(
                  onPressed: logic.onClosePressed,
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: appBarTitleColor,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _helpButton() {
    return InkWell(
      onTap: () {
        MultiLPCFaq(lpcCard: LPCService.instance.activeCard)
            .openMultiLPCBottomSheet(
          onPressContinue: () {},
        );
      },
      child: SvgPicture.asset(Res.helpAppBar),
    );
  }

  Widget _skeletonView() => SkeletonItem(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                      lines: 3,
                      spacing: 6,
                      lineStyle: SkeletonLineStyle(
                        randomLength: true,
                        height: 10,
                        borderRadius: BorderRadius.circular(8),
                        minLength: Get.width / 6,
                        maxLength: Get.width / 3,
                      )),
                ),
              ),
              const Expanded(
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.circle, width: 50, height: 50),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          SkeletonLine(
            style: SkeletonLineStyle(
                height: 16,
                width: Get.width,
                borderRadius: BorderRadius.circular(8)),
          )
        ],
      ));
}
