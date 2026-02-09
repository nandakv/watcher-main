import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/forms/base_field_validator.dart';
import 'package:privo/app/common_widgets/forms/sbd_field_validators.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/on_boarding_repository/business_details_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/models/business_details/gst_list_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/sbd_business_details/sbd_business_details_analytics.dart';
import 'package:privo/app/modules/on_boarding/widgets/sbd_business_details/sbd_business_details_navigation.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../../../../../res.dart';
import '../../../../api/api_error_mixin.dart';
import '../../../../common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import '../../../../common_widgets/forms/personal_details_field_validators.dart';
import '../../../../common_widgets/privo_text_editing_controller.dart';
import '../../../../mixin/app_analytics_mixin.dart';
import '../../../../models/sequence_engine_model.dart';
import '../../mixins/on_boarding_mixin.dart';

class SBDBusinessDetailsLogic extends GetxController
    with
        BaseFieldValidators,
        SBDFieldValidators,
        PersonalDetailsFieldValidators,
        ApiErrorMixin,
        OnBoardingMixin,
        AppAnalyticsMixin,
        SBDBusinessDetailsAnalytics {
  SBDBusinessDetailsNavigation? navigation;

  SBDBusinessDetailsLogic({this.navigation});

  final _businessDetailsRepository = BusinessDetailsRepository();

  late SequenceEngineModel sequenceEngineModel;

  late final String BUSINESS_DETAILS_SCREEN = 'BUSINESS_DETAILS_SCREEN';

  ///SBL IDs
  late final String BUSINESS_ENTITY_TYPE_ID = 'BUSINESS_ENTITY_TYPE_ID';

  late final String BUTTON_ID = "BUTTON_ID";

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;

    navigation?.toggleBack(isBackDisabled: value);
    update([BUTTON_ID, BUSINESS_ENTITY_TYPE_ID]);
  }

  bool _buttonEnabled = false;

  bool get buttonEnabled => _buttonEnabled;

  set buttonEnabled(bool value) {
    _buttonEnabled = value;
    update([BUTTON_ID]);
  }

  PrivoTextEditingController businessEntityNameController =
      PrivoTextEditingController();
  PrivoTextEditingController businessPanController =
      PrivoTextEditingController();
  PrivoTextEditingController registrationDateController =
      PrivoTextEditingController();
  PrivoTextEditingController pincodeController = PrivoTextEditingController();
  PrivoTextEditingController ownerShipTypeController =
      PrivoTextEditingController();

  final businessDetailsFormKey = GlobalKey<FormState>();

  final int SOLE_PROPRIETOR = 0;
  final int PARTNERSHIP = 1;
  final int LLP = 2;

  int? _businessEntitySelectedIndex;

  int? get businessEntitySelectedIndex => _businessEntitySelectedIndex;

  set businessEntitySelectedIndex(int? value) {
    _businessEntitySelectedIndex = value;
    update([BUSINESS_ENTITY_TYPE_ID]);
  }

  onAfterLayout() async {
    logSbdBusinessDetails1Loaded();
    if (await AppAuthProvider.isSBDBusinessDetailsSnackBarShown) {
      _showVerificationEmailSnackBar();
    }
    if (navigation != null) {
      sequenceEngineModel = navigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(BUSINESS_DETAILS_SCREEN);
    }
  }

  void _showVerificationEmailSnackBar() async {
    await AppAuthProvider.setSBDBusinessDetailsSnackBarShown();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                Res.information_svg,
                height: 12,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              const Expanded(
                child: Text(
                  'Verification link sent to your email! Please verify within 7 days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: darkBlueColor,
      ),
    );
  }

  validateButton() {
    buttonEnabled = isFieldValid(
            businessEntityNameValidator(businessEntityNameController.text)) &&
        (businessEntitySelectedIndex != SOLE_PROPRIETOR
            ? isFieldValid(businessPanValidator(businessPanController.text))
            : true) &&
        isFieldValid(pinCodeValidator(pincodeController.text)) &&
        isFieldValid(
            registrationDateValidator(registrationDateController.text)) &&
        isFieldValid(ownerShipTypeValidator(ownerShipTypeController.text));
  }

  onTapHorizontalItem(int index) {
    businessEntitySelectedIndex = index;
    logSbdEntityTypeClicked();
    validateButton();
  }

  onNextPressed() async {
    isButtonLoading = true;
    logFieldEvents();
    _getGSTList();
  }

  _getGSTList() async {
    Map<String, dynamic> body = {
      if (businessEntitySelectedIndex != SOLE_PROPRIETOR)
        "pan": businessPanController.text,
      "entityType": getEntityTypeFromSelectedIndex,
    };
    logSbdBusinessDetails1Submitted();
    GSTListModel model = await _businessDetailsRepository.getGstList(body);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        if (model.gstList.isNotEmpty) {
          logSbdGstListLoaded();
          _showGstListBottomSheet(model.gstList);
        } else {
          logSbdGstSelected(0);
          _postBusinessDetails();
        }
        break;
      default:
        isButtonLoading = false;
        handleAPIError(
          model.apiResponse,
          screenName: BUSINESS_DETAILS_SCREEN,
          retry: onNextPressed,
        );
    }
  }

  _showGstListBottomSheet(List<String> gstList) async {
    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: "Select GST",
        radioValues: gstList,
        isCloseIconEnabled: true,
        isScrollBarVisible: true,
        ctaButtonsBuilder: (bottomSheetLogic) {
          return [
            PrivoButton(
              onPressed: () {
                logSbdGstSelected(gstList.length);
                Get.back(result: bottomSheetLogic.selectedGroupValue);
              },
              title: "Continue",
            ),
          ];
        },
      ),
      isScrollControlled: false,
    );
    if (result != null) {
      _postBusinessDetails(result);
    } else {
      isButtonLoading = false;
    }
  }

  String get getEntityTypeFromSelectedIndex =>
      businessEntitySelectedIndex == SOLE_PROPRIETOR
          ? "PROPRIETORSHIP"
          : businessEntitySelectedIndex == PARTNERSHIP
              ? "PARTNERSHIP"
              : "LLP";

  _postBusinessDetails([String? selectedGST]) async {
    Map<String, dynamic> body = {
      "entityType": getEntityTypeFromSelectedIndex.trim(),
      if (businessEntitySelectedIndex != SOLE_PROPRIETOR)
        "pan": businessPanController.text.trim(),
      "name": businessEntityNameController.text.trim(),
      "ownershipType": ownerShipTypeController.text.trim(),
      "registrationDate": registrationDateController.text.trim(),
      if (selectedGST != null) "gst": selectedGST,
      "pincode": pincodeController.text.trim(),
    };

    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel)
            .makeHttpRequest(body: body);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        _checkIfAppFormRejected(model);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: BUSINESS_DETAILS_SCREEN,
          retry: _postBusinessDetails,
        );
    }
  }

  _checkIfAppFormRejected(CheckAppFormModel model) {
    if (model.appFormRejectionModel.isRejected) {
      logSbdCpcVintageRejection(model);
      _navigateToRejectedScreen(model);
    } else {
      _navigateToNextScreen(model);
    }
  }

  void _navigateToRejectedScreen(CheckAppFormModel model) {
    isButtonLoading = false;
    if (navigation != null) {
      navigation!.onAppFormRejected(
        model: model.appFormRejectionModel,
      );
    } else {
      onNavigationDetailsNull(BUSINESS_DETAILS_SCREEN);
    }
  }

  void _navigateToNextScreen(CheckAppFormModel model) {
    if (navigation != null && model.sequenceEngine != null) {
      navigation!
          .navigateUserToAppStage(sequenceEngineModel: model.sequenceEngine!);
    } else {
      onNavigationDetailsNull(BUSINESS_DETAILS_SCREEN);
    }
  }
}
