import 'package:after_layout/after_layout.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/auth_loading_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/explore_more_card.dart';
import 'package:privo/app/modules/home_screen_module/widgets/financial_tools.dart';
import 'package:privo/app/modules/home_screen_module/widgets/home_page_flow_blocker_screen.dart';
import 'package:privo/app/modules/home_screen_module/widgets/offer_zone_section/offer_zone_section_widget.dart';
import 'package:privo/app/modules/home_screen_module/widgets/our_legacy.dart';
import 'package:privo/app/modules/navigation_drawer/navigation_drawer_view.dart';
import 'package:privo/app/modules/referral/widgets/referral_card.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

// import 'package:privo/app/utils/screen_size_extension.dart';

import '../../../res.dart';
import '../../common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import 'home_screen_card/primary_home_screen_card/primary_home_screen_card.dart';
import 'home_screen_logic.dart';
import 'widgets/home_screen_success_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin, WidgetsBindingObserver {
  var logic = Get.find<HomeScreenLogic>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      Get.log("Resumed home page cycle");
      logic.onReady();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => logic.onBackPressed(),
      child: Scaffold(
        key: logic.homePageScaffoldKey,
        drawer: const NavigationDrawerPage(
          rowIndex: 1,
          key: Key("home_screen"),
        ),
        backgroundColor: Colors.white,
        body: GetBuilder<HomeScreenLogic>(
          id: logic.HOME_SCREEN_ID,
          builder: (logic) {
            switch (logic.homeScreenState) {
              case HomeScreenPageState.userFlow:
              case HomeScreenPageState.polling:
                return _homeScreenSuccessWidget();
              case HomeScreenPageState.fetchingLocation:
                return _loadingForLocationFetching();
              case HomeScreenPageState.loggingOut:
                return const AuthLoadingWidget();
              case HomeScreenPageState.loading:
                return _homeScreenLoading();
              case HomeScreenPageState.iosBeta:
                return HomePageFlowBlockerScreen();
              case HomeScreenPageState.apiError:
                return const SizedBox();
              case HomeScreenPageState.maintenance:
                return HomePageFlowBlockerScreen();
            }
          },
        ),
      ),
    );
  }

  _loadingForLocationFetching() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _homeScreenLoading() {
    return HomeScreenSuccessWidget(
      showAppbar: false,
      homePageWidget: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SkeletonLoadingWidget(
          skeletonLoadingType: SkeletonLoadingType.primaryHomeScreenCard,
        ),
      ),
    );
  }

  Widget _getHomePageCards() {
    return logic.homeScreenState == HomeScreenPageState.iosBeta
        ? Container(
            color: Colors.red,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _alertUpdates(),
              ),
              _primaryCardSection(),
              VerticalSpacer(12.h),
              if (logic.multiLPCCardsModel.upgradeCards.isNotEmpty) ...[
                OfferZoneSectionWidget(
                  upgradeCards: logic.multiLPCCardsModel.upgradeCards,
                ),
                VerticalSpacer(40.h),
              ],
              _exploreMore(),
              FinancialTools(),
              VerticalSpacer(40.h),
              if (logic.multiLPCCardsModel.referralData != null &&
                  logic.multiLPCCardsModel.referralData!.enableReferral) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: ReferralCard(onTap: logic.onTapReferralCard,bodyText: "Invite them to check monthly credit score for free, apply for a business loan and track finances easily",),
                ),
                VerticalSpacer(40.h),
              ],
              OurLegacy(),
            ],
          );
  }

  Widget _primaryCardSection() {
    return GetBuilder<HomeScreenLogic>(
        id: logic.PRIMARY_CARDS_ID,
        builder: (logic) {
          if (!logic.showPrimaryCards) return const SizedBox();
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<HomeScreenLogic>(
                id: logic.HOME_PAGE_TITLE_ID,
                builder: (logic) {
                  return Padding(
                    padding: EdgeInsets.only(left: 24.w),
                    child: Text(
                      logic.homePageTitle,
                      style: AppTextStyles.headingXSMedium(color: blue1600),
                    ),
                  );
                },
              ),
              VerticalSpacer(12.h),
              _primaryCards(),
              VerticalSpacer(40.h),
            ],
          );
        });
  }

  Widget _alertUpdates() {
    return GetBuilder<HomeScreenLogic>(
        id: logic.ALERT_WIDGET,
        builder: (logic) {
          if (logic.showAlertWidget && logic.alertWidgets.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const VerticalSpacer(20),
                Text(
                  "Updates",
                  style: AppTextStyles.headingXSMedium(color: blue1600),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                  child: ExpandablePageView.builder(
                    itemCount: logic.alertWidgets.length,
                    physics: const ScrollPhysics(),
                    controller: logic.updatesController,
                    onPageChanged: logic.onUpdatePageChanged,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return logic.alertWidgets[index];
                    },
                  ),
                ),
                _updatesPageIndicator(),
                VerticalSpacer(20.h),
              ],
            );
          }
          return const SizedBox();
        });
  }

  Widget _updatesPageIndicator() {
    if(logic.alertWidgets.length > 1){
      return GetBuilder<HomeScreenLogic>(
          id: logic.ALERT_WIDGET_INDICATOR,
          builder: (logic) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                logic.alertWidgets.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _pageIndicatorDot(index),
                ),
              ),
            );
          });
    }
    return const SizedBox();
  }

  Container _pageIndicatorDot(int index) {
    return Container(
      width: logic.updatesCurrentIndex == index ? 12 : 5,
      height: 5,
      decoration: BoxDecoration(
          color:
              logic.updatesCurrentIndex == index ? darkBlueColor : Colors.grey,
          borderRadius: BorderRadius.circular(5)),
    );
  }

  Widget _exploreMore() {
    return logic.multiLPCCardsModel.exploreMore.isNotEmpty &&
            logic.exploreMoreVisible
        ? Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              bottom: 40.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explore More",
                  style: AppTextStyles.headingXSMedium(color: blue1600),
                ),
                verticalSpacer(12.h),
                if (logic.multiLPCCardsModel.exploreMore.length == 1)
                  ExploreMoreCard(
                    loanProductCode: getLoanProductCode(0),
                    lpcCard: logic.multiLPCCardsModel.exploreMore[0],
                    isMultiCard: _isMultiCard,
                  )
                else
                  Row(
                    children: [
                      ExploreMoreCard(
                        loanProductCode: getLoanProductCode(0),
                        lpcCard: logic.multiLPCCardsModel.exploreMore[0],
                        isMultiCard: _isMultiCard,
                      ),
                      SizedBox(width: 16.w),
                      ExploreMoreCard(
                        loanProductCode: getLoanProductCode(1),
                        lpcCard: logic.multiLPCCardsModel.exploreMore[1],
                        isMultiCard: _isMultiCard,
                      ),
                    ],
                  ),
                // ListView.separated(
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (context, index) {
                //       return ExploreMoreCard(
                //         loanProductCode: getLoanProductCode(index),
                //         lpcCard:
                //             logic.multiLPCCardsModel.exploreMore[index],
                //         isMultiCard: _isMultiCard,
                //       );
                //     },
                //     separatorBuilder: (context, index) {
                //       return SizedBox(
                //         width: _isMultiCard ? 16.w : 0.w,
                //       );
                //     },
                //     padding: EdgeInsets.only(right: 24.w),
                //     itemCount: logic.multiLPCCardsModel.exploreMore.length)
                // VerticalSpacer(40.h),
              ],
            ),
          )
        : verticalSpacer(0);
  }

  bool get _isMultiCard => logic.multiLPCCardsModel.exploreMore.length > 1;

  String getLoanProductCode(int index) {
    return logic.multiLPCCardsModel.exploreMore[index].loanProductCode;
  }

  double _computeExploreMoreHeight() {
    return _isMultiCard ? 200.h : 150.h;
  }

  Widget _primaryCards() {
    if (logic.multiLPCCardsModel.allCards.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: List.generate(
            logic.multiLPCCardsModel.allCards.length,
            (index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: PrimaryHomeScreenCard(
                lpcCard: logic.multiLPCCardsModel.allCards[index],
                initiallyExpanded: index == 0,
                expandable: logic.multiLPCCardsModel.allCards.length > 1,
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _homeScreenSuccessWidget() {
    return HomeScreenSuccessWidget(
      homePageWidget: _getHomePageCards(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterFirstLayout(context);
  }
}
