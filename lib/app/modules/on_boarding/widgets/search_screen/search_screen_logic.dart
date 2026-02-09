import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/work_details_repository.dart';
import 'package:privo/app/models/karza_employee_search_model.dart';
import 'package:privo/app/models/supported_banks_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/search_screen/bank_logo_mixin.dart';
import 'package:privo/app/utils/business_sectors_list.dart';

import '../../../../firebase/analytics.dart';
import '../../../../routes/app_pages.dart';

enum SearchType { employerSearch, bankDetails, businessSector }

class SearchScreenLogic extends GetxController
    with ApiErrorMixin, BankLogoMixin {
  var arguments = Get.arguments;

  late SearchType searchType;
  List<BanksModel> bankList = [];

  List<BanksModel> filteredBankList = [];

  String subTitleForBank = "";

  final ScrollController controller = ScrollController();
  var isEndOfList = false;

  _initBankNotFoundSearchlistener() {
    final maxScroll = controller.position.maxScrollExtent;
    if (controller.offset >= maxScroll) {
      isEndOfList = true;
      update(['bank_list']);
    }
  }

  late String screenName;

  _computeScreenName() {
    switch (searchType) {
      case SearchType.employerSearch:
        screenName = "employer_search";
        break;
      case SearchType.bankDetails:
        screenName = "bank_search";
        break;
      case SearchType.businessSector:
        screenName = "business_sector_search";
        break;
    }
  }

  @override
  void onInit() {
    controller.addListener(_initBankNotFoundSearchlistener);
    searchType = arguments['search_type'];
    _computeScreenName();

    switch (searchType) {
      case SearchType.bankDetails:
        bankList = arguments['bank_list'];
        subTitleForBank = arguments['sub_title_for_bank'] ?? "";
        bankList.sort(
          (a, b) => a.perfiosBankName.compareTo(b.perfiosBankName),
        );
        filteredBankList = bankList;
        break;
      case SearchType.businessSector:
        getBusinessSectors();
        break;
    }
    super.onInit();
  }

  final Map<String, List<String>> _typedQueries = {};

  bool makingAPICall = false;

  String HINT_TEXT = "Search";

  final TextEditingController searchController = TextEditingController();

  List<String> searchResult = [];

  void onSearch(String value) {
    switch (searchType) {
      case SearchType.employerSearch:
        getEmployers();
        break;
      case SearchType.bankDetails:
        _bankSearch(value);
        break;
      case SearchType.businessSector:
        getBusinessSectors();
        break;
    }
  }

  ///------ Logic for employer search ------------
  getEmployers() async {
    String query = searchController.text.trim();
    if (_typedQueries.containsKey(query)) {
      searchResult.clear();
      searchResult.addAll(_typedQueries[query]!);
      update();
    } else {
      await onKeyNotExists();
    }
  }

  String computeTitle() {
    switch (searchType) {
      case SearchType.employerSearch:
        return "Select Company";
      case SearchType.bankDetails:
        return "Select Bank";
      case SearchType.businessSector:
        return "Business Sector";
    }
  }

  getBusinessSectors() {
    String query = searchController.text.trim();
    if (query.isEmpty) {
      searchResult = businessSectorsList;
      update();
    } else {
      List<String> filteredSectors = businessSectorsList
          .where(
              (element) => element.toLowerCase().contains(query.toLowerCase()))
          .toList();
      searchResult = filteredSectors;
      update();
    }
  }

  Future<void> onKeyNotExists() async {
    if (searchController.text.trim().length > 2 && !makingAPICall) {
      await _checkForSpecialCharacters();
    } else {
      searchResult = [];
      update();
    }
  }

  Future<void> _checkForSpecialCharacters() async {
    makingAPICall = true;
    List<String> _employers = await searchForEmployer();
    searchResult.addAll(_employers);
    makingAPICall = false;
    update();
  }

  ///Function to parse and give the employer search result
  Future<List<String>> searchForEmployer() async {
    Map body = {
      "name": searchController.text.trim(),
      "otherName": false,
      "nameMatch": false,
      "nameMatchThreshold": false,
      "consent": "Y"
    };

    KarzaEmployeeSearchModel searchModel =
        await WorkDetailsRepository().searchEmployeer(body);

    switch (searchModel.apiResponse.state) {
      case ResponseState.success:
        List<String> result = searchModel.employeeResult
            .map((e) => e.primaryName + " (${e.name})")
            .toList();
        _typedQueries.addAll({searchController.text.trim(): result});
        if (searchController.text.trim().isNotEmpty) {
          result.insert(0, searchController.text.trim());
        }
        return result;
      case ResponseState.noInternet:
        handleAPIError(searchModel.apiResponse, screenName: screenName);
        return [];
      default:
        searchResult = [];
        return [searchController.text.trim()];
    }
  }

  bool validateSearchField() {
    return searchResult.isEmpty && searchController.text.length > 3;
  }

  ///----- Logic for Bank list search ---------
  void _bankSearch(String value) {
    filteredBankList = bankList
        .where(
          (element) => element.perfiosBankName.toLowerCase().contains(
                value.toLowerCase(),
              ),
        )
        .toList();

    ///to show the bottom bank not found widget
    isEndOfList = filteredBankList.isEmpty;
    update(['bank_list']);
  }

  onTapBankTile(BanksModel bank) {
    Get.back(result: bank);
  }

  @override
  void dispose() {
    searchController.dispose();
    controller.removeListener(_initBankNotFoundSearchlistener);
    controller.dispose();
    super.dispose();
  }

  void onClearTextClicked() {
    searchController.text = "";
    switch (searchType) {
      case SearchType.bankDetails:
        filteredBankList = bankList;
        break;
      case SearchType.businessSector:
        searchResult = businessSectorsList;
        break;
    }
    update();
  }

  void onBankNotFoundClicked() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: 'BANK NOT FOUND CLICKED',
    );
    Get.focusScope?.unfocus();

    ///to fix screen glitch on Add bank Screen
    await Future.delayed(const Duration(milliseconds: 500));
    await Get.toNamed(Routes.ADD_BANK_SCREEN);
    onClearTextClicked();
  }
}
