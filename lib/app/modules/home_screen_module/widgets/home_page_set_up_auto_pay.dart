// import 'package:after_layout/after_layout.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:privo/app/models/home_screen_card_model.dart';
// import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
// import 'package:privo/app/theme/app_colors.dart';
// import '../../../common_widgets/ROI_table.dart';
// import '../../../common_widgets/gradient_button.dart';

// import '../../../common_widgets/home_screen_title_subtitle.dart';
// import '../../../common_widgets/limit_progress_indicator.dart';
// import '../../../utils/app_functions.dart';
// import '../../../utils/ui_constant_text.dart';


// class HomePageTopEmandateWidget extends StatefulWidget {
//   HomePageTopEmandateWidget({Key? key, required this.emandateDetailsHomePageModel})
//       : super(key: key);

//   EmandateDetailsHomeScreenType emandateDetailsHomePageModel;

//   @override
//   State<HomePageTopEmandateWidget> createState() => _HomePageTopEmandateWidgetState();
// }

// class _HomePageTopEmandateWidgetState extends State<HomePageTopEmandateWidget> with AfterLayoutMixin{
//   var homeScreenControllerLogic = Get.find<HomeScreenLogic>();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Flexible(
//             child: Text(
//               congratulation,
//               style: titleTextStyle,
//             ),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           Flexible(
//             child: Text(
//               creditLineSubTitle,
//               textAlign: TextAlign.center,
//               style: _subTitleTextStyle(),
//             ),
//           ),
//           const SizedBox(
//             height: 32,
//           ),
//           _buttonAndHelpText(),
//           const SizedBox(
//             height: 35,
//           ),
//           Flexible(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 60),
//               child: GradientButton(
//                   onPressed: () {
//                     homeScreenControllerLogic.goToOnBoardingPage();
//                   },
//                   title: homeScreenControllerLogic.homeScreenModel.buttonText,
//                   buttonTheme: AppButtonTheme.light),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buttonAndHelpText() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 30),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           LimitProgressIndicator(
//             strokeWidth: 10,
//           ),
//           const Spacer(),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Flexible(
//                 child: Text(
//                   "Your available limit",
//                   //textAlign: TextAlign.center,
//                   style: _subTitleTextStyle(),
//                 ),
//               ),
//               Flexible(
//                 child: Text(
//                   "₹ ${widget.emandateDetailsHomePageModel.limit}",
//                   style: amountTextStyle(fontSize: 25),
//                 ),
//               ),
//               Flexible(
//                 child: Text(
//                   "at ${widget.emandateDetailsHomePageModel.roi}% ROI",
//                   //    textAlign: TextAlign.center,
//                   style: _subTitleTextStyle(),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   TextStyle _subTitleTextStyle() {
//     return const TextStyle(
//         fontSize: 12, color: Color(0xffFFF3EB), fontWeight: FontWeight.normal);
//   }

//   TextStyle get titleTextStyle {
//     return GoogleFonts.poppins(
//       fontSize: 24,
//       fontWeight: FontWeight.w600,
//       letterSpacing: 0.58,
//       color: skyBlueColor,
//     );
//   }

//   TextStyle amountTextStyle({required double fontSize}) {
//     return GoogleFonts.poppins(
//       fontSize: fontSize,
//       letterSpacing: 0.18,
//       fontWeight: FontWeight.bold,
//       color: const Color(0xffFFF3EB),
//     );
//   }

//   @override
//   void afterFirstLayout(BuildContext context) {
//     // homeScreenControllerLogic.homeScreenType = HomeScreenType.setUpAutoPay;
//     homeScreenControllerLogic.update();
//   }
// }
