import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/on_boarding_repository/on_boarding_repository.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import '../../api/api_error_mixin.dart';
import '../../api/response_model.dart';
import '../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../models/check_app_form_model.dart';

class ProfileLogic extends GetxController with ApiErrorMixin, AppFormMixin {
  String phone = "";
  String email = "";
  String appForm = "";
  String userName = "";

  late String PROFILE_SCREEN = "profile";

  @override
  void onInit() {
    super.onInit();
    PrivoPlatform.platformService.turnOnScreenProtection();
  }

  @override
  void onClose() {
    super.onClose();
    PrivoPlatform.platformService.turnOffScreenProtection();
  }

  void onAfterFirstLayout() async {
    await getUserDetails();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  GlobalKey<ScaffoldState> homePageScaffoldKey = GlobalKey<ScaffoldState>();

  getUserDetails() async {
    appForm = await AppAuthProvider.appFormID;
    if (appForm.isNotEmpty) {
      await getDetailsFromAppFormApi();
    } else {
      phone = await AppAuthProvider.phoneNumber;
      isLoading = false;
    }
    isLoading = false;
  }

  /// appForm is not empty but username or email is empty
  getDetailsFromAppFormApi() async {
    CheckAppFormModel model = await OnBoardingRepository().getAppFormStatus();
    isLoading = false;
    switch (model.apiResponse.state) {
      case ResponseState.success:
        await initProfileData(model);
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: PROFILE_SCREEN, retry: onAfterFirstLayout);
    }
  }

  Future<void> initProfileData(CheckAppFormModel model) async {
    if (model.responseBody != null) {
      phone = await AppAuthProvider.phoneNumber;
      userName = model.responseBody['applicant']['fullName'] ??
          await AppAuthProvider.userName;
      email = model.responseBody['applicant']['personalEmail'] ??
          await AppAuthProvider.email;
    } else {
      phone = await AppAuthProvider.phoneNumber;
    }
  }

  void openDrawer() {
    if (homePageScaffoldKey.currentState != null) {
      homePageScaffoldKey.currentState!.openDrawer();
    }
  }

  Future<bool> onBackPressed() async {
    Get.offNamed(Routes.HOME_SCREEN, preventDuplicates: true);
    return true;
  }
}
