import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/feedback_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/feedback_selection_model.dart';
import 'package:privo/app/modules/app_rating/app_rating_analytics.dart';
import 'package:privo/app/modules/app_rating/app_rating_view.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';
import 'package:flutter/services.dart';

enum AppRatingType {
  poor('Poor'),
  okay('Okay'),
  good('Good'),
  average('Average'),
  excellent('Excellent'),
  none('None');

  final String value;

  const AppRatingType(this.value);

  @override
  String toString() => value;
}

enum AppRatingScreen { rateUs, experience, success }

class AppRatingLogic extends GetxController with AppRatingAnalytics {
  AppRatingType _selectedAppRating = AppRatingType.none;

  AppRatingType get selectedAppRating => _selectedAppRating;

  set selectedAppRating(AppRatingType value) {
    _selectedAppRating = value;
    update();
  }

  AppRatingScreen _appRatingScreen = AppRatingScreen.experience;

  AppRatingScreen get appRatingScreen => _appRatingScreen;

  set appRatingScreen(AppRatingScreen value) {
    _appRatingScreen = value;
    update();
  }

  bool _showFeedbackOption = false;

  bool get showFeedbackOption => _showFeedbackOption;

  set showFeedbackOption(bool value) {
    _showFeedbackOption = value;
    update();
  }

  bool _showFeedBackTextField = false;

  bool get showFeedBackTextField => _showFeedBackTextField;

  set showFeedBackTextField(bool value) {
    _showFeedBackTextField = value;
    update([feedBackSelectorKey]);
    update();
  }

  int _feedBackSelectorIndex = 0;

  int get feedBackSelectorIndex => _feedBackSelectorIndex;

  set feedBackSelectorIndex(int value) {
    _feedBackSelectorIndex = value;
    update([feedBackSelectorKey]);
    update();
  }

  TextEditingController feedbackEditingController = TextEditingController();

  String feedBackSelectorKey = 'feedback-selector';

  ///Have made feedback as list and not enum because this may keep changing from time to time
  ///as they are just a set of strings

  List<String> feedBackSelectorList = [
    "I'm having trouble making payments",
    "The app is running very slowly",
    "I don't understand my loan details in the app",
    "I'm looking for additional features in the app",
    "Others"
  ];
  List<FeedbackSuggestion> sections = [
    FeedbackSuggestion(
      header: 'Payment issues',
      items: [
        Reason(name: 'Payment didn’t go through'),
        Reason(name: 'Unable to repay EMI'),
        Reason(name: "EMI payment not reflecting"),
        Reason(name: "Overdue payment failed"),
        Reason(name: "Unable to foreclose")
      ],
    ),
    FeedbackSuggestion(
      header: 'Loan terms and details',
      items: [
        Reason(name: 'Loan terms are incorrect'),
        Reason(name: 'Loan breakdown is unclear'),
        Reason(name: 'Unable to download documents'),
      ],
    ),
    FeedbackSuggestion(
      header: 'General issues',
      items: [
        Reason(name: 'App is slow'),
        Reason(name: 'App crashes frequently'),
        Reason(name: 'Customer service was unhelpful'),
        Reason(name: "Too many notifications")
      ],
    ),
  ];

  bool get isAnyItemSelected {
    return sections
        .any((section) => section.items.any((item) => item.isChecked));
  }

  Map<String, List<String>> selectedReasons = {
    "Payment issues": [],
    "Loan terms and details": [],
    "General issues": []
  };
  void onReasonToggled({
    required String header,
    required Reason reason,
    required bool isSelected,
  }) {
    reason.isChecked = isSelected;
    if (selectedReasons[header] != null) {
      if (isSelected) {
        selectedReasons[header]?.add(reason.name);
      } else {
        selectedReasons[header]?.remove(reason.name);
      }
    }
    update([feedBackSelectorKey]);
  }

