import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/home_screen_model.dart';
import '../../../../res.dart';
import '../../feedback/feedback_logic.dart';
import '../home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import '../home_screen_logic.dart';
import '../widgets/info_message_widget.dart';
import '../widgets/share_experience_widget.dart';

class HomeScreenWidget extends StatelessWidget {
  final Widget homePageCard;
  final FeedbackType? feedbackType;
  final LpcCard lpcCard;

  HomeScreenWidget({
    Key? key,
    required this.lpcCard,
    required this.homePageCard,
    this.feedbackType,
  }) : super(key: key);

  PrimaryHomeScreenCardLogic get logic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: lpcCard.appFormId);
  final homeScreenLogic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        homePageCard,
        if (feedbackType != null)
          ShareExperienceWidget(
            onTap: () =>
                homeScreenLogic.onShareFeedbackClicked(feedbackType!, lpcCard),
          )
      ],
    );
  }

  Widget infoWidget() {
    return (logic.homeScreenModel.info.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: InfoMessageWidget(
              infoMessage: logic.homeScreenModel.info,
              infoIcon: Res.bulb_icon,
              bgColor: const Color(0xff183F77),
              borderRadius: 12,
            ),
          )
        : const SizedBox();
  }
}
