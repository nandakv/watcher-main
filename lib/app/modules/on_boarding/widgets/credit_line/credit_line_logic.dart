import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/credit_line_respository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/credit_limit_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/credit_line/credit_line_navigation.dart';

class CreditLineLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin {
  OnBoardingCreditLineNavigation? onBoardingCreditLineNavigation;

  CreditLineLogic({this.onBoardingCreditLineNavigation});

  CreditLimitRepository creditLimitRespitory = CreditLimitRepository();

  late SequenceEngineModel sequenceEngineModel;

  OnBoardingState getOnBoardingState = OnBoardingState.initialized;
  static const String CREDIT_LINE_CREATED_DETAILS =
      'credit_line_created_details';

  CreditLimitModel? creditLineLimitDetailsModel;

  late String CREDIT_LINE_SCREEN = "credit_line";

  _getSequenceEngineModel() {
    if (onBoardingCreditLineNavigation != null) {
      sequenceEngineModel =
          onBoardingCreditLineNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(CREDIT_LINE_CREATED_DETAILS);
    }
  }

  createWithdrawalLimit() async {
    getOnBoardingState = OnBoardingState.loading;
    _getSequenceEngineModel();
    CheckAppFormModel requestModel =
        await SequenceEngineRepository(sequenceEngineModel)
            .makeHttpRequest(body: {});
    switch (requestModel.apiResponse.state) {
      case ResponseState.success:
        if (requestModel.appFormRejectionModel.isRejected) {
          if (onBoardingCreditLineNavigation != null &&
              requestModel.sequenceEngine != null) {
            onBoardingCreditLineNavigation!.navigateUserToAppStage(
                sequenceEngineModel: requestModel.sequenceEngine!);
          } else {
            onNavigationDetailsNull(CREDIT_LINE_CREATED_DETAILS);
          }
        } else {
          getOnBoardingState = OnBoardingState.success;
          creditLineLimitDetailsModel = await getWithdrawalLimit();
          update();
        }
        break;

      default:
        if (onBoardingCreditLineNavigation != null) {
          onBoardingCreditLineNavigation!.onCreditLineFailed();
        } else {
          onNavigationDetailsNull(CREDIT_LINE_CREATED_DETAILS);
        }
        handleAPIError(requestModel.apiResponse,
            screenName: CREDIT_LINE_SCREEN, retry: createWithdrawalLimit);
    }
  }

  getWithdrawalLimit() async {
    getOnBoardingState = OnBoardingState.loading;
    CreditLimitModel creditLimitModel =
        await creditLimitRespitory.getWithdrawalLimitDetails();
    switch (creditLimitModel.apiResponse.state) {
      case ResponseState.success:
        return onGetWithdrawalLimitSuccess(creditLimitModel);
      case ResponseState.failure:
      case ResponseState.badRequestError:
        await createWithdrawalLimit();
        break;
      default:
        handleAPIError(creditLimitModel.apiResponse,
            screenName: CREDIT_LINE_SCREEN, retry: getWithdrawalLimit);
    }
  }

  CreditLimitModel onGetWithdrawalLimitSuccess(
      CreditLimitModel creditLimitModel) {
    if (creditLimitModel.appFormRejectionModel.isRejected) {
      if (onBoardingCreditLineNavigation != null) {
        onBoardingCreditLineNavigation!
            .onAppFormRejected(model: creditLimitModel.appFormRejectionModel);
      } else {
        onNavigationDetailsNull(CREDIT_LINE_CREATED_DETAILS);
      }
    }
    getOnBoardingState = OnBoardingState.success;
    return creditLimitModel;
  }

  onCreditLineCreatedContinueTapped() {
    if (onBoardingCreditLineNavigation != null) {
      onBoardingCreditLineNavigation!.onCreditLineFinished();
    } else {
      onNavigationDetailsNull(CREDIT_LINE_CREATED_DETAILS);
    }
  }
}
