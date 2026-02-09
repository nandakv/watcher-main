import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:carousel_slider/carousel_controller.dart' as carouselSlider;
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/modules/ab_user/ab_testing_mixin.dart';
import '../../../res.dart';
import '../../api/response_model.dart';
import '../../data/provider/auth_provider.dart';
import '../../mixin/app_analytics_mixin.dart';
import '../../routes/app_pages.dart';
import '../../utils/error_logger_mixin.dart';
import '../ab_user/ab_testing_repository.dart';
import '../ab_user/ab_testing_model.dart';
import 'job_type_model.dart';
import 'non_eligible_finsights_analytics_mixin.dart';
import 'non_eligible_finsights_carousal_model.dart';

enum NonEligibleState { nonFinSightScreen, polling }

enum FinSightWaitListType {
  waitListSubmit(
    title: "Woohoo! Big things ahead",
    subTitle:
        "You've been successfully added to our waitlist.\nWe'll notify you as soon as FinSights is live!",
    buttonTitle: "Back to home",
    image: Res.waitListImage,
  ),
  waitListView(
    title: "Stay tuned! It’s worth the wait",
    subTitle:
        "We’re rolling out early access in batches. You’ll be notified as soon as it’s your turn",
    buttonTitle: "Okay",
    image: Res.waitImageTwo,
  );

  const FinSightWaitListType(
      {required this.title,
      required this.subTitle,
      required this.image,
      required this.buttonTitle});

  final String title;
  final String subTitle;
  final String image;
  final String buttonTitle;
}

enum WorkType {
  businessOwner(
    title: "I am a business owner",
    img: Res.nonEligibleGridOne,
    computeQuestions: _businessQuestions,
  ),
  salaried(
    title: "I am salaried",
    img: Res.nonEligibleGridTwo,
    computeQuestions: _salariedEmployedQuestions,
  ),
  selfEmployed(
    title: "I am self-employed",
    img: Res.nonEligibleGridThree,
    computeQuestions: _selfEmployedQuestions,
  ),
  freelancer(
    title: "I am a freelancer",
    img: Res.nonEligibleGridFour,
    computeQuestions: _freelancerQuestions,
  );

  final String title;
  final String img;
  final List<JobTypeQuestion> Function(NonEligibleFinsightLogic logic)
      computeQuestions;

  const WorkType({
    required this.title,
    required this.img,
    required this.computeQuestions,
  });
}

List<JobTypeQuestion> _salariedEmployedQuestions(NonEligibleFinsightLogic logic) =>
    logic.computeQuestions(WorkType.salaried);

List<JobTypeQuestion> _selfEmployedQuestions(NonEligibleFinsightLogic logic) =>
    logic.computeQuestions(WorkType.selfEmployed);

List<JobTypeQuestion> _freelancerQuestions(NonEligibleFinsightLogic logic) =>
    logic.computeQuestions(WorkType.freelancer);

List<JobTypeQuestion> _businessQuestions(NonEligibleFinsightLogic logic) =>
    logic.computeQuestions(WorkType.businessOwner);

enum NonEligibleFinSightsType { lightVariant, darkVariant }

class NonEligibleFinsightLogic extends GetxController
    with
        AppAnalyticsMixin,
        NonEligibleFinSightsAnalyticsMixin,
        ErrorLoggerMixin,
        ApiErrorMixin,AbTestingMixin {
  final NON_FINSIGHTS_PAGE_INDICATOR = "NON_FINSIGHTS_PAGE_INDICATOR";
  final NON_FINSIGHTS_PAGE_INDICATOR_DARK = "NON_FINSIGHTS_PAGE_INDICATOR_DARK";
  final String HINT_TEXT = "HINT_TEXT";
  final String BUSINESS_INFO = "BUSINESS_INFO";
  final String JOIN_NOW_BUTTON = "JOIN_NOW_BUTTON";
  final String BUSINESS_SELECTION_ID = "business_selection_id";
  final String NON_FINSIGHT_SCREEN = 'NON_FINSIGHT_SCREEN';

  final nonEligibleFinSightsPageController =
      carouselSlider.CarouselSliderController();

  String? businessAge;
  String? businessRevenue;
  String? expenseTracking;
  String? annualRevenue;

  NonEligibleState _nonEligibleState = NonEligibleState.nonFinSightScreen;

  NonEligibleState get nonEligibleState => _nonEligibleState;

  set nonEligibleState(NonEligibleState value) {
    _nonEligibleState = value;
    update();
  }

  WorkType? selectedJobTypeEnum;

  String? selectedType;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    update([NON_FINSIGHTS_PAGE_INDICATOR]);
  }

  int _currentIndexDark = 0;

  int get currentIndexDark => _currentIndexDark;

  set currentIndexDark(int value) {
    _currentIndexDark = value;
    update([NON_FINSIGHTS_PAGE_INDICATOR_DARK]);
  }

  String _radioGroupValue = "";

  String get radioGroupValue => _radioGroupValue;

  set radioGroupValue(String value) {
    _radioGroupValue = value;
    update([BUSINESS_SELECTION_ID, HINT_TEXT, BUSINESS_INFO]);
  }

  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
  }

  //carousal list
  List<NonEligibleFinsightsCarousalModel> carouselSlides = [
    NonEligibleFinsightsCarousalModel(
        img: Res.nonEligibleFinSights_one,
        title: 'View your bank accounts in one place'),
    NonEligibleFinsightsCarousalModel(
        img: Res.nonEligibleFinSights_two,
        title: 'Know your EMIs before they’re due'),
    NonEligibleFinsightsCarousalModel(
        img: Res.nonEligibleFinSights_three,
        title: 'See where your money goes'),
  ];

