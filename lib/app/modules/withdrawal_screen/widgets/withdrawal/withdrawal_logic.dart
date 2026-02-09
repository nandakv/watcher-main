import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/withdrawal_calculation_model.dart';
import 'package:privo/app/models/withdrawal_status_model.dart';
import 'package:privo/app/models/withdrawal_tenure_response_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/cross_sell_breakdown_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_Model.dart';
import 'package:privo/app/modules/withdrawal_screen/helpers/clp_withdrawal_helper.dart';
import 'package:privo/app/modules/withdrawal_screen/helpers/flexiod_withdrawal_helper.dart';
import 'package:privo/app/modules/withdrawal_screen/mixins/withdrawal_api_mixin.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_navigation.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_screen_logic.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';

enum WithdrawalAmountStatusType {
  ///Changed to amount status type as we are basically validating the amount
  belowMinLimit,
  aboveMinLimit,
  amountNotInRange,
  nonMultipleAmount,
  amountMoreThanAvailableLimit,

  ///When amount is not in multiples of 1000
  validAmount,
  amountNotEntered
}

enum TenureType { defaultTenure, recommendedTenure, customTenure }

class WithdrawalLogic extends GetxController
    with ApiErrorMixin, WithdrawalApiMixin {
  final loanAmountFormKey = GlobalKey<FormState>();

  final String INSURANCE_CONTAINER_ID = 'insurance_container_id';

  final String LOAN_AMOUNT_SLIDER_ID = 'loan_amount_slider_id';
  final String LOAN_AMOUNT_TEXTFIELD_ID = 'loan_amount_text_field_id';
  final String LOAN_AMOUNT_ERROR_TEXT_ID = 'loan_amount_error_text_id';
  final String OTHER_PURPOSE_TEXT_FIELD_ID = 'other_purpose_text_field_id';
  final String BANK_DETAILS_EXPANSION_ID = 'bank_detials_expansion_id';

  final String PURPOSE_OTHERS = "Other";

  late final String PURPOSE_TEXT_FIELD = "PURPOSE_TEXT_FIELD";
  bool hideSlider = true;

  double _loanAmountSliderValue = 0.0;

  late final String PURPOSE_TEXT_FIELD_ID = "PURPOSE_TEXT_FIELD_ID";

  double get loanAmountSliderValue => _loanAmountSliderValue;

  set loanAmountSliderValue(double value) {
    _loanAmountSliderValue = value.round().toDouble();
    update([LOAN_AMOUNT_SLIDER_ID, LOAN_AMOUNT_TEXTFIELD_ID]);
  }

  int recomendedTenure = 0;
  int defaultTenure = 0;

  String _loanAmountErrorText = "";

  String get loanAmountErrorText => _loanAmountErrorText;

  set loanAmountErrorText(String value) {
    _loanAmountErrorText = value;
    update([LOAN_AMOUNT_ERROR_TEXT_ID]);
  }

  late String WITHDRAWAL_SCREEN = "withdrawal";

  bool _showOtherPurposeTextField = false;

  bool get showOtherPurposeTextField => _showOtherPurposeTextField;

  set showOtherPurposeTextField(bool value) {
    _showOtherPurposeTextField = value;
    update([OTHER_PURPOSE_TEXT_FIELD_ID]);
  }

  final otherPurposeTextController = TextEditingController();

  final int TEN_K_THREEHUNDRED = 10300;
  final int TEN_K_ONE_HUNDRED = 11000;
  final int TEN_THOUSAND = 10000;
  final int THREE_THOUSAND = 3000;

  final Map<String, Map<String, dynamic>> _withdrawalResponseCache = {};

  TenureType _selectedTenureType = TenureType.recommendedTenure;

  TenureType get selectedTenureType => _selectedTenureType;

  set selectedTenureType(TenureType value) {
    _selectedTenureType = value;
    update();
  }

  List<int> tenureRange = [];

  int TWO_LAKHS = 200000;

  bool _isCallingApi = false;

  bool get isCallingApi => _isCallingApi;

  set isCallingApi(bool value) {
    _isCallingApi = value;
    update([
      tenureSliderId,
      'amount_slider',
      withdrawalButtonId,
      LOAN_AMOUNT_TEXTFIELD_ID,
      LOAN_AMOUNT_SLIDER_ID,
    ]);
  }

  Map<double, double> threeMonthMap = {};

  Map<double, double> sixMonthMap = {};

  final int threeMonthInterval = 3;
  final int sixMonthInterval = 6;

  final purposeFormKey = GlobalKey<FormState>();

  RegExp alphaNumericRegex = RegExp(r'^[a-zA-Z0-9 ]+$');

  ///Getbuilder id's
  String withdrawalPaymentContainerId = 'withdrawal_container';
  String withdrawalButtonId = 'withdrawal-button-id';

  ///formerly withdrawal-details-id
  String withdrawalDetailsView = 'withdrawal-details-view';
  String purposeSelectorId = 'purpose-selector';
  String tenureTextId = 'tenure_text';
  String tenureSliderId = 'tenure_slider';

  Timer? _debounce;

  WithdrawalState _withdrawalState = WithdrawalState.loading;

  WithdrawalState get withdrawalState => _withdrawalState;

  set withdrawalState(WithdrawalState value) {
    _withdrawalState = value;
    _toggleLoading(value);
  }

  void _toggleLoading(WithdrawalState value) {
    if (withdrawalNavigation != null) {
      withdrawalNavigation!.toggleWithdrawalLoading(
          isWithdrawalLoading: value == WithdrawalState.loading);
    } else {
      onNavigationDetailsNull("WITHDRAWAL_LOGIC");
    }
  }

  TextEditingController loanAmountTextController = TextEditingController();
  TextEditingController purposeController = TextEditingController();

  bool isWithdrawalDetailsFormFilled = false;

  int tenureInterval = 3;

  bool _isPaymentDetailsLoading = true;

  bool get isPaymentDetailsLoading => _isPaymentDetailsLoading;

  set isPaymentDetailsLoading(bool value) {
    _isPaymentDetailsLoading = value;

    update();
  }

  WithdrawalNavigation? withdrawalNavigation;

  int tenureSliderValue = 0;

  int customTenureSliderValue = 0;

  WithdrawalCalculationModel? withdrawalCalculationModel;

  ///Withdrawal Insurance
  bool isInsuranceChecked = false;
  final String NET_DISBURSAL_ID = 'net_disbursal_id';

  double _netDisbursalAmount = 0;

  double get netDisbursalAmount => _netDisbursalAmount;

  set netDisbursalAmount(double value) {
    _netDisbursalAmount = value;
    update([NET_DISBURSAL_ID]);
  }

  computeNetDisbursalAmount(bool isInsuranceChecked) async {
    this.isInsuranceChecked = isInsuranceChecked;
    if (withdrawalCalculationModel != null) {
      Get.log("toggled insurance");
      await getWithdrawalCalculations(
        key: '$loanAmountSliderValue,$tenureSliderValue',
        isAmountChanged: true,
      );
      // if (isInsuranceChecked) {
      //   netDisbursalAmount = withdrawalCalculationModel!.disbursedAmount! -
      //       withdrawalCalculationModel!
      //           .insuranceWrapperResponse!.first.totalPremium;
      // } else {
      //   netDisbursalAmount = withdrawalCalculationModel!.disbursedAmount!;
      // }
    }
  }

  List<String> purposeList = [];

  late WithdrawalDetailsHomeScreenType withdrawalDetailsHomePageModel;

  WithdrawalRequestState withdrawalRequestState = WithdrawalRequestState.none;

  double get availableLimit =>
      withdrawalDetailsHomePageModel.totalLimit -
      (withdrawalDetailsHomePageModel.totalLimit -
          withdrawalDetailsHomePageModel.availableLimit);

  bool _showTenureSlider = false;

  bool get showTenureSlider => _showTenureSlider;

  set showTenureSlider(bool value) {
    _showTenureSlider = value;
    update([withdrawalDetailsView]);
  }

  bool _bankDetailsLoading = false;

  bool get bankDetailsLoading => _bankDetailsLoading;

  set bankDetailsLoading(bool value) {
    _bankDetailsLoading = value;
    update([BANK_DETAILS_EXPANSION_ID, withdrawalDetailsView]);
  }

  String usedLimit = "0";

  String percentageSymbol = "%";

  String rupeeSymbol = "₹";

  String accountNumber = '';
  String bankName = '';

  bool _isAccountDetailsExpanded = false;

  bool get isAccountDetailsExpanded => _isAccountDetailsExpanded;

  set isAccountDetailsExpanded(bool value) {
    _isAccountDetailsExpanded = value;
    update([BANK_DETAILS_EXPANSION_ID]);
  }

  final String processingFeeText =
      "The amount paid by the borrower to the lender for processing a loan application.GST of 18% is applicable on loan processing charges";

  WithdrawalLogic({this.withdrawalNavigation});

  void onAfterLayout() async {
    withdrawalState = WithdrawalState.loading;
    isInsuranceChecked = true;
    tenureSliderValue = withdrawalDetailsHomePageModel.minTenure;
    loanAmountSliderValue = _roundToNearThousand(availableLimit);
    loanAmountTextController.text = AppFunctions().parseIntoCommaFormat(
      loanAmountSliderValue.toInt().toString().replaceAll(',', ''),
    );
    loanAmountTextController.selection =
        TextSelection.collapsed(offset: loanAmountTextController.text.length);
    await getListOfPurposes();
    setWithdrawalData();
  }

  bool _isDiscountValid() {
    if (withdrawalCalculationModel != null &&
        withdrawalCalculationModel!.processingFee !=
            withdrawalCalculationModel!.discountedProcessingFee) {
      return true;
    }
    return false;
  }

  bool isDiscountedProcessingFee() {
    return withdrawalCalculationModel?.discountedProcessingFee != null
        ? true
        : false;
  }

  onLoanAmountChangeEnd(double loanAmount, {bool callApi = true}) async {
    Get.log("onLoanAmountChangeEnd triggered - $loanAmount");
    loanAmountSliderValue = loanAmount;
    await _onLoanAmountValidated(callApi);
  }

  Future<void> _onLoanAmountValidated(bool callApi) async {
    if (callApi) {
      showTenureSlider = false;
      await getListOfPurposes();
    }
  }

  onWithdrawalDetailsChange() async {
    if (loanAmountFormKey.currentState!.validate() &&
        purposeFormKey.currentState!.validate()) {
      onLoanAmountTextChanged(loanAmountTextController.text);
    } else {
      isWithdrawalDetailsFormFilled = false;
      update([withdrawalButtonId]);
    }
  }

  checkTenureIntervalBasedOnAmount() {
    if (loanAmountSliderValue < TWO_LAKHS) {
      tenureInterval = threeMonthInterval;
    } else if (loanAmountSliderValue > TWO_LAKHS) {
      tenureInterval = sixMonthInterval;
    }
  }

  getWithdrawalCalculations(
      {required String key, bool isAmountChanged = false}) async {
    Get.focusScope!.unfocus();
    isCallingApi = true;
    isPaymentDetailsLoading = true;

    _updateWithdrawalScreen();

    if (_withdrawalResponseCache.containsKey(key)) {
      _onWithdrawalCacheAvailable(key);
    } else {
      bool isSuccess = await _onWithdrawalCacheNotAvailable(
          makeAllApiCallsForTenure: isAmountChanged);
      if (!isSuccess) return;
      _computeWithdrawalButton();
    }

    // _computeInsuranceAndNetDisbursalAmount();

    if (withdrawalCalculationModel != null) {
      if (withdrawalCalculationModel!.insuranceDetails == null) {
        isInsuranceChecked = false;
      }

      netDisbursalAmount = withdrawalCalculationModel!.disbursedAmount!;

      isCallingApi = false;
      isPaymentDetailsLoading = false;
      withdrawalState = WithdrawalState.success;
      _updateWithdrawalScreen();
      update([withdrawalPaymentContainerId]);
    } else {
      handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          url: "",
          requestBody: "",
          statusCode: 0,
          exception: "withdrawalCalculationModel is null",
        ),
        screenName: WITHDRAWAL_SCREEN,
      );
    }
  }

  void _computeInsuranceAndNetDisbursalAmount() {
    if (withdrawalCalculationModel != null) {
      if (withdrawalCalculationModel!.insuranceWrapperResponse != null) {
        computeNetDisbursalAmount(isInsuranceChecked);
      } else {
        isInsuranceChecked = false;
        netDisbursalAmount = withdrawalCalculationModel!.disbursedAmount!;
      }
    }
  }

  getWithdrawalCacheFromKey({required String key}) async {
    if (_withdrawalResponseCache.containsKey(key)) {
      isPaymentDetailsLoading = false;
      withdrawalState = WithdrawalState.success;
      return WithdrawalCalculationModel.fromJson(
          _withdrawalResponseCache[key]!);
    } else {
      await _onWithdrawalCacheNotAvailable();
    }
  }

  Future<bool> _onWithdrawalCacheNotAvailable(
      {bool makeAllApiCallsForTenure = false}) async {
    Map? requestBody;
    if (withdrawalCalculationModel != null &&
        withdrawalCalculationModel!.insuranceDetails != null) {
      requestBody = {
        "vas": [
          {"type": "insurance", "opted_in": isInsuranceChecked}
        ]
      };
    }

    List<WithdrawalCalculationResponseModel> calculations =
        await Future.wait<WithdrawalCalculationResponseModel>(
      [
        if (makeAllApiCallsForTenure) ...[
          CreditLimitRepository().getWithdrawalCalculation(
            loanAmount: loanAmountSliderValue.toInt(),
            tenure: defaultTenure,
            requestBody: requestBody,
          ),
          CreditLimitRepository().getWithdrawalCalculation(
            loanAmount: loanAmountSliderValue.toInt(),
            tenure: recomendedTenure,
            requestBody: requestBody,
          ),
        ],
        CreditLimitRepository().getWithdrawalCalculation(
          loanAmount: loanAmountSliderValue.toInt(),
          tenure: tenureSliderValue,
          requestBody: requestBody,
        ),
      ],
    );

    bool isSuccess = false;
    for (var requestModel in calculations) {
      switch (requestModel.apiResponse.state) {
        case ResponseState.success:
          _onWithdrawalCalculationFetched(requestModel,
              '${loanAmountSliderValue.toInt()},${requestModel.withdrawalCalculationModel.tenure}');
          isSuccess = true;
          break;
        default:
          handleAPIError(requestModel.apiResponse,
              screenName: WITHDRAWAL_SCREEN);
          return false;
      }
    }
    return isSuccess;
  }

  void _onWithdrawalCalculationFetched(
      WithdrawalCalculationResponseModel requestModel, String key) {
    switch (requestModel.apiResponse.state) {
      case ResponseState.success:
        _onWithdrawalCalculationFetchSuccess(requestModel, key);
        break;
      default:
        withdrawalState = WithdrawalState.error;
        handleAPIError(requestModel.apiResponse,
            screenName: WITHDRAWAL_SCREEN, retry: getWithdrawalCalculations);
    }
  }

  void _onWithdrawalCacheAvailable(String _key) {
    withdrawalState = WithdrawalState.loading;
    update([withdrawalDetailsView]);
    isPaymentDetailsLoading = false;
    _computeWithdrawalButton();
    withdrawalCalculationModel =
        WithdrawalCalculationModel.fromJson(_withdrawalResponseCache[_key]!);
    withdrawalState = WithdrawalState.success;
    update([withdrawalDetailsView, INSURANCE_CONTAINER_ID]);
  }

  void _onWithdrawalCalculationFetchSuccess(
      WithdrawalCalculationResponseModel requestModel, String key) {
    // isPaymentDetailsLoading = false;
    // withdrawalState = WithdrawalState.success;
    // update([withdrawalPaymentContainerId, withdrawalButtonId]);
    // isWithdrawalDetailsFormFilled =
    //     purposeFormKey.currentState?.validate() ?? false;
    withdrawalCalculationModel = requestModel.withdrawalCalculationModel;
    _withdrawalResponseCache
        .addAll({key: requestModel.calculationResponseBody!});
    Get.log("response cache - $_withdrawalResponseCache");
  }

  onLoanAmountTextChanged(String value) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.frontEndAmountValidation,
        attributeName: {
          'Limit Utilised': withdrawalDetailsHomePageModel.utilizedLimit,
          'Withdrawal Requested Amount': value,
          'Limit Sanctioned': withdrawalDetailsHomePageModel.totalLimit
        });

    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.amountSelected);

    isWithdrawalDetailsFormFilled = false;
    update([withdrawalButtonId]);

    if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
    _debounce = Timer(
      const Duration(seconds: 1),
      () async {
        if (withdrawalDetailsHomePageModel.availableMinLimit != null) {
          await _validateWithdrawalAmount(value);
        }
      },
    );
  }

  Future<void> _validateWithdrawalAmount(String value) async {
    double amountStringToDouble = parseIntoDoubleFormat(value);
    if (withdrawalDetailsHomePageModel.availableMinLimit! >= 1000 &&
        amountStringToDouble <
            withdrawalDetailsHomePageModel.availableMinLimit!) {
      loanAmountErrorText =
          "Amount should be minium ₹${AppFunctions().parseIntoCommaFormat(withdrawalDetailsHomePageModel.availableMinLimit.toString())}";
    } else if (amountStringToDouble >
        withdrawalDetailsHomePageModel.availableLimit) {
      loanAmountErrorText =
          "Amount exceeds limit";
    } else if ((amountStringToDouble % 100 != 0)) {
      loanAmountErrorText = "Enter in multiples of 100";
    } else if (!_computeAmountLesserThanSanctionedLimit(amountStringToDouble)) {
      loanAmountErrorText =
          "Amount exceeds limit";
    } else {
      loanAmountErrorText = "";
      loanAmountSliderValue = _roundToNearThousand(amountStringToDouble);
      await onLoanAmountChangeEnd(parseIntoDoubleFormat(value));
    }
  }

  double _roundToNearThousand(double amountValueInDouble) =>
      (amountValueInDouble / 100).floorToDouble() * 100;

  @override
  void onClose() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
  }

  ///Parse comma seperated money value to normal double format for calculations
  double parseIntoDoubleFormat(String value) {
    Get.log("value for parsing - $value");
    try {
      return double.parse(value.replaceAll(',', ''));
    } catch (e) {
      Get.log("can't parse money - $e");
      return 0;
    }
  }

  getListOfPurposes() async {
    isCallingApi = true;
    isPaymentDetailsLoading = true;
    _updateWithdrawalScreen();
    WithdrawalTenureResponseModel requestModel = await CreditLimitRepository()
        .getTenureList(loanAmount: loanAmountSliderValue.toInt());
    switch (requestModel.apiResponse.state) {
      case ResponseState.success:
        _onGetPurposesSuccess(requestModel: requestModel);
        break;
      default:
        withdrawalState = WithdrawalState.error;
        handleAPIError(requestModel.apiResponse,
            screenName: WITHDRAWAL_SCREEN, retry: getListOfPurposes);
        break;
    }
  }

  void _updateWithdrawalScreen() {
    _computeWithdrawalButton();
    update([
      withdrawalPaymentContainerId,
      withdrawalButtonId,
      withdrawalDetailsView
    ]);
  }

  void _onGetPurposesSuccess({
    required WithdrawalTenureResponseModel requestModel,
  }) async {
    await fetchBankDetails(requestModel);
    List<Purpose> data = requestModel.withdrawalTenureModel.purposes;
    purposeList = data.map((e) => e.name).toList();
    purposeList.add(PURPOSE_OTHERS);
    tenureRange = [];
    tenureRange.addAll(requestModel.withdrawalTenureModel.tenureList);

    if (purposeList.length > 2) {
      withdrawalState = WithdrawalState.success;
      // creditLineLimitDetailsModel = creditLimitModel;
      if (checkIfLimitReached()) {
        withdrawalRequestState = WithdrawalRequestState.limitReached;
        _updateWithdrawalCard();
      } else if (availableLimit != 0.0) {
        await _fetchDefaultAndMinTenureCalculations(requestModel);
        _updateWithdrawalCard();
      } else {
        handleAPIError(
            ApiResponse(
              state: ResponseState.failure,
              apiResponse: "",
              exception: "Available limit is 0",
            ),
            screenName: WITHDRAWAL_SCREEN);
      }
      AppAnalytics.trackWebEngageUser(
          userAttributeName: "UtilisedLimit",
          userAttributeValue: withdrawalDetailsHomePageModel.utilizedLimit);
    } else {
      withdrawalState = WithdrawalState.error;
      update();
      handleAPIError(
          ApiResponse(
            state: ResponseState.failure,
            apiResponse: "",
            exception:
                "Number of Purpose is less than 2 in withdraw calculation page",
          ),
          screenName: WITHDRAWAL_SCREEN,
          retry: getListOfPurposes);
    }
  }

  Future<void> _fetchDefaultAndMinTenureCalculations(
      WithdrawalTenureResponseModel requestModel) async {
    if (requestModel.withdrawalTenureModel != null) {
      defaultTenure = requestModel.withdrawalTenureModel.defaultTenure;
      recomendedTenure = requestModel.withdrawalTenureModel.recommendedTenure;
      tenureSliderValue = recomendedTenure;
      customTenureSliderValue = tenureSliderValue;
      if (tenureRange.length <= 1) {
        selectedTenureType = TenureType.defaultTenure;
        tenureSliderValue = defaultTenure;
      } else if (tenureRange.length <= 2) {
        selectedTenureType = TenureType.recommendedTenure;
        tenureSliderValue = recomendedTenure;
      } else {
        selectedTenureType = TenureType.recommendedTenure;
        tenureSliderValue = recomendedTenure;
      }
      await getWithdrawalCalculations(
          key:
              "$loanAmountSliderValue,${requestModel.withdrawalTenureModel.defaultTenure}",
          isAmountChanged: true);
    }
  }

  void setWithdrawalData() {
    _computeSliderHide();

    tenureSliderValue = recomendedTenure;
    loanAmountSliderValue = _roundToNearThousand(availableLimit);
    loanAmountTextController.text = AppFunctions().parseIntoCommaFormat(
      loanAmountSliderValue.toInt().toString().replaceAll(',', ''),
    );
    loanAmountTextController.selection =
        TextSelection.collapsed(offset: loanAmountTextController.text.length);
    createTenureMap(withdrawalDetailsHomePageModel.minTenure.toDouble(),
        withdrawalDetailsHomePageModel.maxTenure.toDouble());

    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.withdrawalScreenLoaded);
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "AvailableLimit",
        userAttributeValue: loanAmountSliderValue);
    withdrawalState = WithdrawalState.success;
    update([withdrawalDetailsView]);
  }

  ///hide slider, if limit amount is <= [TEN_K_THREEHUNDRED] and minimum amount
  ///is <= [TEN_THOUSAND] and if limit amount is <= [THREE_THOUSAND]
  _computeSliderHide() {
    hideSlider = (withdrawalDetailsHomePageModel.availableMinLimit != null &&
            withdrawalDetailsHomePageModel.availableLimit <=
                TEN_K_THREEHUNDRED &&
            withdrawalDetailsHomePageModel.availableMinLimit! >=
                TEN_THOUSAND) ||
        withdrawalDetailsHomePageModel.availableLimit <= THREE_THOUSAND;
  }

  void _updateWithdrawalCard() {
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "UtilisedLimit", userAttributeValue: usedLimit);
  }

  bool checkIfLimitReached() =>
      withdrawalDetailsHomePageModel.utilizedLimitPercentage == 100.00;

  ///See if we can move to backend or come up with a solution
  createTenureMap(double min, double max) {
    double value = min;
    double threeMonthValue = min;
    double sixMonthValue = min;

    threeMonthMap[min] = value;

    sixMonthMap[min] = value;

    while (value <= max) {
      if (value % 3 == 1) {
        threeMonthValue = threeMonthValue + 3;
        if (threeMonthValue > max) {
          threeMonthValue = max;
        }
      }

      threeMonthMap[value] = threeMonthValue;

      if (value % 6 == 4) {
        sixMonthValue = sixMonthValue + 6;
        if (sixMonthValue > max) {
          sixMonthValue = max;
        }
      }

      sixMonthMap[value] = sixMonthValue;

      value = value + 1;
    }

    threeMonthMap[max] = max;
    sixMonthMap[max] = max;

    Get.log("threeMonthMap - $threeMonthMap");
    Get.log("sixMonthMap - $sixMonthMap");
  }

  String? validateLoanAmountTextFiled(String? value) {
    if (withdrawalDetailsHomePageModel.availableMinLimit != null) {
      switch (_computeWithdrawalLimitStatusType(value)) {
        case WithdrawalAmountStatusType.belowMinLimit:
          return "you cannot withdraw less than ₹ ${AppFunctions().parseIntoCommaFormat(withdrawalDetailsHomePageModel.availableMinLimit!.toInt().toString())}";
        case WithdrawalAmountStatusType.aboveMinLimit:
          return "you cannot withdraw more than ₹ ${AppFunctions().parseIntoCommaFormat(withdrawalDetailsHomePageModel.availableMinLimit!.toInt().toString())}";
        case WithdrawalAmountStatusType.nonMultipleAmount:
          return "Please enter value in multiples of 1000. Ex 30000, 40000";
        case WithdrawalAmountStatusType.amountNotInRange:
        case WithdrawalAmountStatusType.amountNotEntered:
          return "Enter amount between ₹ ${AppFunctions().parseIntoCommaFormat(withdrawalDetailsHomePageModel.availableMinLimit!.toInt().toString())} to ₹ ${AppFunctions().parseIntoCommaFormat(withdrawalDetailsHomePageModel.availableLimit.toInt().toString())} in the multiples of 1000"
              .replaceAll('.00', '');
        case WithdrawalAmountStatusType.amountMoreThanAvailableLimit:
          return "Amount More Than Available Limit Value";
        case WithdrawalAmountStatusType.validAmount:
          return null;

        ///This will not show any error in textfield
      }
    }
  }

  WithdrawalAmountStatusType _computeWithdrawalLimitStatusType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return WithdrawalAmountStatusType.amountNotEntered;
    }
    double _amount = parseIntoDoubleFormat(value);

    ///so we can avoid parsing everytime in function and null check is already done in first coddition above
    if (_computeAmountBelowMinLimit(_amount)) {
      return WithdrawalAmountStatusType.belowMinLimit;
    }
    if (_computeAmountAboveMinLimit(_amount)) {
      return WithdrawalAmountStatusType.aboveMinLimit;
    }
    if (_computeAmountNotInRange(_amount)) {
      return WithdrawalAmountStatusType.amountNotInRange;
    }
    if (_amount % 1000 != 0) {
      return WithdrawalAmountStatusType.nonMultipleAmount;
    }
    if (!_computeAmountLesserThanSanctionedLimit(_amount)) {
      return WithdrawalAmountStatusType.amountMoreThanAvailableLimit;
    }
    return WithdrawalAmountStatusType.validAmount;
  }

  bool _computeAmountLesserThanSanctionedLimit(double _amount) {
    return withdrawalDetailsHomePageModel.utilizedLimit + _amount <=
        withdrawalDetailsHomePageModel.totalLimit;
  }

  bool _computeAmountBelowMinLimit(double _amount) {
    return withdrawalDetailsHomePageModel.availableMinLimit != null &&
        (_isMinLimitReached &&
            _amount < withdrawalDetailsHomePageModel.availableMinLimit!);
  }

  bool _computeAmountAboveMinLimit(double _amount) {
    return withdrawalDetailsHomePageModel.availableMinLimit != null &&
        (_isMinLimitReached &&
            _amount > withdrawalDetailsHomePageModel.availableMinLimit!);
  }

  bool get _isMinLimitReached =>
      withdrawalDetailsHomePageModel.availableMinLimit ==
      withdrawalDetailsHomePageModel.availableLimit;

  bool _computeAmountNotInRange(double value) {
    Get.log(
        "available min limit - ${withdrawalDetailsHomePageModel.availableMinLimit}");
    Get.log(
        "available limit - ${withdrawalDetailsHomePageModel.availableLimit}");
    return value < withdrawalDetailsHomePageModel.availableMinLimit! ||
        value > withdrawalDetailsHomePageModel.availableLimit;
  }

  ///function to handle loan amount change complete from text controller
  onLoanAmountEditingComplete({bool callApi = true}) {
    if (loanAmountTextController.text.isNotEmpty) {
      loanAmountSliderValue =
          parseIntoDoubleFormat(loanAmountTextController.text);
      loanAmountTextController.text = AppFunctions().parseIntoCommaFormat(
          loanAmountSliderValue.toString().replaceAll(',', ''));
      loanAmountTextController.selection =
          TextSelection.collapsed(offset: loanAmountTextController.text.length);
      onLoanAmountChangeEnd(
          parseIntoDoubleFormat(loanAmountTextController.text),
          callApi: callApi);
    }
    Get.focusScope!.unfocus();
  }

  String? validatePurposeTextField(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return null;
      }
      if (!alphaNumericRegex.hasMatch(value)) {
        return "Avoid special characters";
      }
    }
  }

  calculateTenureText(double value) {
    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.tenureSelected);
    if (tenureInterval == threeMonthInterval) {
      Get.log(
          "Three month value : ${threeMonthMap[value.round().toInt()]} and value : ${value.round().toInt()}");
      tenureSliderValue = threeMonthMap[value.round().toInt()]!.toInt();
    } else {
      tenureSliderValue = sixMonthMap[value.round().toInt()]!.toInt();
    }
    update([tenureSliderId, tenureTextId]);
  }

  bool loanAmountErrorValidator() {
    var value = parseIntoDoubleFormat(loanAmountTextController.text);
    return (_computeAmountNotInRange(value));
  }

  fetchBankDetails(
      WithdrawalTenureResponseModel withdrawalTenureResponseModel) async {
    if (accountNumber.isEmpty || bankName.isEmpty) {
      accountNumber =
          withdrawalTenureResponseModel.withdrawalTenureModel.accountNumber;
      bankName = withdrawalTenureResponseModel.withdrawalTenureModel.bankName;
    }
  }

  bool isWithdrawButtonActive() {
    return isWithdrawalDetailsFormFilled &&
        withdrawalState != WithdrawalState.loading &&
        withdrawalState != WithdrawalState.error &&
        !isPaymentDetailsLoading;
  }

  onWithdrawPressed() {
    if (!(isPaymentDetailsLoading ||
            withdrawalState == WithdrawalState.loading ||
            withdrawalState == WithdrawalState.error) &&
        purposeFormKey.currentState!.validate()) {
      onWithdrawDetailsContinueTapped();
    }
  }

  onWithdrawDetailsContinueTapped() async {
    withdrawalState = WithdrawalState.loading;
    isWithdrawalDetailsFormFilled =
        purposeFormKey.currentState?.validate() ?? false;
    update([withdrawalButtonId]);
    _computeIsInsuranceChecked();
  }

  void _computeIsInsuranceChecked() async {
    if (isInsuranceChecked) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.insuranceSubmitted,
          attributeName: {
            'insurance_product_name':
                withdrawalCalculationModel?.insuranceDetails?.productCode
          });
      _showInsuranceBottomSheet();
    } else {
      _onWithdrawalDetailsValid();
    }
  }

  Future<void> _showInsuranceBottomSheet() async {
    var result = await Get.bottomSheet(
      CrossSellBreakDownWidget(
        title: "Insurance Details",
        clausesList:
            withdrawalCalculationModel!.insuranceDetails!.acceptanceClauses,
        detailsList: [
          OfferTableModel(
              title: "Insurance Tenure", value: "$tenureSliderValue Months"),
          OfferTableModel(
            title: "Sum Insured",
            value: AppFunctions.getIOFOAmount(
              double.parse(loanAmountTextController.text.replaceAll(",", "")),
            ),
          ),
          OfferTableModel(
            title: "Insurance Premium",
            value: AppFunctions.getIOFOAmount(
              double.parse(
                withdrawalCalculationModel!
                    .insuranceWrapperResponse!.first.totalPremium
                    .toStringAsFixed(2),
              ),
            ),
          ),
        ],
      ),
      isScrollControlled: true,
    );
    if (result != null && result) {
      _onWithdrawalDetailsValid();
    } else {
      withdrawalState = WithdrawalState.success;
      isWithdrawalDetailsFormFilled =
          purposeFormKey.currentState?.validate() ?? false;
      update([withdrawalButtonId]);
    }
  }

  Future<void> _onWithdrawalDetailsValid() async {
    if (withdrawalDetailsHomePageModel.collectAddress) {
      _navigateToAddressDetails();
      // withdrawalIndex = 1;
    } else {
      await _postWithdrawRequest();
    }
  }

  void _navigateToAddressDetails() {
    withdrawalState = WithdrawalState.success;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawLoanAmountEntered,
        attributeName: {"Loan Amount": loanAmountTextController.text});
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawCTAClicked);
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.currentAddressScreenLoaded);
    if (withdrawalNavigation != null) {
      withdrawalNavigation!.navigateToAddressScreen(
        withdrawalRequestBody: _parseJsonBodyForWithdrawRequest(),
      );
      update([withdrawalButtonId]);
    } else {
      onNavigationDetailsNull("WITHDRAWAL_LOGIC");
    }
    // withdrawalIndex = 1;
  }

  Future<void> _postWithdrawRequest() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawCTAClicked);
    withdrawalState = WithdrawalState.loading;
    await postWithdrawRequestForUser(
        body: _parseJsonBodyForWithdrawRequest(),
        onSuccess: _onSuccess,
        onFailure: _onFailure);
  }

  Map<dynamic, dynamic> _parseJsonBodyForWithdrawRequest() {
    return {
      "purpose": showOtherPurposeTextField
          ? otherPurposeTextController.text
          : purposeController.text,
      "amount": parseIntoDoubleFormat(loanAmountTextController.text),
      "tenure": tenureSliderValue.toInt(),
      "disbursal_amount": _getDisbursalAmount(),
      "processingFee": withdrawalCalculationModel?.processingFeeMap,
      if ((LPCService.instance.activeCard?.loanProductCode ?? "") == 'FCL')
        "apr": withdrawalCalculationModel?.apr ?? ""
    }..addAll(isInsuranceChecked ? withdrawalCalculationModel!.toJson() : {});
  }

  _onFailure(ApiResponse apiResponse) {
    withdrawalState = WithdrawalState.error;
    handleAPIError(apiResponse, screenName: WITHDRAWAL_SCREEN);
  }

  _onSuccess() {
    withdrawalState = WithdrawalState.success;
    if (withdrawalNavigation != null) {
      withdrawalNavigation!.navigateToPollingScreen(isFirstWithdrawal: false);
    } else {
      ///OnNavigationNull
      onNavigationDetailsNull("WITHDRAWAL_LOGIC");
    }
  }

  double? _getDisbursalAmount() {
    if (withdrawalCalculationModel != null) {
      return withdrawalCalculationModel!.disbursedAmount;
    }
  }

  _computeProcessingFee() {
    if (withdrawalCalculationModel != null &&
        withdrawalCalculationModel!.discountedProcessingFee != null) {
      return withdrawalCalculationModel!.discountedProcessingFee;
    } else if (withdrawalCalculationModel != null) {
      return withdrawalCalculationModel!.processingFee!.toDouble();
    }
  }

  ///this will trigger a bottom sheet showing list of purpose
  void onTapPurposeTextField() async {
    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: 'Purpose',
        radioValues: purposeList,
        initialValue: purposeController.text,
      ),
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
    );
    if (result != null) {
      Get.log("result - $result");
      purposeController.text = result;
      showOtherPurposeTextField = result == PURPOSE_OTHERS;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.withdrawPurposeSelected);
      _computeWithdrawalButton();
    }
  }

  ///this function is to make the slider slide smooth
  void onLoanAmountSliderChanged(double value) {
    loanAmountSliderValue = _roundToNearThousand(value);
    loanAmountTextController.text = AppFunctions()
        .parseIntoCommaFormat(loanAmountSliderValue.toStringAsFixed(2));
  }

  ///this function will get triggered when the user released the slider
  ///this will start the emi computation
  void onLoanAmountSliderChangeEnd(double value) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.frontEndAmountValidation,
        attributeName: {
          'Limit Utilised': withdrawalDetailsHomePageModel.utilizedLimit,
          'Withdrawal Requested Amount': value,
          'Limit Sanctioned': withdrawalDetailsHomePageModel.totalLimit
        });
    loanAmountSliderValue = _roundToNearThousand(value);
    loanAmountTextController.text = AppFunctions()
        .parseIntoCommaFormat(loanAmountSliderValue.toStringAsFixed(2));
    onLoanAmountTextChanged(loanAmountTextController.text);
  }

  int? computeLoanAmountSliderDivisions() {
    ///return null if available limit is less or equal to [THREE_THOUSAND]
    ///because we will be hiding the slider
    if (withdrawalDetailsHomePageModel.availableLimit <= THREE_THOUSAND) {
      return null;
    }

    ///slider divisions should be multiples of 100
    ///if limit amount lesser that or equal to [TEN_K_ONE_HUNDRED]
    ///and minimum amount greater than or equal to [TEN_THOUSAND]
    else if (_isMultiplesOfHundred()) {
      return _computeLoanAmountSliderDivisionsInMultiplesOfHundred();

      ///slider divisions should be multiples of 1000
      ///if limit amount is greater than [TEN_K_ONE_HUNDRED]
    } else {
      return _computeLoanAmountSliderDivisionsInMultiplesOfThousand();
    }
  }

  int _computeLoanAmountSliderDivisionsInMultiplesOfThousand() {
    return (withdrawalDetailsHomePageModel.availableLimit -
            withdrawalDetailsHomePageModel.availableMinLimit!) ~/
        1000;
  }

  int _computeLoanAmountSliderDivisionsInMultiplesOfHundred() {
    return (withdrawalDetailsHomePageModel.availableLimit -
            withdrawalDetailsHomePageModel.availableMinLimit!) ~/
        100;
  }

  bool _isMultiplesOfHundred() {
    return withdrawalDetailsHomePageModel.availableMinLimit != null &&
        withdrawalDetailsHomePageModel.availableLimit <= TEN_K_ONE_HUNDRED &&
        withdrawalDetailsHomePageModel.availableMinLimit! >= TEN_THOUSAND;
  }

  void onTenureEmiCardTapped(TenureType tenureType) {
    if (selectedTenureType != tenureType) {
      _computeTenureEmiCardTapped(tenureType);
    }
  }

  void _computeTenureEmiCardTapped(TenureType tenureType) {
    selectedTenureType = tenureType;
    switch (tenureType) {
      case TenureType.defaultTenure:
        showTenureSlider = false;
        tenureSliderValue = defaultTenure;
        break;
      case TenureType.recommendedTenure:
        showTenureSlider = false;
        tenureSliderValue = recomendedTenure;
        break;
      case TenureType.customTenure:
        tenureSliderValue = customTenureSliderValue;
        showTenureSlider = true;
        if (tenureSliderValue == 0) {
          tenureSliderValue = recomendedTenure;
        }
        break;
    }
    calculateTenureText(tenureSliderValue.toDouble());
    getWithdrawalCalculations(
        key: "${loanAmountSliderValue.toInt()},${tenureSliderValue}");
  }

  void onOtherPurposeChanged(String value) {
    _computeWithdrawalButton();
  }

  _computeWithdrawalButton() {
    double amountStringToDouble =
        parseIntoDoubleFormat(loanAmountTextController.text);
    Get.log("amount - $amountStringToDouble");
    bool notValidLoanAmount = _computeAmountNotInRange(amountStringToDouble);
    bool loanAmountMultiplesOfHundred = amountStringToDouble % 100 == 0;
    bool validPurpose = purposeController.text.isNotEmpty;
    bool isOtherPurposeValid = otherPurposeTextController.text.isEmpty ||
        alphaNumericRegex.hasMatch(otherPurposeTextController.text);
    isWithdrawalDetailsFormFilled = !notValidLoanAmount &&
        loanAmountMultiplesOfHundred &&
        (showOtherPurposeTextField
            ? validPurpose && isOtherPurposeValid
            : validPurpose);
    update([withdrawalButtonId]);
  }

  String computeTenureTypeEventName(TenureType tenureType) {
    switch (tenureType) {
      case TenureType.defaultTenure:
        return WebEngageConstants.suggestedTenureClicked;
      case TenureType.recommendedTenure:
        return WebEngageConstants.defaultRecommendedTenureClicked;
      case TenureType.customTenure:
        return WebEngageConstants.customisedTenureClicked;
    }
  }

  parseWithdrawalBreakDownDataList() {
    switch (LPCService.instance.activeCard?.loanProductCode) {
      case "CLP":
        ClpWithdrawalHelper clpWithdrawalHelper = ClpWithdrawalHelper();
        return clpWithdrawalHelper.parsePaymentBreakDownData(
          insuranceOpted: isInsuranceChecked,
          calculationModel:
              isPaymentDetailsLoading ? null : withdrawalCalculationModel,
        );
      default:
        FlexiOdWithdrawalHelper flexiodWithdrawalHelper =
            FlexiOdWithdrawalHelper();
        return flexiodWithdrawalHelper.parsePaymentBreakDownData(
            calculationModel:
                isPaymentDetailsLoading ? null : withdrawalCalculationModel);
    }
  }

  computeShowTenure() {
    switch (LPCService.instance.activeCard?.loanProductCode) {
      case "CLP":
        return true;
      case "FCL":
        return false;
    }
  }

  void onTenureChanged(double value) {
    customTenureSliderValue = value.round().toInt();
    calculateTenureText(value);
  }
}

class WithdrawalBreakDownData {
  String title;
  String? value;
  String infoText;
  bool isDiscountedProcessingFee;
  bool isHighlighted;
  bool showDivider;

  WithdrawalBreakDownData(
      {required this.title,
      required this.value,
      this.infoText = "",
      this.showDivider = false,
      this.isDiscountedProcessingFee = false,
      this.isHighlighted = false});
}
