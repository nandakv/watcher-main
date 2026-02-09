import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/modules/emi_calculator/emi_screen_analytics.dart';
import 'package:privo/app/modules/emi_calculator/helper/lpc_list_helper.dart';
import 'package:privo/app/modules/emi_calculator/model/lpc_calculator_model.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:privo/res.dart';

import '../loan_details/widgets/info_bottom_sheet.dart';

enum EmiCalculatorState { intro, lpcListScreen, calculator, loading }

class EmiCalculatorLogic extends GetxController with EmiScreenAnalytics {
  EmiCalculatorState _emiCalculatorState = EmiCalculatorState.loading;

  var LOAN_AMOUNT_SLIDER_ID = "LOAN_AMOUNT_SLIDER";
  var INTEREST_SLIDER_ID = "INTEREST_SLIDER";

  var LOAN_AMOUNT_TEXTFIELD_ID = "LOAN_AMOUNT_TEXTFIELD_ID";

  int MIN_INDEX = 0;
  int MAX_INDEX = 1;

  // Define constants for unit thresholds
  int crore = 10000000;
  int lakh = 100000;
  int thousand = 1000;

  TextEditingController loanAmountTextController = TextEditingController();
  TextEditingController tenureTextController = TextEditingController();
  TextEditingController interestTextController = TextEditingController();

  var TENURE_TEXT_FIELD = "TENURE_TEXT_FIELD";

  var TENURE_SLIDER = "TENURE_SLIDER";

  var INTEREST_TEXTFIELD_ID = "INTEREST_TEXTFIELD_ID";

  EmiCalculatorState get emiCalculatorState => _emiCalculatorState;

  set emiCalculatorState(EmiCalculatorState value) {
    _emiCalculatorState = value;
    update();
  }

  double _loanAmountSliderValue = 10000.0;

  double get loanAmountSliderValue => _loanAmountSliderValue;

  set loanAmountSliderValue(double value) {
    _loanAmountSliderValue = value.round().toDouble();
    calculateEmiInterest();
    update();
  }

  String _interestErrorText = "";

  String get interestErrorText => _interestErrorText;

  set interestErrorText(String value) {
    _interestErrorText = value;
    update();
  }

  String _loanErrorText = "";

  String get loanErrorText => _loanErrorText;

  set loanErrorText(String value) {
    _loanErrorText = value;
    update();
  }

  String _tenureErrorText = "";

  String get tenureErrorText => _tenureErrorText;

  set tenureErrorText(String value) {
    _tenureErrorText = value;
    update();
  }

  int _tenureSliderValue = 3;

  int get tenureSliderValue => _tenureSliderValue;

  set tenureSliderValue(int value) {
    _tenureSliderValue = value;
    calculateEmiInterest();
    update();
  }

  late List<LpcCalculatorModel> lpcList;

  double _interestSliderValue = 8.99;

  double get interestSliderValue => _interestSliderValue;

  set interestSliderValue(double value) {
    _interestSliderValue = value;
    calculateEmiInterest();
    update();
  }

  late LpcCalculatorModel _selectedLpc;

  LpcCalculatorModel get selectedLpc => _selectedLpc;

  set selectedLpc(LpcCalculatorModel value) {
    _selectedLpc = value;
    _setCalculationData();
    update();
  }

  late String monthlyEmi;
  late String totalInterestPayable;

  List<EmiCalculatorFeatures> emiCalculatorFeatures = [
    EmiCalculatorFeatures(
        icon: Res.calculateIcon, title: "Quick & easy calculations"),
    EmiCalculatorFeatures(
        icon: Res.language, title: "Access anytime, anywhere"),
    EmiCalculatorFeatures(icon: Res.schedule, title: "Saves a lot of time"),
    EmiCalculatorFeatures(
        icon: Res.encrypted, title: "No personal information required"),
    EmiCalculatorFeatures(
        icon: Res.compareArrows, title: "Makes it easier to compare loans"),
  ];

