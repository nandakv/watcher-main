// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../common_widgets/gradient_button.dart';
// import '../../../models/home_screen_card_model.dart';
// import '../../on_boarding/widgets/offer/widgets/browser_home_bottom_widget.dart';
// import '../home_screen_logic.dart';
// import '../widgets/browser_final_offer_screen_widget.dart';
// import '../widgets/home_screen_browser_to_native_top_offer_widget.dart';

// class BrowserFinalHomeOfferScreen extends StatelessWidget {
//   BrowserFinalHomeOfferScreen(
//       {Key? key, required this.browserFinalOfferScreenType})
//       : super(key: key);

//   final logic = Get.find<HomeScreenLogic>();
//   final BrowserFinalOfferScreenType browserFinalOfferScreenType;

//   @override
//   Widget build(BuildContext context) {
//     return BrowserFinalOfferScreenWidget(
//       showHamburger: true,
//       scaffoldKey: logic.homePageScaffoldKey,
//       bottomWidget: const BrowserToAppBottomWidget(
//         bottomTitleText:
//             "Accept the agreement and access your dream Credit Line",
//       ),
//       topWidget: HomeScreenBrowserToNativeTopOfferWidget(
//         title: browserFinalOfferScreenType.title,
//         subtitle: browserFinalOfferScreenType.subtitle,
//         roi: browserFinalOfferScreenType.roi,
//         amount: browserFinalOfferScreenType.limitAmount,
//         minTenure: browserFinalOfferScreenType.minTenure,
//         maxTenure: browserFinalOfferScreenType.maxTenure,
//         processingFee: browserFinalOfferScreenType.processingFee,
//         ctaButton: _CTAButton(),
//       ),
//     );
//   }

//   Widget _CTAButton() {
//     return GetBuilder<HomeScreenLogic>(
//       builder: (logic) {
//         return GradientButton(
//           buttonTheme: AppButtonTheme.light,
//           onPressed: logic.computeUserStateAndNavigate,
//           title: browserFinalOfferScreenType.buttonText,
//         );
//       },
//     );
//   }
// }
