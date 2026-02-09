import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/arguments_model/faq_help_support_arguments.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/delete_account_model.dart';
import 'package:privo/app/models/delete_eligible_model.dart';
import 'package:privo/app/modules/faq_help_support/widgets/delete_request_success_sheet.dart';
import 'package:privo/app/modules/faq_help_support/widgets/delete_warning_sheet.dart';
import 'package:privo/app/modules/report_issue/report_issue_analytics_mixin.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../api/api_error_mixin.dart';
import '../../api/response_model.dart';
import '../../data/repository/help_and_support_repository.dart';
import '../../models/faq_model.dart';
import '../../models/faq_url_model.dart';
import '../help_support/widget/contact_us_card.dart';
import '../on_boarding/analytics/faq_help_and_support_analytics_mixin.dart';
import '../on_boarding/mixins/app_form_mixin.dart';
import '../report_issue/report_issue_widget.dart';
import 'widgets/delete_restricted_sheet.dart';

enum HelpAndSupportPageState {
  loading,
  category,
  subCategory,
  faqList,
  faqDetails,
  deleteRequest
}

class FAQHelpSupportLogic extends GetxController
    with
        ApiErrorMixin,
        AppFormMixin,
        FAQHelpAndSupportAnalyticsMixin,
        ErrorLoggerMixin,
        ReportIssueAnalyticsMixin {
  FAQCategories? selectedFaqCategory;
  FAQSubCategories? selectedFaqSubCategory;
  FAQQueries? selectedFaqQuery;
  List<FAQQueries> currentQueries = [];

  late String faqHelpAndSupport = "faq_help_and_support";
  late final String RAISE_AN_ISSUE_ID = "RAISE_AN_ISSUE_ID";

  late FAQModel faqs;

  HelpAndSupportRepository helpAndSupportRepository =
      HelpAndSupportRepository();

  HelpAndSupportPageState _helpAndSupportPageState =
      HelpAndSupportPageState.loading;

  TextEditingController reasonController = TextEditingController();

  TextEditingController reasonDescriptionController = TextEditingController();

  HelpAndSupportPageState get helpAndSupportPageState =>
      _helpAndSupportPageState;

  set helpAndSupportPageState(HelpAndSupportPageState value) {
    _helpAndSupportPageState = value;
    update();
  }

  bool _isReportIssueEnabled = false;

  bool get isReportIssueEnabled => _isReportIssueEnabled;

  set isReportIssueEnabled(bool value) {
    _isReportIssueEnabled = value;
    update([RAISE_AN_ISSUE_ID]);
  }

  bool fromHomeScreen = false;

  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  set isEnabled(bool value) {
    _isEnabled = value;
    update();
  }

  bool navigateToHelpAndSupport = false;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  List<String> deleteReasonList = [
    "Loan is paid",
    "Privacy concerns",
    "I no longer need Privo Instant Loan",
    "Better offer elsewhere",
    "Other"
  ];

  final FAQHelpSupportArguments arguments = Get.arguments;

  @override
  void onInit() {
    navigateToHelpAndSupport = false;
    _getFaqUrl(lpcCard: arguments.lpcCard);
    logHelpSupportClicked(arguments.isFromSupportMenu);
    _checkReportIssueEnabled();
    super.onInit();
  }

  _checkReportIssueEnabled() async {
    isReportIssueEnabled = await AppAuthProvider.isReportIssueEnabled;
  }

  _getFaqUrl({required LpcCard lpcCard}) async {
    /// Currently faq is enabled for clp only
    FAQUrlModel faqUrlModel = await helpAndSupportRepository.getFaqUrl(
      lpcCard.loanProductCode,
    );
    switch (faqUrlModel.apiResponse.state) {
      case ResponseState.success:
        _getFaqs(faqUrlModel.url);
        break;
      default:
        logError(
          exception: faqUrlModel.apiResponse.exception,
          url: faqUrlModel.apiResponse.url,
          requestBody: faqUrlModel.apiResponse.requestBody,
          responseBody: faqUrlModel.apiResponse.apiResponse,
          statusCode: "${faqUrlModel.apiResponse.statusCode}",
        );
        await Get.offNamed(Routes.HELP_AND_SUPPORT,
            arguments: {'isFromHomePage': arguments.isFromHomePage});
    }
  }

  void _getFaqs(String url) async {
    FAQModel faqModel = await helpAndSupportRepository.getFaqs(url);
    switch (faqModel.apiResponse.state) {
      case ResponseState.success:
        faqs = faqModel;
        helpAndSupportPageState = HelpAndSupportPageState.category;
        logCategoryScreenLoaded();
        break;
      default:
        logError(
          exception: faqModel.apiResponse.exception,
          url: faqModel.apiResponse.url,
          requestBody: faqModel.apiResponse.requestBody,
          responseBody: faqModel.apiResponse.apiResponse,
          statusCode: "${faqModel.apiResponse.statusCode}",
        );
        await Get.offNamed(Routes.HELP_AND_SUPPORT,
            arguments: {'isFromHomePage': arguments.isFromHomePage});
    }
  }

  Future<bool> onBackPressed() async {
    switch (helpAndSupportPageState) {
      case HelpAndSupportPageState.loading:
        Get.back();
        break;
      case HelpAndSupportPageState.category:
        logCategoryScreenClosed();
        Get.back();
        break;
      case HelpAndSupportPageState.subCategory:
        selectedFaqCategory = null;
        helpAndSupportPageState = HelpAndSupportPageState.category;
        break;
      case HelpAndSupportPageState.faqList:
        currentQueries = [];
        if (selectedFaqSubCategory == null) {
          helpAndSupportPageState = HelpAndSupportPageState.category;
        } else {
          helpAndSupportPageState = HelpAndSupportPageState.subCategory;
        }
        selectedFaqSubCategory = null;
        break;
      case HelpAndSupportPageState.faqDetails:
        if (navigateToHelpAndSupport) {
          Get.back();
        } else {
          helpAndSupportPageState = HelpAndSupportPageState.faqList;
        }
        break;
      case HelpAndSupportPageState.deleteRequest:
        helpAndSupportPageState = HelpAndSupportPageState.faqDetails;
        break;
    }
    return false;
  }

  computeAppBarTitle() {
    switch (helpAndSupportPageState) {
      case HelpAndSupportPageState.loading:
      case HelpAndSupportPageState.category:
        return "Help and Support";
      case HelpAndSupportPageState.subCategory:
      case HelpAndSupportPageState.faqList:
      case HelpAndSupportPageState.faqDetails:
        return "Frequently Asked Questions";
      case HelpAndSupportPageState.deleteRequest:
        return "Delete Request";
    }
  }

  onRaiseIssueTapped() {
    logRaiseIssueFAQSupportCardClicked();
    Get.bottomSheet(
      ReportIssueWidget(
        screenName: faqHelpAndSupport,
        errorLog: "",
        fromHomeScreen: fromHomeScreen,
      ),
      enableDrag: false,
      isScrollControlled: true,
    );
    logDescribeIssueCardLoaded("raise_issue_faq_support_card");
  }

  String computeAppBarSubTitle() {
    switch (helpAndSupportPageState) {
      case HelpAndSupportPageState.loading:
      case HelpAndSupportPageState.deleteRequest:
      case HelpAndSupportPageState.category:
        return "";
      case HelpAndSupportPageState.subCategory:
      case HelpAndSupportPageState.faqList:
        if (selectedFaqSubCategory == null) {
          return selectedFaqCategory!.categoryTitle;
        }
        return "${selectedFaqCategory!.categoryTitle}   •   ${selectedFaqSubCategory!.subCategoryTitle}";
      case HelpAndSupportPageState.faqDetails:
        return "Application";
    }
  }

  onFaqCategoryTapped(FAQCategories faqCategory) {
    selectedFaqCategory = faqCategory;

    if (faqCategory.subCategories.isNotEmpty) {
      logSubCategoryScreenLoaded(selectedFaqCategory!.categoryTitle);
      helpAndSupportPageState = HelpAndSupportPageState.subCategory;
    } else if (faqCategory.queries.isNotEmpty) {
      logQAListLoaded(
        categoryName: faqCategory.categoryTitle,
        subCategoryName: "NA",
      );
      currentQueries = faqCategory.queries;
      helpAndSupportPageState = HelpAndSupportPageState.faqList;
    }
  }

  onFaqSubCategoryTapped(FAQSubCategories faqSubCategory) {
    selectedFaqSubCategory = faqSubCategory;
    logSubCategoryClicked(selectedFaqSubCategory!.subCategoryTitle);
    logQAListLoaded(
      categoryName: selectedFaqCategory?.categoryTitle ?? "NA",
      subCategoryName: faqSubCategory.subCategoryTitle,
    );
    currentQueries = faqSubCategory.queries;
    helpAndSupportPageState = HelpAndSupportPageState.faqList;
  }

  onContactUs() async {
    logContactPrivoClicked();
    await Get.bottomSheet(
      ContactUsCard(
        onCallClicked: onContactDetailsClicked,
        onEmailClicked: onEmailClicked,
      ),
    );
    logContactPrivoClosed();
  }

  onContactDetailsClicked() {
    logContactPrivoEmailNumber("number");
    launchUrlString('tel:18001038961', mode: LaunchMode.externalApplication);
  }

  onEmailClicked() {
    logContactPrivoEmailNumber("email");
    launchUrlString("mailto:support@creditsaison-in.com");
  }

  onQueryCLicked(bool isExpanded, int index) {
    if (checkIfAccountDeletedTapped() && index == 0) {
      selectedFaqQuery = currentQueries[index];
      helpAndSupportPageState = HelpAndSupportPageState.faqDetails;
    }
    if (isExpanded) {
      logQAListClicked(index);
    }
  }

  checkIfAccountDeletedTapped() {
    Get.log(
        "Selected sub category ${selectedFaqSubCategory?.subCategoryTitle}");
    if (selectedFaqSubCategory?.subCategoryTitle.toLowerCase() ==
        "Account Deletion".toLowerCase()) {
      Get.log(
          "Selected sub category ${selectedFaqSubCategory?.subCategoryTitle}");
      return true;
    }
    return false;
  }

  void onRequestForDeletionClicked() async {
    helpAndSupportPageState = HelpAndSupportPageState.loading;
    DeleteEligibleModel deleteEligibleModel =
        await helpAndSupportRepository.checkIfEligibleForDeletion();
    switch (deleteEligibleModel.apiResponse.state) {
      case ResponseState.success:
        await _onDeleteEligibleSuccess(deleteEligibleModel);
        break;
      default:
        handleAPIError(deleteEligibleModel.apiResponse,
            screenName: faqHelpAndSupport, retry: onRequestForDeletionClicked);
        break;
    }
  }

  Future<void> _onDeleteEligibleSuccess(
      DeleteEligibleModel deleteEligibleModel) async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.requestDeletionCta,
        attributeName: {
          'eligible': deleteEligibleModel.isAllowedtoDelete,
          'lpc': await AppAuthProvider.getLpc
        });
    if (deleteEligibleModel.isAllowedtoDelete) {
      helpAndSupportPageState = HelpAndSupportPageState.deleteRequest;
    } else {
      helpAndSupportPageState = HelpAndSupportPageState.faqDetails;
      await Get.bottomSheet(
          DeleteRestrictedSheet(message: deleteEligibleModel.message),
          isDismissible: false);
    }
  }

  computeAllowRequestForDeletion() {
    if (selectedFaqQuery != null &&
        selectedFaqQuery!.question
            .contains("How do I delete my Credit Saison India account?")) {
      return true;
    }
    return false;
  }

  String? validateReason(String? value) {}

  void onTapReasonField() async {
    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: 'Purpose',
        radioValues: deleteReasonList,
        initialValue: reasonController.text,
      ),
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
    );
    if (result != null) {
      await _onReasonSelected(result);
    }
  }

  Future<void> _onReasonSelected(result) async {
    Get.log("result - $result");
    reasonController.text = result;
    isEnabled = true;
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.reasonForDeletion,
      attributeName: {
        'reason': reasonController.text,
        'lpc': await AppAuthProvider.getLpc
      },
    );
  }

  onAccountDeletionSubmitPressed() async {
    Get.focusScope?.unfocus();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.deletionSubmitCta,
        attributeName: {
          'lpc': await AppAuthProvider.getLpc,
          'description': reasonDescriptionController.text,
        });
    var result =
        await Get.bottomSheet(DeleteWarningSheet(), isDismissible: false);
    if (result != null && result) {
      await _postUserDeletionRequest();
    }
  }

  Future<void> _postUserDeletionRequest() async {
    isLoading = true;
    DeleteAccountModel deleteAccountModel =
        await helpAndSupportRepository.postUserDeletionRequest();
    switch (deleteAccountModel.apiResponse.state) {
      case ResponseState.success:
        isLoading = false;
        await _postUserDeletionRequestSuccess();
        break;
      default:
        isLoading = false;
        handleAPIError(deleteAccountModel.apiResponse,
            screenName: faqHelpAndSupport,
            retry: onAccountDeletionSubmitPressed);
    }
  }

  Future<void> _postUserDeletionRequestSuccess() async {
    ///ToDo: add api call once backend has deployed
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.deleteRequstSubmit,
        attributeName: {
          'lpc': await AppAuthProvider.getLpc,
        });
    await Get.bottomSheet(
      DeleteRequestSuccessSheet(
        reason: reasonController.text,
      ),
      isDismissible: false,
    );
    reasonDescriptionController.clear();
    reasonController.clear();
    isEnabled = false;
    Get.offNamed(Routes.HOME_SCREEN);
  }

  void onAccountDeletionCancelClicked() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.deletionCancelCta,
        attributeName: {
          'lpc': await AppAuthProvider.getLpc,
        });
    reasonDescriptionController.clear();
    reasonController.clear();
    isEnabled = false;
    helpAndSupportPageState = HelpAndSupportPageState.faqDetails;
  }
}