  void _setCalculationData() {
    tenureSliderValue = selectedLpc.minAndMaxTenure[MIN_INDEX].toInt();
    interestSliderValue = selectedLpc.minAndMaxInterest[MIN_INDEX];
    loanAmountSliderValue = selectedLpc.minAndMaxAmount[MIN_INDEX];
    loanAmountTextController.text =
        AppFunctions().parseIntoCommaFormat(loanAmountSliderValue.toString());
    tenureTextController.text = tenureSliderValue.toString();
    interestTextController.text = interestSliderValue.toString();
  }

  onCalculatorIntroContinuePressed() async {
    logProductCardsScreenLoaded();
    await AppAuthProvider.setEmiCalculatorIntroPageShown();
    emiCalculatorState = EmiCalculatorState.lpcListScreen;
  }

  void onAfterFirstLayout() async {
    lpcList = LpcGridHelper.lpcList;
    selectedLpc = lpcList[0];

    ///Sets initial value by default
    _setCalculationData();
    logEmiCalculatorLoaded();
    calculateEmiInterest();
    if (!await AppAuthProvider.isEmiCalculatorIntroPageShown) {
      emiCalculatorState = EmiCalculatorState.intro;
    } else {
      emiCalculatorState = EmiCalculatorState.lpcListScreen;
    }
  }

  void onLpcCardTapped(LpcCalculatorModel model) {
    logProductCardsScreenClicked(model.title);
    selectedLpc = model;
    emiCalculatorState = EmiCalculatorState.calculator;
    logEmiCalculatorScreenLoaded(model.title);
  }

  onWillPop() async {
    interestErrorText = "";
    loanErrorText = "";
    tenureErrorText = "";
    switch (emiCalculatorState) {
      case EmiCalculatorState.intro:
      case EmiCalculatorState.lpcListScreen:
        Get.back();
        return true;
      case EmiCalculatorState.calculator:
        logEmiCalculatorClosed(totalAmountPayable,
            interestSliderValue.toString(), monthlyEmi, totalInterestPayable);
        emiCalculatorState = EmiCalculatorState.lpcListScreen;
        return false;
      case EmiCalculatorState.loading:
        Get.back();
        return true;
    }
  }

  String get totalAmountPayable {
    return (loanAmountSliderValue + int.parse(totalInterestPayable)).toString();
  }

  void onLoanAmountSliderChangeEnd(double value) {
    loanErrorText = validateLoanAmountTextField(value.toString());
    loanAmountSliderValue = value;
    loanAmountTextController.text =
        AppFunctions().parseIntoCommaFormat(value.toString());
    calculateEmiInterest();
  }

  void onLoanAmountSliderChanged(double value) {
    loanAmountSliderValue = value;
  }

  void onLoanAmountTextChanged(String value) {
    loanErrorText = validateLoanAmountTextField(value);
    if (!_validateLoanAmount(value) && value.isNotEmpty) {
      double amountStringToDouble = parseIntoDoubleFormat(value);
      loanAmountSliderValue = amountStringToDouble;
    }
  }

  double parseIntoDoubleFormat(String value) {
    Get.log("value for parsing - $value");
    try {
      return double.parse(value.replaceAll(',', ''));
    } catch (e) {
      Get.log("can't parse money - $e");
      return 0;
    }
  }

  void onTenureSliderChangedEnd(double value) {
    tenureErrorText = validateTenure(value.toString());
    tenureSliderValue = value.toInt();
    tenureTextController.text = tenureSliderValue.toString();
  }

  void onTenureSliderChanged(double value) {
    tenureErrorText = validateTenure(value.toString());
    tenureSliderValue = value.toInt();
    tenureTextController.text = tenureSliderValue.toString();
  }

  void onTenureTextChanged(String value) {
    tenureErrorText = validateTenure(value);
    if (!_validateTenure(value) && value.isNotEmpty) {
      tenureSliderValue = int.parse(value);
    }
  }

