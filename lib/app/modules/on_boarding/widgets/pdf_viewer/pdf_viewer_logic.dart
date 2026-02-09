// import 'package:get/get.dart';
// import 'package:privo/app/api/api_error_mixin.dart';
// import 'package:privo/app/api/response_model.dart';
// import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
// import 'package:privo/app/firebase/analytics.dart';
// import 'package:privo/app/models/check_app_form_model.dart';
// import 'package:privo/app/modules/on_boarding/pdf_viewer_service.dart';
// import 'package:privo/app/modules/on_boarding/widgets/pdf_viewer/pdf_viewer_navigation.dart';
// import 'package:privo/app/modules/on_boarding/widgets/pdf_viewer/pdf_viewer_page.dart';
// import 'package:privo/app/utils/apps_flyer_constants.dart';
//
// import '../../on_boarding_mixin.dart';
//
//
// class PdfViewerLogic extends GetxController
//     with ApiErrorMixin, OnBoardingMixin {
//
//   static const String PDF_VIEWER_LOGIC = "pdf_viewer_logic";
//
//   OnBoardingPdfViewerNavigation? onBoardingPdfViewerNavigation;
//
//   PdfViewerLogic({this.onBoardingPdfViewerNavigation});
//
//
//   void onAfterFirstLayout(LetterType letterType) async {
//     _toggleBackDisabled(isBackDisabled: true);
//     AppAnalytics.logAppsFlyerEvent(eventName: AppsFlyerConstants.creditLineSanctioned);
//     PDFViewerService pdfViewerService = PDFViewerService();
//     if (await pdfViewerService.initLetterView(letterType: letterType)) {
//       onViewComplete(letterType);
//     } else {
//       handleAPIError(
//         ResponseState.failure,
//         retry: () => onAfterFirstLayout(letterType),
//       );
//     }
//   }
//
//   onViewComplete(LetterType letterType) {
//     if (onBoardingPdfViewerNavigation != null) {
//       switch (letterType) {
//         case LetterType.sanctionLetter:
//           updateConsent(body: {
//             "LetterAcceptance": {
//               "Sanction Letter Accepted": "Yes",
//               "Sanction Letter Accepted Time": DateTime.now().toString()
//             },
//             "app_state": "6"
//           },letterType: LetterType.sanctionLetter);
//           break;
//         case LetterType.lineAgreement:
//           updateConsent(body: {
//             "LetterAcceptance": {
//               "Line Agreement Accepted": "Yes",
//               "Line Agreement Accepted Time": DateTime.now().toString()
//             },
//             "app_state":"13"
//           },letterType: LetterType.lineAgreement);
//           break;
//       }
//     }
//   }
//
//   updateConsent({required Map body,required LetterType letterType})async{
//     OnBoardingRepository onBoardingRepository = OnBoardingRepository();
//     CheckAppFormModel checkAppFormModel =
//     await onBoardingRepository.updateUserLetterConsent(body);
//     switch (checkAppformModel.apiResponse) {
//       case ResponseState.success:
//         _computeNavigation(letterType);
//         break;
//       default:
//         handleAPIError(
//           checkAppformModel.apiResponse,
//           retry: updateConsent,
//         );
//     }
//   }
//
//   _computeNavigation(LetterType letterType){
//     switch(letterType){
//       case LetterType.sanctionLetter:
//         _navigateToOfferScreen();
//         break;
//       case LetterType.lineAgreement:
//         _navigateToCreditLineApprovedScreen();
//         break;
//     }
//   }
//
//
//   void _navigateToOfferScreen() {
//     if (onBoardingPdfViewerNavigation != null) {
//       _toggleBackDisabled(isBackDisabled: false);
//       onBoardingPdfViewerNavigation!.navigateToOfferScreen();
//     } else {
//       onNavigationDetailsNull(PDF_VIEWER_LOGIC);
//     }
//   }
//
//   void _navigateToCreditLineApprovedScreen() {
//     if (onBoardingPdfViewerNavigation != null) {
//       _toggleBackDisabled(isBackDisabled: false);
//       onBoardingPdfViewerNavigation!.navigateToCreditLineScreen();
//     } else {
//       onNavigationDetailsNull(PDF_VIEWER_LOGIC);
//     }
//   }
//
//   void _toggleBackDisabled({required bool isBackDisabled}) {
//     if (onBoardingPdfViewerNavigation != null) {
//       onBoardingPdfViewerNavigation!.toggleBack(isBackDisabled: isBackDisabled);
//     } else {
//       onNavigationDetailsNull(PDF_VIEWER_LOGIC);
//     }
//   }
// }
