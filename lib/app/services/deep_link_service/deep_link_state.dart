import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/routes/app_pages.dart';

Map<String, dynamic> deepLinkMaps = {
  "personal_details": PERSONAL_DETAILS,
  "aadhar_screen": KYC_AADHAAR,
  "bank_details": BANK_DETAILS,
  "repayment": SERVICING_SCREENS,
  "credit_report" : Routes.CREDIT_REPORT,
  "fin_sights":Routes.FIN_SIGHTS,
  "top_up": Routes.TOPUP_KNOW_MORE,
  "sbl_know_more": Routes.KNOW_MORE_GET_STARTED,
  "blog": Routes.BLOG_DETAILS
};
