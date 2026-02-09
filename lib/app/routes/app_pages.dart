import 'package:get/get.dart';
import 'package:privo/app/models/arguments_model/faq_help_support_arguments.dart';
import 'package:privo/app/models/arguments_model/route_arguments.dart';
import 'package:privo/app/modules/app_permissions/app_permissions_binding.dart';
import 'package:privo/app/modules/app_permissions/app_permissions_view.dart';
import 'package:privo/app/modules/authentication/mobile_screen/mobile_screen_binding.dart';
import 'package:privo/app/modules/authentication/mobile_screen/mobile_screen_view.dart';
import 'package:privo/app/modules/bank_name_not_found/bank_not_found_screen.dart';
import 'package:privo/app/modules/blog_details/blog_details_binding.dart';
import 'package:privo/app/modules/blog_details/blog_details_view.dart';
import 'package:privo/app/modules/e_mandate_success/e_mandate_success_binding.dart';
import 'package:privo/app/modules/e_mandate_success/e_mandate_success_view.dart';
import 'package:privo/app/modules/emi_calculator/emi_calculator_binding.dart';
import 'package:privo/app/modules/emi_calculator/emi_calculator_view.dart';
import 'package:privo/app/modules/feedback/feedback_binding.dart';
import 'package:privo/app/modules/feedback/feedback_view.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_binding.dart';
import 'package:privo/app/modules/fin_sights/fin_sights_view.dart';
import 'package:privo/app/modules/help_support/help_support_binding.dart';
import 'package:privo/app/modules/help_support/help_support_screen.dart';
import 'package:privo/app/modules/home_screen_module/home_screen.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_bindings.dart';
import 'package:privo/app/modules/home_screen_module/widgets/partner_home_screen/partner_offer_details_screen.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_bindings.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_screen.dart';
import 'package:privo/app/modules/knowledge_base/knowledge_base_binding.dart';
import 'package:privo/app/modules/knowledge_base/knowledge_base_view.dart';
import 'package:privo/app/modules/loan_cancellation/loan_cancellation_screen.dart';
import 'package:privo/app/modules/loans_terms/loans_terms_binding.dart';
import 'package:privo/app/modules/loans_terms/loans_terms_view.dart';
import 'package:privo/app/modules/loan_details/loan_details_screen.dart';
import 'package:privo/app/modules/low_and_grow/low_and_grow_view.dart';
import 'package:privo/app/modules/non_eligible_finsights/finsight_wait_list-screen.dart';
import 'package:privo/app/modules/offer_upgrade_history/offer_upgrade_history_binding.dart';
import 'package:privo/app/modules/offer_upgrade_history/offer_upgrade_history_view.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_binding.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/search_screen/search_screen_binding.dart';
import 'package:privo/app/modules/on_boarding/widgets/search_screen/search_screen_view.dart';
import 'package:privo/app/modules/payment/model/payment_view_model.dart';
import 'package:privo/app/modules/payment/widgets/payment_failure_screen.dart';
import 'package:privo/app/modules/payment_loans_list/payment_loans_list_binding.dart';
import 'package:privo/app/modules/payment_loans_list/payment_loans_list_view.dart';
import 'package:privo/app/modules/pdf_document/pdf_document_view.dart';
import 'package:privo/app/modules/perfios_web_view/perfios_web_view_binding.dart';
import 'package:privo/app/modules/perfios_web_view/perfios_web_view_view.dart';
import 'package:privo/app/modules/profile/profile_binding.dart';
import 'package:privo/app/modules/profile/profile_screen.dart';
import 'package:privo/app/modules/referral/referral_page.dart';
import 'package:privo/app/modules/servicing_home_screen/servicing_home_screen_binding.dart';
import 'package:privo/app/modules/servicing_home_screen/servicing_home_screen_view.dart';
import 'package:privo/app/modules/splash_screen_module/splash_screen_bindings.dart';
import 'package:privo/app/modules/splash_screen_module/splash_screen_page.dart';
import 'package:privo/app/modules/topup_know_more/topup_know_more_bindings.dart';
import 'package:privo/app/modules/topup_know_more/topup_know_more_screen.dart';
import 'package:privo/app/modules/transaction_history/transaction_history_binding.dart';
import 'package:privo/app/modules/transaction_history/transaction_history_view.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_screen_binding.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_screen_view.dart';
import '../modules/authentication/sign_in_screen/sign_in_screen_binding.dart';
import '../modules/authentication/sign_in_screen/sign_in_screen_view.dart';
import '../modules/authentication/two_factor_authentication/two_factor_authentication_binding.dart';
import '../modules/authentication/two_factor_authentication/two_factor_authentication_view.dart';
import '../modules/authentication/two_factor_authentication/widgets/two_factor_authentication_success_screen.dart';
import '../modules/authentication/verify_otp/verify_otp_binding.dart';
import '../modules/authentication/verify_otp/verify_otp_screen.dart';
import '../modules/bank_name_not_found/bank_not_found_binding.dart';
import '../modules/credit_report/credit_report_binding.dart';
import '../modules/credit_report/credit_report_screen.dart';
import '../modules/credit_report/widgets/credit_score_line_graph/credit_score_update_screen.dart';
import '../modules/faq_help_support/faq_help_support_screen.dart';
import '../modules/faq_help_support/help_support_binding.dart';
import '../modules/fin_sights/spending_insights/spending_insights.dart';
import '../modules/loan_cancellation/loan_cancellation_bindings.dart';
import '../modules/loan_details/loan_details_binding.dart';
import '../modules/low_and_grow/low_and_grow_binding.dart';
import '../modules/non_eligible_finsights/non_eligible_finsight_screen.dart';
import '../modules/non_eligible_finsights/non_eligible_finsights_binding.dart';
import '../modules/payment/payment_binding.dart';
import '../modules/payment/payment_view.dart';
import '../modules/payment/widgets/payment_success_screen.dart';
import '../modules/pdf_document/pdf_document_binding.dart';
import '../modules/re_payment_result/re_payment_result_binding.dart';
import '../modules/re_payment_result/re_payment_result_view.dart';
import '../modules/re_payment_type_selector/re_payment_type_selector_binding.dart';
import '../modules/re_payment_type_selector/re_payment_type_selector_view.dart';
import '../modules/referral/referral_binding.dart';

