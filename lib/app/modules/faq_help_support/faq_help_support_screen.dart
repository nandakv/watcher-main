import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/contact_us/contact_us_widget.dart';
import 'package:privo/app/modules/faq_help_support/faq_help_support_logic.dart';
import 'package:privo/app/modules/faq_help_support/widgets/delete_request_widget.dart';
import 'package:privo/app/modules/help_support/widget/faq_tile.dart';

import '../../../res.dart';
import '../../common_widgets/raise_an_issue/raise_an_issue_widget.dart';
import '../../common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import '../../common_widgets/vertical_spacer.dart';
import '../../theme/app_colors.dart';
import '../help_support/widget/faq_category_tile.dart';
import '../help_support/widget/help_and_support_app_bar.dart';
import 'widgets/faq_details_widget.dart';

class FAQHelpSupportScreen extends StatelessWidget {
  FAQHelpSupportScreen({Key? key}) : super(key: key);

  final logic = Get.find<FAQHelpSupportLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onBackPressed,
      child: SafeArea(
        child: Scaffold(
          body: GetBuilder<FAQHelpSupportLogic>(builder: (logic) {
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                _computeBackground(),
                Column(
                  children: [
                    HelpAndSupportAppBar(
                      title: logic.computeAppBarTitle(),
                      subTitle: logic.computeAppBarSubTitle(),
                      onClosePressed: logic.onBackPressed,
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 24, top: 32, right: 24),
                        child: _computeBody(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _computeBody() {
    switch (logic.helpAndSupportPageState) {
      case HelpAndSupportPageState.loading:
        return const SkeletonLoadingWidget(
          skeletonLoadingType: SkeletonLoadingType.faq,
        );
      case HelpAndSupportPageState.category:
        return _categoryPage();
      case HelpAndSupportPageState.subCategory:
        return _subCategoryPage();
      case HelpAndSupportPageState.faqList:
        return _faqListPage();
      case HelpAndSupportPageState.faqDetails:
        return FaqDetailsWidget(
          allowRequestForDeletion: logic.computeAllowRequestForDeletion(),
          question: logic.selectedFaqQuery!.question,
          onTap: logic.onRequestForDeletionClicked,
          answer: logic.selectedFaqQuery!.answer,
        );
      case HelpAndSupportPageState.deleteRequest:
        return DeleteRequestWidget();
    }
  }

  Widget _titleWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: darkBlueColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _computeBackground() {
    switch (logic.helpAndSupportPageState) {
      case HelpAndSupportPageState.faqList:
        return SvgPicture.asset(Res.faqBgCircle1);
      case HelpAndSupportPageState.faqDetails:
        return Stack(
          children: [
            Positioned(
                left: 0,
                top: 200,
                child: SvgPicture.asset(Res.faqDetailsLeftBg)),
            Positioned(
                right: 0,
                bottom: 30,
                child: SvgPicture.asset(Res.faqDetailsRightBg)),
          ],
        );
      default:
        return SizedBox();
    }
  }

  Widget _categoryPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget("Select a category for help"),
        verticalSpacer(12),
        Expanded(
          child: ListView.builder(
              itemCount: logic.faqs.categories.length,
              itemBuilder: (context, index) {
                return FAQCategoryTile(
                  title: logic.faqs.categories[index].categoryTitle,
                  subTitle: logic.faqs.categories[index].categorySubTitle,
                  onTap: () =>
                      logic.onFaqCategoryTapped(logic.faqs.categories[index]),
                );
              }),
        ),
        _raiseIssueWidget(),
        ContactUsWidget(
            title: "Need more help?", subTitle: "Contact Customer Support"),
      ],
    );
  }

  Widget _raiseIssueWidget() {
    return GetBuilder<FAQHelpSupportLogic>(
        id: logic.RAISE_AN_ISSUE_ID,
        builder: (logic) {
          if (logic.isReportIssueEnabled) {
            return RaiseAnIssueCard(
              onTap: logic.onRaiseIssueTapped,
            );
          }
          return const SizedBox();
        });
  }

  Widget _subCategoryPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleWidget("Select a sub category for help"),
        verticalSpacer(12),
        Expanded(
          child: ListView.builder(
              itemCount: logic.selectedFaqCategory!.subCategories.length,
              itemBuilder: (context, index) {
                return FAQCategoryTile(
                  title: logic.selectedFaqCategory!.subCategories[index]
                      .subCategoryTitle,
                  subTitle: logic.selectedFaqCategory!.subCategories[index]
                      .subCategorySubTitle,
                  onTap: () => logic.onFaqSubCategoryTapped(
                      logic.selectedFaqCategory!.subCategories[index]),
                );
              }),
        ),
      ],
    );
  }

  Widget _faqListPage() {
    return ListView.builder(
        itemCount: logic.currentQueries.length,
        itemBuilder: (context, index) {
          return FAQTile(
            question: logic.currentQueries[index].question,
            answer: logic.currentQueries[index].answer,
            isExpanded:
                logic.checkIfAccountDeletedTapped() ? false : index == 0,
            isRightArrow: logic.checkIfAccountDeletedTapped() && index == 0,
            onClicked: (isExpanded) => logic.onQueryCLicked(isExpanded, index),
          );
        });
  }
}
