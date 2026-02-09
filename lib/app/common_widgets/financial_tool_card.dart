// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:privo/app/models/home_screen_model.dart';
// import 'package:privo/app/modules/emi_calculator/emi_screen_analytics.dart';
// import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
// import 'package:privo/app/routes/app_pages.dart';
// import 'package:privo/app/theme/app_colors.dart';
// import 'package:privo/res.dart';
//
// enum FinanicalToolType { emiCalculator, creditReport }
//
// class FinancialToolCard extends StatelessWidget with EmiScreenAnalytics {
//   final FinanicalToolType finanicalToolType;
//   CreditScoreModel? creditScoreModel;
//   final bool isMultiCard;
//
//   FinancialToolCard(
//       {required this.finanicalToolType,
//       this.creditScoreModel,
//       this.isMultiCard = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: _onClick,
//       child: IntrinsicWidth(
//         child: Container(
//           decoration: _gradientBorderDecoration(),
//           padding: const EdgeInsets.symmetric(horizontal: 0.2, vertical: 0.5),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Stack(
//               children: [_emiCalculatorTitle(), _icon()],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _onClick() {
//     switch (finanicalToolType) {
//       case FinanicalToolType.emiCalculator:
//         _onEmiCalculatorClicked();
//         break;
//       case FinanicalToolType.creditReport:
//         _onCreditReportClicked();
//         break;
//     }
//   }
//
//   Widget _icon() {
//     return Padding(
//       padding: EdgeInsets.only(
//         top: isMultiCard ? 40 : 10,
//         right: isMultiCard ? 0 : 15,
//       ),
//       child: Align(
//           alignment: Alignment.bottomRight,
//           child: ClipRRect(
//             borderRadius:
//                 const BorderRadius.only(bottomRight: Radius.circular(13)),
//             child: SvgPicture.asset(
//               _computeIcon(),
//               height: 71,
//               alignment: Alignment.bottomRight,
//             ),
//           )),
//     );
//   }
//
//   Widget _subTitle() {
//     return Text(
//       _computeSubTitle(),
//       style: const TextStyle(
//           color: secondaryDarkColor, fontWeight: FontWeight.w500, fontSize: 10),
//     );
//   }
//
//   Widget _emiCalculatorTitle() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Text(
//                   _computeTitle(),
//                   style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: navyBlueColor),
//                 ),
//               ),
//               const SizedBox(
//                 width: 40,
//               ),
//               SvgPicture.asset(
//                 Res.rightArrow,
//                 color: darkBlueColor,
//                 height: 8,
//                 width: 5,
//               ),
//             ],
//           ),
//           _subTitle(),
//         ],
//       ),
//     );
//   }
//
//   BoxDecoration _gradientBorderDecoration() {
//     return BoxDecoration(
//         borderRadius: BorderRadius.circular(13),
//         gradient: const LinearGradient(colors: [
//           Color(0xFF8FD1EC),
//           Color(0xFF229ACE),
//         ]),
//         border: Border.all(
//           color: const Color(0xFF8FD1EC),
//           width: 1,
//         ));
//   }
//
//   String _computeTitle() {
//     switch (finanicalToolType) {
//       case FinanicalToolType.emiCalculator:
//         return "EMI Calculator";
//       case FinanicalToolType.creditReport:
//         return "Credit Score";
//     }
//   }
//
//   String _computeSubTitle() {
//     switch (finanicalToolType) {
//       case FinanicalToolType.emiCalculator:
//         return "Estimate your monthly payments instantly";
//       case FinanicalToolType.creditReport:
//         return creditScoreModel!.cardText;
//     }
//   }
//
//   String _computeIcon() {
//     switch (finanicalToolType) {
//       case FinanicalToolType.emiCalculator:
//         return Res.emiCalculator;
//       case FinanicalToolType.creditReport:
//         return Res.creditReport;
//     }
//   }
//
//   void _onEmiCalculatorClicked() {
//     logEmiCalculatorClicked();
//     Get.toNamed(Routes.EMI_CALCULATOR);
//   }
//
//   void _onCreditReportClicked() {
//     if (creditScoreModel != null) {
//       final logic = Get.find<HomeScreenLogic>();
//       logic.goToCreditReport(creditScoreModel!);
//     }
//   }
// }
