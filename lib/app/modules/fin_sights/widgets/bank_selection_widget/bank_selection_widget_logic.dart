import 'dart:math';

import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/supported_banks_model.dart';
import 'package:privo/app/modules/fin_sights/finsights_carousel_mixin.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_exit_dialog.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_feedback_dialog.dart';
import 'package:privo/app/modules/on_boarding/widgets/search_screen/search_screen_logic.dart';
import 'package:privo/app/routes/app_pages.dart';

import '../../../../data/repository/on_boarding_repository/bank_details_repository.dart';

class BankSelectionWidgetLogic extends GetxController
    with ApiErrorMixin, AppAnalyticsMixin, FinSightsCarouselMixin {
  final _bankDetailsRepository = BankDetailsRepository();

  late final String BUTTON_ID = "BUTTON_ID";
  late final String BANK_SELECTION_FIELD_ID = "BANK_SELECTION_FIELD_ID";
  late final String BANK_PAGE_ID = "BANK_PAGE_ID";

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update([BANK_PAGE_ID]);
  }

  List<BanksModel> supportedBanksList = [];

  BanksModel? _selectedBank;

  BanksModel? get selectedBank => _selectedBank;

  set selectedBank(BanksModel? value) {
    _selectedBank = value;
    update([BANK_SELECTION_FIELD_ID, BUTTON_ID]);
  }

  final List<String> bankSelectionFeedbackOptions = [
    "I am unable to find my bank",
    "I don't think it's secure",
    "I don’t know which bank to select",
    "I am not comfortable to share my bank details",
    "Others",
  ];
  finSightsBackClicked(String pageName) async {
    logBackButtonClicked(pageName);
    if (selectedBank == null) {
      await Get.bottomSheet(
          FinsightsExitBottomSheet(
            title: "Are you sure you don’t want to track your accounts? ",
            selectionFeedbackOptions: bankSelectionFeedbackOptions,
          ),
          isDismissible: false,
          isScrollControlled: true);
    } else {
      Get.back();
    }
    return false;
  }

  onBankSelectionTapped(Function(String bankName)? onBankSelected) async {
    var result = await Get.toNamed(
      Routes.SEARCH_SCREEN,
      arguments: {
        'search_type': SearchType.bankDetails,
        'bank_list': supportedBanksList,
        'sub_title_for_bank': "Choose the bank you want to connect",
      },
    );
    if (result != null) {
      selectedBank = result as BanksModel;
      onBankSelected?.call(selectedBank!.perfiosBankName);
    }
  }

  void onAfterLayout() async {
    isLoading = true;
    SupportedBanksModel supportedBanksModel =
        await _bankDetailsRepository.getBanks("");
    switch (supportedBanksModel.apiResponse.state) {
      case ResponseState.success:
        supportedBanksList = supportedBanksModel.supportedBanks
            .where((element) => element.accountAggregatorSupported)
            .toList();
        isLoading = false;
        break;
      default:
        handleAPIError(
          supportedBanksModel.apiResponse,
          screenName: BANK_PAGE_ID,
          retry: onAfterLayout,
        );
    }
  }
}
