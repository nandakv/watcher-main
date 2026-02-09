// import 'package:card_swiper/card_swiper.dart';
// import 'package:expandable_page_view/expandable_page_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:privo/app/models/advance_emi_payment_info_model.dart';
// import 'package:privo/app/modules/home_screen_module/widgets/advance_emi_home_widget/advance_emi_home_widget_logic.dart';
// import 'package:privo/app/utils/app_functions.dart';
//
// import '../../../../../res.dart';
// import '../../../../common_widgets/gradient_button.dart';
// import '../../../../common_widgets/golden_badge.dart';
// import '../../../../models/loans_model.dart';
// import '../../../../theme/app_colors.dart';
//
// class AdvanceEMIHomeWidget extends StatelessWidget {
//   AdvanceEMIHomeWidget({
//     Key? key,
//     required this.loanList,
//     required this.advanceEMIPaymentInfoModel,
//   }) : super(key: key);
//
//   final List<Loans> loanList;
//   final AdvanceEMIPaymentInfoModel? advanceEMIPaymentInfoModel;
//
//   final logic = Get.put(AdvanceEMIHomeWidgetLogic());
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: darkBlueColorShade1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 8,
//           horizontal: 24,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Align(
//               alignment: Alignment.centerRight,
//               child: GoldenBadge(title: "RECOMMENDED"),
//             ),
//             RichText(
//               text: TextSpan(
//                 children: [
//                   WidgetSpan(
//                     child: SvgPicture.asset(Res.fastTrackSVG),
//                   ),
//                   const WidgetSpan(
//                     child: SizedBox(
//                       width: 10,
//                     ),
//                   ),
//                   TextSpan(
//                     text: "EMI Fast-Track",
//                     style: GoogleFonts.poppins(
//                       color: offWhiteColor,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Text(
//               "Pre-pay a single EMI before the due date with ease",
//               style: TextStyle(
//                 fontSize: 10,
//                 color: offWhiteColor,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             _benefitsCarouselWidget(),
//             const SizedBox(
//               height: 10,
//             ),
//             _benefitsIndicator(),
//             const SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: MediaQuery.of(context).size.width * 0.2),
//               child: GradientButton(
//                 onPressed: () => logic.onPressPayButton(
//                   loanList,
//                   advanceEMIPaymentInfoModel,
//                 ),
//                 buttonTheme: AppButtonTheme.light,
//                 title: _computeButtonText(),
//               ),
//             ),
//             _computeKnowMoreText(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Align _computeKnowMoreText() {
//     return Center(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (advanceEMIPaymentInfoModel != null)
//             Text(
//               'Reference ID: #${advanceEMIPaymentInfoModel!.loanId}',
//               style: const TextStyle(
//                 color: offWhiteColor,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           TextButton(
//             onPressed: () => logic.onPressAdvanceEMIKnowMore(
//               advanceEMIPaymentInfoModel,
//               loanList,
//             ),
//             style: TextButton.styleFrom(
//                 visualDensity: const VisualDensity(vertical: -4)),
//             child: const Text(
//               'Know More',
//               style: TextStyle(
//                 color: skyBlueColor,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _computeButtonText() {
//     if (advanceEMIPaymentInfoModel != null) {
//       return "Pay ${AppFunctions.getIOFOAmount(
//         double.parse(advanceEMIPaymentInfoModel!.emiAmount.toString()),
//       )}";
//     }
//     return "Pay Now";
//   }
//
//   Align _benefitsIndicator() {
//     return Align(
//       alignment: Alignment.center,
//       child: PageIndicator(
//         count: logic.benefitsList.length,
//         controller: logic.benefitsController,
//         color: offWhiteColor.withOpacity(0.2),
//         size: 5,
//         activeColor: offWhiteColor,
//         layout: PageIndicatorLayout.WARM,
//       ),
//     );
//   }
//
//   ExpandablePageView _benefitsCarouselWidget() {
//     return ExpandablePageView(
//       controller: logic.benefitsController,
//       onPageChanged: logic.onBenefitIndexChanged,
//       children: List.generate(
//         logic.benefitsList.length,
//         (index) => RichText(
//           text: TextSpan(
//               text: "Benefits: ",
//               style: const TextStyle(
//                 color: offWhiteColor,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 10,
//               ),
//               children: [
//                 TextSpan(
//                   text: logic.benefitsList[index],
//                   style: const TextStyle(
//                     color: offWhiteColor,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 10,
//                   ),
//                 ),
//               ]),
//         ),
//       ),
//     );
//   }
// }