//jobType List
  List<NonEligibleFinsightsCarousalModel> jobTypeList = [
    NonEligibleFinsightsCarousalModel(
        img: Res.nonEligibleGridOne, title: 'I am a business owner'),
    NonEligibleFinsightsCarousalModel(
        img: Res.nonEligibleGridTwo, title: 'I am salaried '),
    NonEligibleFinsightsCarousalModel(
        img: Res.nonEligibleGridThree, title: 'I am self-employed'),
    NonEligibleFinsightsCarousalModel(
        img: Res.nonEligibleGridFour, title: 'I am a freelancer'),
  ];

  List<String> expenseTrackingList = [
    "Notebook/Excel sheets",
    "Bank statements",
    "Personal finance apps",
    "UPI & wallet apps",
    "SMS alerts"
  ];

  List<String> annualBusinessRevenueList = [
    "Less than 25 lacs",
    "25-50 lacs",
    "50-75 lacs",
    "75 lacs- 1 cr",
    "More than 1 cr"
  ];

  List<String> businessAgeList = [
    "Less than a year",
    "1-2 years",
    "2-4 years",
    "4-6 years",
    "More than 6 years"
  ];

  List<String> annualRevenueList = [
    "Less than 20 lacs",
    "20-30 lacs",
    "30-40 lacs",
    "40-50 lacs",
    "More than 50 lacs"
  ];

  void onTapGrid(WorkType jobType) {
    _computeJobTypeEvent(jobType);
    _clearFormInputs();
    selectedType = jobType.title;
    selectedJobTypeEnum = jobType;
    update(["grid_id", "questions", JOIN_NOW_BUTTON]);
  }

  void _computeJobTypeEvent(WorkType jobType) {
    final Map<WorkType, void Function()> jobTypeLoggers = {
      WorkType.businessOwner: () =>
          logfinsightsBusinessOwnerClickedNEF(assignedGroup: assignedGroup),
      WorkType.salaried: () =>
          logfinsightsSalariedClickedNEF(assignedGroup: assignedGroup),
      WorkType.selfEmployed: () =>
          logfinSightsSelfEmpClickedNEF(assignedGroup: assignedGroup),
      WorkType.freelancer: () =>
          logFinsightsFreelanceClickedNEF(assignedGroup: assignedGroup),
    };

    jobTypeLoggers[jobType]?.call();
  }

  bool get isFormComplete {
    return _shouldEnableJoinNowButton();
  }

  _shouldEnableJoinNowButton() {
    if (selectedType != null) {
      switch (selectedType) {
        case 'I am a business owner':
          return businessAge != null &&
              businessRevenue != null &&
              expenseTracking != null;
        case 'I am salaried':
        case 'I am self-employed':
        case 'I am a freelancer':
          return annualRevenue != null && expenseTracking != null;
        default:
          return true;
      }
    } else {
      return false;
    }
  }

  void _clearFormInputs() {
    businessAge = null;
    businessRevenue = null;
    expenseTracking = null;
    annualRevenue = null;
    update([HINT_TEXT, BUSINESS_INFO, JOIN_NOW_BUTTON]);
  }

  void updateUI() {
    update([
      HINT_TEXT,
      BUSINESS_INFO,
      JOIN_NOW_BUTTON,
    ]);
  }

  List<List<NonEligibleFinsightsCarousalModel>> carouselSlidesDark = [
    [
      NonEligibleFinsightsCarousalModel(
        img: Res.coinBank,
        title: "Know your EMIs\nbefore they’re due",
      ),
      NonEligibleFinsightsCarousalModel(
        img: Res.coinFinance,
        title: "Unlock better credit\noffers with ease",
      ),
    ],
    [
      NonEligibleFinsightsCarousalModel(
        img: Res.coinBank,
        title: "View all your bank\naccounts in one place",
      ),
      NonEligibleFinsightsCarousalModel(
        img: Res.coinFinance,
        title: "See where your\nmoney is being spent",
      ),
    ]
  ];

  List<JobTypeQuestion> computeQuestions(WorkType type) {
    switch (type) {
      case WorkType.businessOwner:
        return [
          JobTypeQuestion(
            label: 'How old is your business?',
            hint: 'Choose the range',
            img: Res.calenderToday,
            title: 'Business age',
            subTitle: "Select the most relevant option",
            options: businessAgeList,
            selectedValue: businessAge ?? "",
            onChanged: (value) {
              businessAge = value!;
              logfinsightsQBusinessAgeSelectedNEF(
                  value: businessAge!,
                  assignedGroup: assignedGroup);
              update(['questions']);
            },
          ),
          JobTypeQuestion(
            label: 'What’s your annual business revenue?',
            hint: 'Choose the range',
            img: Res.payments,
            title: 'Annual business revenue',
            subTitle: "Select the most relevant option",
            options: annualBusinessRevenueList,
            selectedValue: businessRevenue ?? "",
            onChanged: (value) {
              businessRevenue = value!;
              logfinsightsQPerIncomeSelectedNEF(
                  value: businessRevenue!,
                  assignedGroup: assignedGroup);
              update(['questions']);
            },
          ),
          JobTypeQuestion(
            label: 'How do you track your expenses?',
            hint: 'Choose from the options',
            img: Res.receiptLong,
            title: 'Expense tracking',
            subTitle: "Select the most relevant option",
            options: expenseTrackingList,
            selectedValue: expenseTracking ?? "",
            onChanged: (value) {
              expenseTracking = value!;
              logfinsightsQTrackExpernseSelectedNEF(
                  value: expenseTracking!,
                  assignedGroup: assignedGroup);
              update(['questions']);
            },
          ),
        ];
      case WorkType.salaried:
      case WorkType.selfEmployed:
      case WorkType.freelancer:
        return [
          JobTypeQuestion(
            label: 'How do you track your expenses?',
            hint: 'Choose from the options',
            img: Res.calenderToday,
            title: 'Expense tracking',
            subTitle: "Select the most relevant option",
            options: expenseTrackingList,
            selectedValue: expenseTracking ?? "",
            onChanged: (value) {
              expenseTracking = value!;
              logfinsightsQTrackExpernseSelectedNEF(
                  value: expenseTracking!, assignedGroup: assignedGroup);
              update(['questions']);
            },
          ),
          JobTypeQuestion(
            label: 'What’s your annual income?',
            hint: 'Choose the range',
            img: Res.payments,
            title: 'Annual income',
            subTitle: "Select the most relevant option",
            options: annualRevenueList,
            selectedValue: annualRevenue ?? "",
            onChanged: (value) {
              annualRevenue = value!;
              logfinsightsQPerIncomeSelectedNEF(
                  value: annualRevenue!, assignedGroup: assignedGroup);
              update(['questions']);
            },
          ),
        ];
      case WorkType.salaried:
        return [];
    }
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update([JOIN_NOW_BUTTON]);
  }

  Future<void> onTapJoinNow() async {
    isLoading = true;
    nonEligibleState = NonEligibleState.polling;
    isLoading = false;
    await Future.delayed(const Duration(seconds: 3));
    Get.toNamed(Routes.FINSIGHT_WAIT_LIST_SCREEN, arguments: {
      "waitlist": FinSightWaitListType.waitListSubmit,
    });

    loggetEarlyAccessClicked(
        employment: selectedType ?? "",
        age: businessAge ?? "",
        income: expenseTracking ?? "",
        turnOver: annualRevenue ?? "",
        assignedGroup: assignedGroup); // in progress
    AppAuthProvider.setFinsightsWaitList();
    logsucessfullyJoinedWLLoaded(
        assignedGroup: assignedGroup);
  }

  void loadAbTest({required String expName}) {
    computeAndFetchAbTesting(
      expName: expName,
      onSuccess: (assignedGroup) {
        isPageLoading = false;
        computeNonFinSightVariant(assignedGroup: assignedGroup);
        logFinSightsMotivationLoadedNEF(assignedGroup: assignedGroup);
      },
      onFailure: (response) {
        handleAPIError(
          response,
          screenName: NON_FINSIGHT_SCREEN,
          retry: loadAbTest,
        );
      },
    );
  }

  NonEligibleFinSightsType variantName = NonEligibleFinSightsType.lightVariant;

  void computeNonFinSightVariant({String assignedGroup = ""}) {
    switch (assignedGroup) {
      case "intro_screen_2":
        variantName = NonEligibleFinSightsType.lightVariant;
        break;
      default:
        variantName = NonEligibleFinSightsType.darkVariant;
        break;
    }
  }

  late String experimentName;

  Future<void> afterLayout() async {
    isPageLoading = true;
    var arguments = Get.arguments;
    experimentName = arguments['experiment_name'] ?? '';
    loadAbTest(expName: experimentName);
  }

  void onCarouselPageChange(int index) {
    logFinSightsMotivationClickedCarouselNEF(carouselSlides[index].title);
    currentIndex = index;
  }
}

class DarkCarouselItemModel {
  final List<NonEligibleFinsightsCarousalModel> items;

  DarkCarouselItemModel({required this.items});
}
