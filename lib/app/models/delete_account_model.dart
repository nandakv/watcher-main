import 'dart:convert';

import 'package:privo/app/api/response_model.dart';

DeleteAccountModel deleteAccountModelFromJson(ApiResponse apiResponse) {
  return DeleteAccountModel.decodeResponse(apiResponse);
}

class DeleteAccountModel {
  late String phoneNumber;
  late String subId;
  late List<String> appFormIds;
  late String createdAt;
  late String updatedAt;
  late bool isAccountDeleted;
  late final ApiResponse apiResponse;

  DeleteAccountModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          phoneNumber = jsonMap['phone_number'];
          subId = jsonMap['sub_id'];
          appFormIds = jsonMap['app_form_ids'].cast<String>();
          createdAt = jsonMap['created_at'];
          updatedAt = jsonMap['updated_at'];
          isAccountDeleted = jsonMap['is_account_deleted'];
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }
}
