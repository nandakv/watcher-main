import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/res.dart';

const PERSONAL_DETAILS_KEY = "PersonalDetails";
const SBD_BASIC_DETAILS_KEY = "BasicDetails";
const PERSONAL_DETAILS_POLLING_KEY = "PersonalDetailsPolling";
const WORK_DETAILS_KEY = "WorkDetails";
const BUREAU_POLLING_KEY = "BureauPolling";
const OFFER_POLLING_KEY = "OfferPolling";
const OFFER_DETAILS_KEY = "OfferDetails";
const AADHAAR_DETAILS_KEY = "Aadhaar";
const SELFIE_DETAILS_KEY = "Selfie";
const VKYC_DETAILS_KEY = "VideoKyc";
const LINE_AGREEMENT_KEY = "LineAgreement";
const ESIGN = "ESign";
const BANK_DETAILS_KEY = "BankDetails";
const KYC_POLLING_KEY = "KycPolling";
const CREDIT_LINE_APPROVED_KEY = "CreditLineApproved";
const BANK_DETAILS_POLLING_KEY = "BankDetailsPolling";
const EMANDATE_KEY = "Emandate";
const EMANDATE_POLLING_KEY = "EmandatePolling";
const WITHDRAW_KEY = "Withdrawal";
const WITHDRAWAL_POLLING_KEY = "WithdrawPolling";
const PAUSE_LOAN_KEY = "PauseLoan";
const UNSERVICEABLE_LOAN_KEY = "UnServiceableLoan";
// const UPL_DISBURSAL_PROGRESS_KEY = "UplDisbursalInProgress";
const UPL_DISBURSAL_COMPLETE_KEY = "DisbursalComplete";
const UPL_WAIT_SCREEN_KEY = "UplWaitScreen";
const SBL_DISBURSA_IN_PROGRESS_KEY = "DisbursalInProgress";

const AA_BANK_DETAILS_KEY = "AccountAggregatorBankDetails";
const AA_POLLING_KEY = "AccountAggregatorOfferPolling";
const ELIGIBILITY_POLLING_KEY = "EligibilityOfferPolling";
const ELIGIBILITY_OFFER_DETAILS = "EligibilityOfferDetails";
const BROWSER_FINAL_OFFER_DETAILS = "B2AFinalOffer";

const PARTNER_PRE_APPROVED_OFFER_DETAILS_KEY = "PartnerPreApprovedOfferDetails";

const OFFER_EXPIRY = "OfferExpiry";
const CREDIT_LINE_EXPIRY = "CreditLineExpiry";
const ACCOUNT_DELETED = "AccountDeleted";
const REJECTION = "Rejection";
const TOP_UP_KNOW_MORE = "TopUpKnowMore";
const OTP_UDYAM = "Udyam";
const STAND_ALONE_AA = "StandAloneAA";

Map<String, dynamic> homePageStateMap() => {
      PERSONAL_DETAILS_KEY: PersonalDetailsHomeScreenType(),
      WORK_DETAILS_KEY: GenericHomeScreenCard(),
      SBD_BASIC_DETAILS_KEY: GenericHomeScreenCard(),
      BUREAU_POLLING_KEY: OfferPollingDetailsHomeScreenType(),
      OFFER_POLLING_KEY: OfferPollingDetailsHomeScreenType(),
      OFFER_DETAILS_KEY: UpgradeOfferDetailsHomeScreenType(),
      AADHAAR_DETAILS_KEY: OfferDetailsHomeScreenType(),
      SELFIE_DETAILS_KEY: OfferDetailsHomeScreenType(),
      VKYC_DETAILS_KEY: OfferDetailsHomeScreenType(),
      LINE_AGREEMENT_KEY: GenericHomeScreenCard(),
      ESIGN: GenericHomeScreenCard(),
      BANK_DETAILS_KEY: BankDetailsHomeScreenCard(),
      KYC_POLLING_KEY: OfferDetailsHomeScreenType(),
      CREDIT_LINE_APPROVED_KEY: UpgradeOfferDetailsHomeScreenType(),
      BANK_DETAILS_POLLING_KEY: OfferDetailsHomeScreenType(),
      EMANDATE_KEY: GenericHomeScreenCard(image: Res.offerBaloons),
      EMANDATE_POLLING_KEY: GenericHomeScreenCard(),
      WITHDRAW_KEY: WithdrawalDetailsHomeScreenType(),
      AA_BANK_DETAILS_KEY: AABankDetailsHomeScreenType(),
      AA_POLLING_KEY: AABankDetailsHomeScreenType(),
      // UPL_DISBURSAL_PROGRESS_KEY: UPLWaitScreenModel(),
      UPL_DISBURSAL_COMPLETE_KEY: UplDisbursalHomeScreenType(),
      UPL_WAIT_SCREEN_KEY: UPLWaitScreenModel(),
      SBL_DISBURSA_IN_PROGRESS_KEY: UPLWaitScreenModel(),
      PARTNER_PRE_APPROVED_OFFER_DETAILS_KEY:
          UpgradeOfferDetailsHomeScreenType(),
      ELIGIBILITY_POLLING_KEY: OfferPollingDetailsHomeScreenType(),
      ELIGIBILITY_OFFER_DETAILS: EligibilityOfferDetailsHomeScreenType(),
      BROWSER_FINAL_OFFER_DETAILS: LineAgreementDetailsHomeScreenType(),
      OFFER_EXPIRY: OfferExpiryHomeScreenType(),
      CREDIT_LINE_EXPIRY: CreditLineExpiryHomeScreenType(),
      REJECTION: RejectionHomeScreenType(),
      PAUSE_LOAN_KEY: BlockHomeScreenCardType(),
      UNSERVICEABLE_LOAN_KEY: BlockHomeScreenCardType(),
      // ACCOUNT_DELETED : BlockHomeScreenCardType()
      TOP_UP_KNOW_MORE: TopUpKnowMoreCardType(),
      OTP_UDYAM: UdyamHomeScreenCard(),
      STAND_ALONE_AA: HomeAABankCard(),
    };

HomeScreenType computeHomePageModelMap(String screen) {
  return homePageStateMap()[screen];
}
