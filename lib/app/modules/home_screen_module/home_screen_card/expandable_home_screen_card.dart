import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/widgets/card_badge.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/res.dart';

import 'primary_home_screen_card/primary_home_screen_card_logic.dart';

class ExpandableHomeScreenCard extends StatefulWidget {
  const ExpandableHomeScreenCard({
    Key? key,
    required this.lpcCard,
    required this.children,
    this.padding,
    this.cardBadgeType = CardBadgeType.active,
    this.outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      borderSide: BorderSide(color: darkBlueColor, width: 1),
    ),
  }) : super(key: key);

  final LpcCard lpcCard;

  final List<Widget> children;

  final EdgeInsets? padding;
  final CardBadgeType cardBadgeType;
  final OutlineInputBorder? outlineInputBorder;

  @override
  State<ExpandableHomeScreenCard> createState() =>
      _ExpandableHomeScreenCardState();
}

class _ExpandableHomeScreenCardState extends State<ExpandableHomeScreenCard> {
  PrimaryHomeScreenCardLogic get logic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: widget.lpcCard.appFormId);

  @override
  void initState() {
    super.initState();
    logic.cardBadgeType = widget.cardBadgeType;
  }

  @override
  Widget build(BuildContext context) {
    logic.isExpanded = logic.initiallyExpanded;
    return GetBuilder<PrimaryHomeScreenCardLogic>(
        id: logic.EXPANSION_CARD_ID,
        tag: widget.lpcCard.appFormId,
        builder: (logic) {
          return Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: Container(
              width: 312.w,
              alignment: Alignment.topCenter,
              child: ExpansionTile(
                title: _titleWidget(),
                dense: true,
                tilePadding: EdgeInsets.symmetric(horizontal: 20.h),
                shape: widget.outlineInputBorder,
                onExpansionChanged: (value) {
                  logic.onExpansionCardChanged(value, widget.cardBadgeType);
                },
                trailing: _computeExpandedIcon(),
                enabled: logic.expandable,
                childrenPadding: widget.padding ??
                    EdgeInsets.only(
                      left: 20.w,
                      bottom: 20.h,
                      right: 20.w,
                    ),
                collapsedShape: widget.outlineInputBorder,
                initiallyExpanded: logic.initiallyExpanded,
                children: widget.children,
              ),
            ),
          );
        });
  }

  Widget _computeExpandedIcon() {
    return logic.expandable
        ? SvgPicture.asset(
            logic.isExpanded ? Res.collapseArrow : Res.expandArrow,
            height: 20.h,
            width: 20.h,
          )
        : const SizedBox();
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.lpcCard.loanProductName,
            style: AppTextStyles.bodyMMedium(color: blue1600),
          ),
          SizedBox(
            width: 8.w,
          ),
          GetBuilder<PrimaryHomeScreenCardLogic>(
              id: logic.cardBadgeId,
              tag: widget.lpcCard.appFormId,
              builder: (logic) {
                return CardBadge(
                  cardBadgeType: logic.cardBadgeType,
                );
              })
        ],
      ),
    );
  }
}
