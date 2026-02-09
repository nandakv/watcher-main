import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
// import 'package:privo/app/utils/screen_size_extension.dart';
import '../../../../components/button.dart';
import '../../../common_widgets/home_page_button.dart';
import '../../../models/home_screen_model.dart';
import '../home_screen_card/home_screen_card.dart';

class BlockHomeScreenCardWidget extends StatefulWidget {
  const BlockHomeScreenCardWidget({
    Key? key,
    this.title = "",
    required this.message,
    required this.lpcCard,
    this.showRefreshButton = true,
    this.bgColor,
  }) : super(key: key);

  final String title;
  final String message;
  final LpcCard lpcCard;
  final bool showRefreshButton;
  final Color? bgColor;

  @override
  State<BlockHomeScreenCardWidget> createState() =>
      _BlockHomeScreenCardWidgetState();
}

class _BlockHomeScreenCardWidgetState extends State<BlockHomeScreenCardWidget>
    with AfterLayoutMixin {
  final logic = Get.find<HomeScreenLogic>();

  PrimaryHomeScreenCardLogic get primaryHomePageCardLogic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: widget.lpcCard.appFormId);

  @override
  Widget build(BuildContext context) {
    return _primaryHomePageBlockCard();
  }

  Widget _primaryHomePageBlockCard() {
    return Container(
      width: 312.w,
      decoration: BoxDecoration(
        color: widget.bgColor,
        border: Border.all(color: blue1200),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title.isEmpty
                    ? widget.lpcCard.loanProductName
                    : widget.title,
                style: AppTextStyles.bodySSemiBold(color: blue1200),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                widget.message,
                style: AppTextStyles.bodyXSMedium(color: grey700),
              ),
              if (widget.showRefreshButton) ...[
                const SizedBox(
                  height: 16,
                ),
                Button(
                  buttonType: ButtonType.primary,
                  buttonSize: ButtonSize.small,
                  onPressed: () {
                    primaryHomePageCardLogic.fetchHomePageCardFromAppForm();
                  },
                  title: "Refresh",
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.toggleHomePageTitle("");
  }
}