part './app_routes.dart';

part './navigation_service.dart';

part '../modules/payment/payment_navigation_service.dart';

part '../modules/faq_help_support/faq_help_support_navigation_service.dart';

part '../modules/fin_sights/finsights_navigation_service.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => const SplashScreenPage(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
        name: Routes.APP_PERMISSIONS,
        page: () => const AppPermissionsPage(),
        binding: AppPermissionsBinding()),
    GetPage(
      name: Routes.MOBILE_SCREEN,
      page: () => MobileScreenPage(),
      binding: MobileScreenBinding(),
    ),
    GetPage(
      name: Routes.SIGN_IN_SCREEN,
      page: () => SignInScreenView(),
      binding: SignInScreenBinding(),
    ),
    GetPage(
      name: Routes.MOBILE_OTP_SCREEN,
      page: () => const VerifyOTPPage(),
      binding: VerifyOTPBinding(),
      // transition: Transition.rightToLeft,
      // transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.TWO_FA_SCREEN,
      page: () => const TwoFactorAuthenticationPage(),
      binding: TwoFactorAuthenticationBinding(),
    ),
    GetPage(
      name: Routes.TWO_FA_SUCCESS_SCREEN,
      page: () => const TwoFactorAuthenticationSuccessScreen(),
    ),
    GetPage(
      name: Routes.ON_BOARDING_SCREEN,
      page: () => const OnBoardingPage(),
      binding: OnBoardingBinding(),
      // transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.E_MANDATE_SUCCESS,
      page: () => EMandateSuccessView(),
      binding: EMandateSuccessBinding(),
    ),
    GetPage(
        name: Routes.WITHDRAWAL_SCREEN,
        page: () => WithdrawalScreenPage(),
        binding: WithdrawalScreenBinding()),
    GetPage(
      name: Routes.SERVICING_SCREEN,
      page: () => ServicingHomeScreenPage(),
      binding: ServicingHomeScreenBinding(),
    ),
    GetPage(
      name: Routes.PERFIOS_WEB_VIEW,
      page: () => PerfiosWebViewPage(),
      binding: PerfiosWebViewBinding(),
    ),
    GetPage(
      name: Routes.HOME_SCREEN,
      page: () => HomeScreen(),
      binding: HomeScreenBinding(),
      // transition: Transition.native,
    ),
    // GetPage(
    //   name: Routes.SERVICING_LOAN_DETAILS_SCREEN,
    //   page: () => LoanDetailsPage(),
    //   binding: LoanDetailsBinding(),
    // ),
    GetPage(
      name: Routes.SEARCH_SCREEN,
      page: () => SearchScreenView(),
      binding: SearchScreenBinding(),
      // transition: Transition.upToDown,
    ),
    GetPage(
      name: Routes.PDF_DOCUMENT_SCREEN,
      page: () => PDFDocumentView(),
      binding: PDFDocumentBinding(),
    ),
    GetPage(
      name: Routes.RE_PAYMENT_TYPE_SELECTOR,
      page: () => RePaymentTypeSelectorPage(),
      binding: RePaymentTypeSelectorBinding(),
    ),
    GetPage(
      name: Routes._PAYMENT_SCREEN,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT_SUCCESS_SCREEN,
      page: () => const PaymentSuccessScreen(),
    ),
    GetPage(
      name: Routes.PAYMENT_FAILURE_SCREEN,
      page: () => PaymentFailureScreen(),
    ),
    GetPage(
      name: Routes.RE_PAYMENT_RESULT,
      page: () => RePaymentResultPage(),
      binding: RePaymentResultBinding(),
    ),
    GetPage(
      name: Routes.PROFILE_SCREEN,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.HELP_AND_SUPPORT,
      page: () => const HelpAndSupportScreen(),
      binding: HelpAndSupportBinding(),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes._FAQ_HELP_AND_SUPPORT,
      page: () => FAQHelpSupportScreen(),
      binding: FAQHelpSupportBinding(),
    ),
    GetPage(
      name: Routes.KNOWLEDGE_BASE,
      page: () => KnowledgeBasePage(),
      binding: KnowledgeBaseBinding(),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.BLOG_DETAILS,
      page: () => BlogDetailsPage(),
      binding: BlogDetailsBinding(),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.LOANS_TERMS,
      page: () => LoansTermsScreen(),
      binding: LoansTermsBinding(),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.OFFER_UPGRADE_HISTORY,
      page: () => OfferUpgradeHistoryPage(),
      binding: OfferUpgradeHistoryBinding(),
    ),
    GetPage(
      name: Routes.LOW_AND_GROW,
      page: () => const LowAndGrowScreen(),
      binding: LowAndGrowBinding(),
    ),
    GetPage(
      name: Routes.PARTNER_OFFER_DETAILS_SCREEN,
      page: () => PartnerOfferDetailsScreen(),
    ),
    GetPage(
      name: Routes.ADD_BANK_SCREEN,
      page: () => BankNotFoundScreen(),
      binding: BankNotFoundBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT_LOAN_LIST,
      binding: PaymentLoansListBinding(),
      page: () => const PaymentLoansListView(),
    ),
    GetPage(
      name: Routes.LOANS_CANCELLATION,
      binding: LoanCancellationBinding(),
      page: () => LoanCancellationScreen(),
    ),
    GetPage(
      name: Routes.LOAN_DETAILS_SCREEN,
      page: () => const LoanDetailsScreen(),
      binding: LoanDetailsBinding(),
    ),
    GetPage(
      name: Routes.FEEDBACK,
      page: () => FeedbackPage(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: Routes.TRANSACTION_HISTORY,
      page: () => TransactionHistoryPage(),
      binding: TransactionHistoryBinding(),
    ),
    GetPage(
      name: Routes.CREDIT_REPORT,
      page: () => CreditReportScreen(),
      binding: CreditReportBinding(),
    ),
    GetPage(
      name: Routes.EMI_CALCULATOR,
      page: () => EmiCalculatorView(),
      binding: EmiCalculatorBinding(),
    ),
    GetPage(
      name: Routes.KNOW_MORE_GET_STARTED,
      page: () => KnowMoreGetStartedScreen(),
      binding: KnowMoreGetStartedBinding(),
    ),
    GetPage(
      name: Routes.TOPUP_KNOW_MORE,
      page: () => TopUpKnowMoreScreen(),
      binding: TopUpKnowMoreBinding(),
    ),
    GetPage(
      name: Routes.FIN_SIGHTS,
      page: () => FinSightsPage(),
      binding: FinSightsBinding(),
    ),
    GetPage(
      name: Routes.NON_ELIGIBLE_FINSIGHTS_SCREEN,
      page: () => NonEligibleFinSightScreen(),
      binding: NonEligibleFinsightBinding(),
    ),
    GetPage(
      name: Routes.FINSIGHT_WAIT_LIST_SCREEN,
      page: () => const FinSightWaitListScreen(),
      binding: NonEligibleFinsightBinding(),
    ),
    GetPage(
      name: Routes.REFERRAL,
      page: () => const ReferralPage(),
      binding: ReferralBinding(),
    ),
    GetPage(
      name: Routes.SPENDING_INSIGHTS,
      page: () => SpendingInsights(),
      binding: FinSightsBinding(),
    )
  ];
}

