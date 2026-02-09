
// 
// import 'package:privo/app/models/loan_details_model.dart';
// import 'package:privo/app/models/pending_loan_details.dart';
// import 'package:privo/app/modules/loan_details/loan_screen_details_model.dart';
// import 'package:privo/app/modules/loan_details/widgets/closed_loan_details.dart';
// import 'package:privo/app/modules/servicing_home_screen/widgets/banner_widget.dart';
// import 'package:privo/app/modules/servicing_home_screen/widgets/quick_pay_button.dart';
// import 'package:privo/app/routes/app_pages.dart';
// import 'package:privo/app/theme/app_colors.dart';
// import 'package:privo/app/theme/app_text_theme.dart';
// import 'package:privo/res.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../servicing_home_screen_logic.dart';
// import 'loan_icon_container.dart';
//
// class loanTabContainer extends StatelessWidget {
//   bool? isPending;
//   bool? isClosed;
//   int? index;
//
//   ActiveLoans? activeLoanDetails;
//   ClosedLoans? closedLoanDetails;
//   LoanDetailsModel? loanDetailsModel;
//   PendingLoanDetailsModel? pendingLoanDetailsModel;
//
//   loanTabContainer(
//       {Key? key,
//       this.isPending,
//       this.isClosed,
//       this.index,
//       this.activeLoanDetails,
//       this.closedLoanDetails,
//       this.loanDetailsModel,
//       this.pendingLoanDetailsModel})
//       : super(key: key);
//
//   final logic = Get.find<ServicingHomeScreenLogic>();
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       //To detect the tap on the container.. Quickpay doesn't have a seperate click as there was no screen
//       onTap: () async {
//         // Get.toNamed(Routes.SERVICING_LOAN_DETAILS_SCREEN,arguments: [
//         //   activeLoanDetails,
//         //   isPending,
//         //   isClosed,
//         //   closedLoanDetails
//         // ]);
//         if (pendingLoanDetailsModel != null)
//           logic.pendingLoanDetailsModel = pendingLoanDetailsModel!;
//         await Get.toNamed(Routes.SERVICING_LOAN_DETAILS_SCREEN, arguments: {
//           "loanScreenDetails": LoanScreenDetailsModel(
//               loanDetailsModel: loanDetailsModel!,
//               isPending: isPending!,
//               isClosed: isClosed!,
//               activeLoans: activeLoanDetails,
//               closedLoans: closedLoanDetails,
//               pendingLoanDetailsModel: pendingLoanDetailsModel)
//         });
//         logic.getCustomerLoanDetails();
//       },
//       child: Container(
//         height: 86,
//         // height: (isPending != null && isPending != true) ||
//         //     (isClosed != null && isClosed == true)
//         //     ? 96,
//         decoration: BoxDecoration(
//             color: const Color(0xFFFFFFFF),
//             boxShadow: const [
//               BoxShadow(
//                   color: Colors.black12, offset: Offset(0, 6), blurRadius: 6)
//             ],
//             borderRadius: BorderRadius.circular(6)),
//         width: Get.width,
//         child: Stack(
//           children: [
//             Positioned(
//               top: 12,
//               left: 20,
//               child: Text(
//                 "Reference ID - ${_getLoanId()}",
//                 style: const TextStyle(
//                   color: subtextColor,
//                   fontSize: 10,
//                 ),
//               ),
//             ),
//             Positioned(
//                 top: 12,
//                 right: 0,
//                 child: (isClosed != null && isClosed == true)
//                     ? BannerWidget(
//                         bannerColor: closedBannerFillColor,
//                         bannerText: "Closed",
//                         bannerTextColor: closedBannerTextColor,
//                       ) //Widget to show closed banner
//                     : (isPending != null && isPending != true)
//                         ? const BannerWidget(
//                             bannerColor: emiBannerColor,
//                             bannerText: "No EMI due",
//                             bannerTextColor: emiBannerTextColor,
//                           ) // Widget to show no emi due banner
//                         : BannerWidget(
//                             bannerColor:
//                                 const Color(0xfffad7d7).withOpacity(1.0),
//                             bannerText: "Pending Amt.",
//                             bannerTextColor: pendingEmiBannerTextColor,
//                           ) //Show pending EMI banner,
//                 ),
//             Positioned(
//               top: 25,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   LoanIconContainer(
//                     icon: Res.Next_EMI,
//                     title: isClosed! ? "Loan Amount" : "Next EMI",
//                     value: isClosed!
//                         ? "₹ ${logic.parseIntoCommaFormat(logic.closedLoans[index ?? 0].loanAmount)}"
//                         : "₹ ${logic.parseIntoCommaFormat(loanDetailsModel?.emiAmount ?? "")}",
//                   ), //Show icons for date and emi
//                   const SizedBox(
//                     width: 36,
//                   ),
//                   LoanIconContainer(
//                     icon: Res.Due_Date,
//                     title: isClosed! ? "Loan End Date" : "Due Date",
//                     value: isClosed!
//                         ? logic.dateFormatterFunc(_getLoan().loanEndDate)
//                         : logic.dateFormatterFunc(_getLoan().nextRepayDate),
//                   ),
//                 ],
//               ),
//             ),
//             // (isPending != null && isPending == true)
//             //     ? const Positioned(
//             //     left: 29,
//             //     top: 95,
//             //     child: QuickPayButton())
//             //     : Container()
//           ],
//         ),
//       ),
//     );
//   }
//
//   _getLoan() {
//     if (isClosed != null && isClosed == true) {
//       return logic.closedLoans[index ?? 0];
//     }
//     return logic.activeLoans[index ?? 0];
//   }
//
//   String _getLoanId() {
//     if (isClosed != null && isClosed == true) {
//       return logic.closedLoans[index ?? 0].loanId;
//     } else {
//       return _getLoan().loanId;
//     }
//   }
// }