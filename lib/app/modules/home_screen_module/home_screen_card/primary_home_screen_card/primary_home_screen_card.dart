import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/clp_disabled_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/block_home_page_card_widget.dart';

import '../../../../common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import 'primary_home_screen_card_logic.dart';

///This class is the card that will be rendered from carousel slider
///Each card needs a appform which we get from multilpc magnus api response
///Now here, with the appformid we call homepage which returns us the card that
///has to be rendered.

class PrimaryHomeScreenCard extends StatefulWidget {
  final LpcCard lpcCard;
  final bool initiallyExpanded;
  final bool expandable;

  const PrimaryHomeScreenCard({
    Key? key,
    required this.lpcCard,
    this.initiallyExpanded = false,
    this.expandable = true,
  }) : super(key: key);

  @override
  State<PrimaryHomeScreenCard> createState() => _PrimaryHomeScreenCardState();
}

class _PrimaryHomeScreenCardState extends State<PrimaryHomeScreenCard>
    with AfterLayoutMixin {
  PrimaryHomeScreenCardLogic get logic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: widget.lpcCard.appFormId);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrimaryHomeScreenCardLogic>(
      tag: widget.lpcCard.appFormId,
      builder: (logic) {
        switch (logic.homeScreenCardState) {
          case HomeScreenCardState.success:
            return logic.homeScreenModel.homeScreenTypeWidget;
          case HomeScreenCardState.loading:
            return _homeScreenLoading();
          case HomeScreenCardState.error:
          case HomeScreenCardState.iosBeta:
            return _homePageErrorScreen();
          case HomeScreenCardState.accountDeleted:
            return BlockHomeScreenCardWidget(
              title: logic.lpcCard.title,
              message: logic.lpcCard.text,
              lpcCard: widget.lpcCard,
              showRefreshButton: false,
            );
          case HomeScreenCardState.clpDisabled:
            return SizedBox();
            // return const CLPDisabledCard();
        }
      },
    );
  }

  Widget _homePageErrorScreen() {
    return BlockHomeScreenCardWidget(
      title: "",
      message: logic.message,
      lpcCard: widget.lpcCard,
      showRefreshButton:
          logic.homeScreenCardState != HomeScreenCardState.iosBeta,
    );
  }

  Widget _homeScreenLoading() {
    return const SkeletonLoadingWidget(
      skeletonLoadingType: SkeletonLoadingType.primaryHomeScreenCard,
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    logic.onAfterFirstLayout(
      lpcCard: widget.lpcCard,
      initiallyExpanded: widget.initiallyExpanded,
      expandable: widget.expandable,
      context: context,
    );
  }
}
