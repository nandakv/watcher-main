part of './app_pages.dart';

abstract class Routes {
  static const SPLASH_SCREEN = '/splash_screen';
  static const APP_PERMISSIONS = '/app_permissions';
  // static const HELLO_USER = '/hello_user';
  // static const EMAIL_SCREEN = '/email_screen';
  static const LOGIN_SCREEN = '/login_screen';
  // static const REGISTER_SCREEN = '/register_screen';
  // static const EMAIL_VERIFICATION_SCREEN = '/email_verification_screen';
  static const MOBILE_SCREEN = '/mobile_screen';
  static const SIGN_IN_SCREEN = '/sign_in_screen';
  static const OTP_SCREEN = '/otp_screen';
  static const MOBILE_OTP_SCREEN = '/mobile_otp_screen';
  static const TWO_FA_SCREEN = '/two_fa_screen';
  static const TWO_FA_SUCCESS_SCREEN = '/two_fa_success_screen';

  static const ON_BOARDING_SCREEN = '/on_boarding_screen';
  static const E_MANDATE_SUCCESS = '/e_mandate_success_screen';
  static const COMPLETE_KYC = '/complete_kyc';

  // static const PROCESSING_APPLICATION = '/processing_application';

  static const WITHDRAWAL_SCREEN = '/withdrawal_screen';

  // static const CREATE_PIN_SCREEN = '/create_otp_screen';
  // static const ENTER_PIN_SCREEN = '/enter_otp_screen';
  // static const RESET_PIN_SCREEN = '/reset_otp_screen';
  static const HOME_SCREEN = '/home_screen'; // Home Screen page

  static const PERFIOS_WEB_VIEW = '/perfios_web_view';
  static const MANDATE_WEB_VIEW = '/mandate_web_view';

  // static const FORGOT_PASSWORD = "/forgot_password";
  // static const RESET_PASSWORD_PIN = "/reset_password_pin";
  static const CHANGE_PASSWORD = "/change_password";
  static const String SERVICING_SCREEN =
      '/servicing_home_screen'; // HomeScreen page
  // static const String SERVICING_LOAN_DETAILS_SCREEN =
  //     '/loan_details_screen'; // Loan Details page
  static const String SEARCH_SCREEN = '/search_screen'; // Loan Details page

  static const String PDF_DOCUMENT_SCREEN = '/pdf_document_screen';

  static const String RE_PAYMENT_TYPE_SELECTOR = '/re_payment_type_selector';

  static const String _PAYMENT_SCREEN = '/payment_screen';

  static const String PAYMENT_SUCCESS_SCREEN = '/payment_success_screen';
  static const String PAYMENT_FAILURE_SCREEN = '/payment_failure_screen';

  static const String RE_PAYMENT_RESULT = '/re_payment_result';

  static const String PROFILE_SCREEN = '/profile_screen';

  static const String HELP_AND_SUPPORT = '/help_and_support';
  static const String _FAQ_HELP_AND_SUPPORT = '/faq_help_and_support';
  static const String KNOWLEDGE_BASE = '/knowledge_base';
  static const String BLOG_DETAILS = '/blog_details';

  static const String LOW_AND_GROW = '/low_and_grow';

  static const String OFFER_UPGRADE_HISTORY = '/upgrade_history_screen';

  static const String PAYMENT_LOAN_LIST = '/payment_loan_list';

  static const String PARTNER_OFFER_DETAILS_SCREEN =
      "/partner_offer_details_screen";

  static const String ADD_BANK_SCREEN = "/add_bank_screen";
  static const String LOAN_DETAILS_SCREEN = "/loan_details_screen";
  static const String LOANS_TERMS = "/loans_terms";

  static const String LOANS_CANCELLATION = "/loan_cancellation";

  static const String FEEDBACK = "/feedback";
  static const String TRANSACTION_HISTORY = "/transaction_history";
  static const String CREDIT_REPORT = "/credit_report";
  static const String CREDIT_ACCOUNT_DETAILS = "/credit_account_details";
  static const String EMI_CALCULATOR = "/emi_calculator";
  static const String KNOW_MORE_GET_STARTED = "/know_more_get_started";
  static const String TOPUP_KNOW_MORE = "/topup_know_more";
  static const String FIN_SIGHTS = "/fin_sights";
  static const String SECURITY_SCREEN = "/security_screen";
  static const String NON_ELIGIBLE_FINSIGHTS_SCREEN = "/non_eligible_finsights_screen";
  static const String FINSIGHT_WAIT_LIST_SCREEN = "/waitlist_screen";
  static const String REFERRAL = "/referral";
  static const String SPENDING_INSIGHTS = "/spending_insights";
  static const String CREDIT_SCORE_POINTS_UPDATE =
      "/credit_score_points_update";
}
