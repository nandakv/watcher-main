import 'package:get/get.dart';
import 'package:privo/app/data/repository/on_boarding_repository/employment_type_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/utils/snack_bar.dart';

import '../../../../api/api_error_mixin.dart';
import '../../../../api/response_model.dart';
import '../../../../models/check_app_form_model.dart';
import 'employment_type_navigation.dart';

class EmploymentTypeLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin {
  OnBoardingEmploymentTypeNavigation? employmentSelectorNavigation;

  EmploymentTypeLogic({this.employmentSelectorNavigation});

  EmploymentTypeRepository employmentTypeRepository =
      EmploymentTypeRepository();

  ///loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
    if (employmentSelectorNavigation != null) {
      employmentSelectorNavigation!.toggleBack(isBackDisabled: isLoading);
    } else {
      onNavigationDetailsNull(EMPLOYMENT_SELECTOR);
    }
  }

  static const String EMPLOYMENT_SELECTOR = 'employment_selector';

  ///employment selector index
  var empSelectorIndex = 0;

  get getempSelectorIndex => empSelectorIndex;

  setempSelectorIndex(var value) {
    if (isLoading) {
      AppSnackBar.successBar(title: "Loading", message: "Please Wait");
    } else {
      empSelectorIndex = value;
      update(['salaried_ic', 'self_employed_ic']);
      update();
    }
  }

  ///onContinue Button tapped
  onEmploymentContinueTapped() {
    if (empSelectorIndex > 0) {
      updateEmployeeAppFormDataStatus();
    }
  }

  ///
  updateEmployeeAppFormDataStatus() async {
    isLoading = true;
    var body = {
      "salaryType": empSelectorIndex == 1 ? "8" : "6",
    };
    CheckAppFormModel appFormModel =
        await EmploymentTypeRepository().updateEmploymentType(body);

    switch (appFormModel.apiResponse.state) {
      case ResponseState.success:
        _onEmploymentDetailsSuccess(appFormModel);
        break;
      default:
        isLoading = false;
        handleAPIError(appFormModel.apiResponse,
            screenName: EMPLOYMENT_SELECTOR,
            retry: updateEmployeeAppFormDataStatus);
    }
  }

  _onEmploymentDetailsSuccess(CheckAppFormModel appFormModel) async {
    if (appFormModel.appFormRejectionModel.isRejected) {
      isLoading = false;
      _appFormRejectionNavigation(appFormModel);
    } else {
      _onEmploymentTypeSuccess();
    }
  }

  void _appFormRejectionNavigation(CheckAppFormModel appFormModel) async {
    if (employmentSelectorNavigation != null) {
      employmentSelectorNavigation!
          .onAppFormRejected(model: appFormModel.appFormRejectionModel);
    } else {
      await AppAnalytics.navigationObjectNull(EMPLOYMENT_SELECTOR);
    }
  }

  _onEmploymentTypeSuccess() async {
    isLoading = false;
    if (employmentSelectorNavigation != null) {
      employmentSelectorNavigation!.onEmploymentTypeSuccess();
    } else {
      await AppAnalytics.navigationObjectNull(EMPLOYMENT_SELECTOR);
    }
  }
}
