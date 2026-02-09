import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/home_screen_module/widgets/offer_zone_section/offer_zone_card.dart';

import '../../../../common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import '../../../../models/home_screen_model.dart';
import '../../home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import '../../home_screen_logic.dart';
import '../block_home_page_card_widget.dart';

class OfferZoneCardStateComputationWidget extends StatefulWidget {
  const OfferZoneCardStateComputationWidget({
    super.key,
    required this.lpcCard,
    this.insideList = false,
  });

  final LpcCard lpcCard;
  final bool insideList;

  @override
  State<OfferZoneCardStateComputationWidget> createState() =>
      _OfferZoneCardStateComputationWidgetState();
}

class _OfferZoneCardStateComputationWidgetState
    extends State<OfferZoneCardStateComputationWidget> with AfterLayoutMixin {
  PrimaryHomeScreenCardLogic get logic => Get.find<PrimaryHomeScreenCardLogic>(
        tag: _getLogicTag(),
      );

  String _getLogicTag() {
    return widget.lpcCard.lpcCardType == LPCCardType.lowngrow
        ? "${widget.lpcCard.appFormId}_low_grow"
        : widget.lpcCard.appFormId;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrimaryHomeScreenCardLogic>(
      tag: _getLogicTag(),
      builder: (logic) {
        return _computeCardState();
      },
    );
  }

  Widget _computeCardState() {
    switch (logic.homeScreenCardState) {
      case HomeScreenCardState.loading:
        return const SkeletonLoadingWidget(
          skeletonLoadingType: SkeletonLoadingType.primaryHomeScreenCard,
        );
      case HomeScreenCardState.iosBeta:
      case HomeScreenCardState.accountDeleted:
      case HomeScreenCardState.clpDisabled:
      case HomeScreenCardState.success:
        return logic.homeScreenModel.homeScreenTypeWidget;
      case HomeScreenCardState.error:
        return BlockHomeScreenCardWidget(
          title: "",
          bgColor: Colors.white,
          message: logic.message,
          lpcCard: widget.lpcCard,
        );
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout(
      lpcCard: widget.lpcCard,
      initiallyExpanded: true,
      expandable: false,
      context: context,
    );
  }
}