  void onInterestTextChanged(String value) {
    if(value.isEmpty) return;
    interestErrorText = validateInterestAmount(value);
    if (!_validateInterestAmount(value) && value.isNotEmpty) {
      interestSliderValue = double.parse(value);
    }
  }

  void onInterestAmountChangedEnd(double value) {
    interestErrorText = validateInterestAmount(value.toString());
    interestSliderValue = value.toPrecision(2);
    interestTextController.text = interestSliderValue.toString();
  }

  void onInterestAmountChanged(double value) {
    interestErrorText = validateInterestAmount(value.toString());
    interestSliderValue = value.toPrecision(2);
    interestTextController.text = interestSliderValue.toString();
  }

  calculateEmiInterest() {
    double monthlyRate = interestSliderValue / 12 / 100;
    double emi = ((loanAmountSliderValue *
        monthlyRate *
        pow(MAX_INDEX + monthlyRate, tenureSliderValue)) /
        (pow(MAX_INDEX + monthlyRate, tenureSliderValue) - MAX_INDEX));

    ///Formula for emi [P x R x (1+R)^N]/[(1+R)^N-1]
    monthlyEmi = emi.round().toString();
    int totalAmountPayable = (emi * tenureSliderValue).round().toInt();
    totalInterestPayable =
        (totalAmountPayable - loanAmountSliderValue.toInt()).toString();
  }

  String validateLoanAmountTextField(String? value) {
    if (value != null && value.isEmpty) return "Amount cannot be empty";
    if (_validateLoanAmount(value))
      return "Please enter a value within given range";
    return "";
  }

  bool _validateLoanAmount(String? value) {
    return value != null &&
        value.isNotEmpty &&
        (parseIntoDoubleFormat(value) <
                selectedLpc.minAndMaxAmount[MIN_INDEX] ||
            parseIntoDoubleFormat(value) >
                selectedLpc.minAndMaxAmount[MAX_INDEX]);
  }

  String validateInterestAmount(String? value) {
    if (value != null && value.isEmpty) return "Interest cannot be empty";
    if (_validateInterestAmount(value))
      return "Please enter a value within given range";
    return "";
  }

  bool _validateInterestAmount(String? value) {
    try {
      return value != null &&
          value.isNotEmpty &&
          (double.parse(value) < selectedLpc.minAndMaxInterest[MIN_INDEX] ||
              double.parse(value) > selectedLpc.minAndMaxInterest[MAX_INDEX]);
    } catch (e) {
      return false;
    }
  }

  String formatAmountWithSuffix(int amount) {
    if (amount >= crore) {
      // Convert to crores
      return '${(amount ~/ crore).toString()}Cr';
    }

    if (amount >= lakh) {
      // Convert to lakhs
      double lakhs = amount / lakh;
      return '${lakhs.toStringAsFixed(lakhs % 1 == 0 ? 0 : 1)}L';

      ///For amounts between 1 lakh and less than 1 crore, we convert the amount to lakhs by dividing by the lakh value. We use toStringAsFixed to ensure a single decimal place if there is a remainder after the division
    }

    if (amount >= thousand) {
      // Convert to thousands
      return '${(amount ~/ thousand).toString()}K';
    }

    // If the amount is less than 1000, return it as is
    return amount.toString();
  }

  String validateTenure(String? value) {
    if (value != null && value.isEmpty) return "Tenure cannot be empty";
    if (_validateTenure(value))
      return "Please enter a value within given range";
    return "";
  }

  bool _validateTenure(String? value) =>
      value != null && value.isNotEmpty &&
      (double.parse(value) < selectedLpc.minAndMaxTenure[MIN_INDEX] ||
          double.parse(value) > selectedLpc.minAndMaxTenure[MAX_INDEX]);

  void onInfoTapped() {
    logQuestionProductClicked(selectedLpc.title);
    Get.bottomSheet(InfoBottomSheet(
        title: selectedLpc.title, text: selectedLpc.description));
  }
}

class EmiCalculatorFeatures {
  String icon;
  String title;

  EmiCalculatorFeatures({required this.icon, required this.title});
}