  void submitFeedback() {
    for (var entry in selectedReasons.entries) {
      final String header = entry.key;
      final List<String> reasons = entry.value;
      if (reasons.isNotEmpty) {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.whatWentWrong,
            attributeName: {
              "whatWentWrong": "${header} - ${reasons.join(" | ")}"
            });
      }
    }
    if (feedbackEditingController.text.isNotEmpty) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.whatWentWrong,
          attributeName: {"whatWentWrong": feedbackEditingController.text});
      feedbackEditingController.clear();
    }
  }

  List<AppRatingModel> appRatingModels = [];

  int CUSTOM_USER_FEEDBACK_INDEX = 4;

  onFeedBackSelectionChanged(int? selectedIndex) {
    if (selectedIndex != null) {
      feedBackSelectorIndex = selectedIndex;
      showFeedBackTextField = false;
      feedbackEditingController.clear();
    }
    if (selectedIndex == CUSTOM_USER_FEEDBACK_INDEX) {
      showFeedBackTextField = true;
    }
  }

  @override
  void onInit() {
    appRatingModels = [
      AppRatingModel(
          appRatingType: AppRatingType.poor,
          selectedIcon: Res.poor_icon_selected,
          onPressed: _showFeedbackWidget,
          title: 'Poor',
          unselectedIcon: Res.poorIcon),
      AppRatingModel(
          appRatingType: AppRatingType.average,
          selectedIcon: Res.average_selected,
          onPressed: _showFeedbackWidget,
          title: 'Average',
          unselectedIcon: Res.average_unselected),
      AppRatingModel(
          appRatingType: AppRatingType.okay,
          selectedIcon: Res.okay_selected,
          onPressed: _showFeedbackWidget,
          title: 'Okay',
          unselectedIcon: Res.okay_unselected),
      AppRatingModel(
          appRatingType: AppRatingType.good,
          selectedIcon: Res.good_selected,
          onPressed: _hideFeedBackWidget,
          title: 'Good',
          unselectedIcon: Res.good_unselected),
      AppRatingModel(
          appRatingType: AppRatingType.excellent,
          selectedIcon: Res.excellent_selected,
          onPressed: _hideFeedBackWidget,
          title: 'Excellent',
          unselectedIcon: Res.excellent_unselected)
    ];
    super.onInit();
  }

  _hideFeedBackWidget() {
    showFeedbackOption = false;
    update([feedBackSelectorKey]);
  }

  _showAppRatingSdk() {
    appRatingScreen = AppRatingScreen.rateUs;
    update([feedBackSelectorKey]);
  }

  void clearControllers() {
    showFeedbackOption = false;
    showFeedBackTextField = false;
    selectedAppRating = AppRatingType.none;
    appRatingScreen = AppRatingScreen.experience;
    feedBackSelectorIndex = 0;
  }

  _showFeedbackWidget() {
    showFeedbackOption = true;
  }

  showInAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    bool isAppRatingAvailable = await inAppReview.isAvailable();
    logPlayStoreRatingPrompted(isAppRatingAvailable);
    if (isAppRatingAvailable) {
      Get.back(result: false);
      await inAppReview.requestReview();
    }
  }

  @override
  void onReady() {
    logAppRatingPrompted();
  }

  Future<void> postUserFeedBack() async {
    logAppRatingSubmit({'rating': selectedAppRating.toString()});
    switch (selectedAppRating) {
      case AppRatingType.excellent:
      case AppRatingType.good:
        _showAppRatingSdk();
        break;
      default:
        _onPoorAppRating();
        break;
    }
  }

  void _onPoorAppRating() {
    submitFeedback();
    appRatingScreen = AppRatingScreen.success;
    update([feedBackSelectorKey]);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.thankYou);
  }

  String _computeUserFeedback() {
    if (feedBackSelectorIndex == CUSTOM_USER_FEEDBACK_INDEX) {
      return feedbackEditingController.text;
    }
    return feedBackSelectorList[feedBackSelectorIndex];
  }

  void onEmoticonTapped(AppRatingModel appRatingModel) {
    selectedAppRating = appRatingModel.appRatingType;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.selectedEmoticon,
        attributeName: {"selectedEmoticon": appRatingModel.title});
    appRatingModel.onPressed();
  }

  void onCancelClicked() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.ratingCancelClicked);
    Get.back(result: false);
    clearControllers();
  }

  void onCrossClicked() {
    Get.back(result: true);
    clearControllers();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.ratingCrossClicked);
  }

  void onRemindMeLaterClicked() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.remindMeLaterClicked);
    Get.back(result: false);
    clearControllers();
  }

  void onCopyTapped(String title) {
    Clipboard.setData(ClipboardData(text: title));
  }

  void onCloseClicked(BuildContext context) {
    logAppRatingClosed();
    Navigator.pop(context);
  }

  computeButtonEnabled() {
    if (selectedAppRating != AppRatingType.none &&
        (feedbackEditingController.text.isNotEmpty || isAnyItemSelected)) {
      return true;
    }
    if (selectedAppRating == AppRatingType.good ||
        selectedAppRating == AppRatingType.excellent) {
      return true;
    }
    return false;
  }

  void onFeedbackTextChanged(String value) {
    update();
  }
}

class AppRatingModel {
  AppRatingType appRatingType;
  String selectedIcon;
  String unselectedIcon;
  Function onPressed;
  String title;

  AppRatingModel(
      {required this.appRatingType,
      required this.selectedIcon,
      required this.unselectedIcon,
      required this.title,
      required this.onPressed});
}
