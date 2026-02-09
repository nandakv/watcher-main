import 'package:get/get.dart';
import 'package:privo/app/models/my_account_model.dart';
import 'package:privo/app/services/lpc_service.dart';

import '../../api/response_model.dart';
import '../../data/provider/auth_provider.dart';
import '../../data/repository/on_boarding_repository/on_boarding_repository.dart';
import '../../models/check_app_form_model.dart';

class MyAccountWidgetInDrawerLogic extends GetxController {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  late MyAccountModel myAccountModel;

  fetchDetails() async {
    isLoading = true;
    myAccountModel = await _checkIfDataAvailableInLocalStorage();
    isLoading = false;
  }

  Future<MyAccountModel> _checkIfDataAvailableInLocalStorage() async {
    String fullName = await AppAuthProvider.getFullName;
    String phone = await AppAuthProvider.phoneNumber;
    String email = await AppAuthProvider.email;

    if (fullName.isNotEmpty && email.isNotEmpty && phone.isNotEmpty) {
      return MyAccountModel(
        name: fullName,
        phoneNumber: phone,
        email: email,
      );
    }
    return await _checkIfAppFormIsAvailableInLocalStorage(phone);
  }

  Future<MyAccountModel> _checkIfAppFormIsAvailableInLocalStorage(
      String phone) async {
    String appformId = LPCService.instance.lpcCards.first.appFormId;
    if (appformId.isEmpty) {
      return _emptyModel(phone);
    }
    return await _fetchAccountDetailsFromAPI(phone);
  }

  Future<MyAccountModel> _fetchAccountDetailsFromAPI(String phone) async {
    String fullName = "";
    String email = "";
    CheckAppFormModel checkAppFormModel =
        await OnBoardingRepository().getAppFormStatus(
          sessionAppFormId: LPCService.instance.lpcCards.first.appFormId,
        );

    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        try {
          fullName = checkAppFormModel.responseBody["applicant"]["fullName"];
          email = checkAppFormModel.responseBody["applicant"]["personalEmail"];
          phone = checkAppFormModel.responseBody['applicant']['phoneNumber'];
          await AppAuthProvider.setFullName(fullName);
          await AppAuthProvider.setEmail(email);
          await AppAuthProvider.setPhoneNumber(phone);
          return MyAccountModel(
            name: fullName,
            phoneNumber: phone,
            email: email,
          );
        } catch (e) {
          return _emptyModel(phone);
        }
      default:
        return _emptyModel(phone);
    }
  }

  _emptyModel(String phone) {
    return MyAccountModel(
      name: "-",
      phoneNumber: phone,
      email: "-",
    );
  }
}
