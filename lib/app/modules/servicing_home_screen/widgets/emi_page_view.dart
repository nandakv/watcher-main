/*
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
// import 'package:privo/app/theme/app_colors.dart';
// import 'package:skeletons/skeletons.dart';
//
// import '../../../models/loan_details_model.dart';
// import '../../../models/pending_loan_details.dart';
// import '../servicing_home_screen_logic.dart';
// import 'loan_tab_container.dart';
//
// class EmiMainScreen extends StatelessWidget {
//   EmiMainScreen({Key? key}) : super(key: key);
//   final logic = Get.find<ServicingHomeScreenLogic>();
//   final homePageController = Get.find<HomeScreenLogic>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             color: const Color(0xffF9F9FA),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (logic.offerUpgradeHistoryAvailable)
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: PopupMenuTheme(
//                       data: PopupMenuThemeData(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         color: const Color(0xffFFF3EB),
//                       ),
//                       child: PopupMenuButton<int>(
//                         position: PopupMenuPosition.under,
//                         offset: const Offset(-22, 0),
//                         onOpened: () => logic.toggleOverlay(overlayValue: true),
//                         onSelected: (value) {
//                           if (value == 1) {
//                             logic.openUpgradeHistory();
//                           }
//                         },
//                         onCanceled: () =>
//                             logic.toggleOverlay(overlayValue: false),
//                         itemBuilder: (context) {
//                           return [
//                             const PopupMenuItem<int>(
//                               value: 1,
//                               height: 30,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 0,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "View Upgrade History",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: Color(0xff161742),
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ];
//                         },
//                       ),
//                     ),
//                   )
//                 else
//                   const SizedBox(
//                     height: kToolbarHeight,
//                   ),
//                 SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// Active loans
//                       Text(
//                         "Your Active Loans (${logic.activeLoans.length})",
//                         style: const TextStyle(
//                           color: subtextColor,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       //Widget to show if loan is pending or not, pass is_pending field to show if loan is pending or no due
//                       SizedBox(
//                         width: double.maxFinite,
//                         child: ListView.separated(
//                           separatorBuilder: (context, index) => const SizedBox(
//                             height: 15,
//                           ),
//                           shrinkWrap: true,
//                           itemCount: logic.activeLoans.length,
//                           padding: const EdgeInsets.only(bottom: 10),
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return FutureBuilder(
//                               future: Future.wait([
//                                 logic.getLoanDetails(
//                                     logic.activeLoans[index].loanId),
//                               ///currently we are not using this emi_page_view, develop revamp screen
//                               //  logic.getPendingLoanDetails(index),
//                               ]),
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.done) {
//                                   if ((snapshot.data as List)[1] != null &&
//                                       (snapshot.data as List)[0] != null) {
//                                     PendingLoanDetailsModel
//                                         pendingLoanDetailsModel =
//                                         (snapshot.data as List)[1];
//                                     LoanDetailsModel loanDetailsModel =
//                                         (snapshot.data as List)[0];
//                                     return loanTabContainer(
//                                       isClosed: false,
//                                       index: index,
//                                       isPending: logic.checkIfLoanIsPending(
//                                           pendingLoanDetailsModel),
//                                       activeLoanDetails:
//                                           logic.activeLoans[index],
//                                       loanDetailsModel: loanDetailsModel,
//                                       pendingLoanDetailsModel:
//                                           pendingLoanDetailsModel,
//                                     );
//                                   } else {
//                                     Get.log("Sized box");
//                                     return const SizedBox();
//                                   }
//                                 } else {
//                                   return _skeletonView();
//                                 }
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       if (logic.customerLoansModel.closedLoans.isNotEmpty)
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       if (logic.customerLoansModel.closedLoans.isNotEmpty)
//                         Text(
//                           "Your Closed Loans (${logic.customerLoansModel.closedLoans.length})",
//                           style: const TextStyle(
//                             color: subtextColor,
//                             fontSize: 14,
//                           ),
//                         ),
//                       if (logic.customerLoansModel.closedLoans.isNotEmpty)
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       if (logic.customerLoansModel.closedLoans.isNotEmpty)
//                         ListView.separated(
//                           separatorBuilder: (context, index) => const SizedBox(
//                             height: 15,
//                           ),
//                           shrinkWrap: true,
//                           itemCount:
//                               logic.customerLoansModel.closedLoans.length,
//                           // padding: const EdgeInsets.only(bottom: 50,right: 19,top: 10),
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return FutureBuilder(
//                               future: logic.getLoanDetails(
//                                   logic.closedLoans[index].loanId),
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.done) {
//                                   if (snapshot.hasData) {
//                                     LoanDetailsModel? loanDetailsModel =
//                                         snapshot.data as LoanDetailsModel?;
//                                     return loanTabContainer(
//                                       isClosed: true,
//                                       isPending: false,
//                                       index: index,
//                                       activeLoanDetails: null,
//                                       closedLoanDetails:
//                                           logic.closedLoans[index],
//                                       loanDetailsModel: loanDetailsModel,
//                                     );
//                                   } else {
//                                     return const SizedBox();
//                                   }
//                                 } else {
//                                   return _skeletonView();
//                                 }
//                               },
//                             );
//                           },
//                         ),
//                       const SizedBox(
//                         height: 80,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           GetBuilder<ServicingHomeScreenLogic>(
//             id: logic.OVERLAY_WIDGET_ID,
//             builder: (logic) {
//               return logic.enableOverlay
//                   ? Container(
//                       width: double.infinity,
//                       height: double.infinity,
//                       color: Colors.black38,
//                     )
//                   : const SizedBox();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _skeletonView() {
//     return SkeletonItem(
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: SkeletonParagraph(
//                   style: SkeletonParagraphStyle(
//                     lines: 3,
//                     spacing: 6,
//                     lineStyle: SkeletonLineStyle(
//                       randomLength: true,
//                       height: 10,
//                       borderRadius: BorderRadius.circular(8),
//                       minLength: Get.width / 6,
//                       maxLength: Get.width / 3,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 12,
//           ),
//           SkeletonLine(
//             style: SkeletonLineStyle(
//                 height: 16,
//                 width: Get.width,
//                 borderRadius: BorderRadius.circular(8)),
//           )
//         ],
//       ),
//     );
//   }
// }
*/
