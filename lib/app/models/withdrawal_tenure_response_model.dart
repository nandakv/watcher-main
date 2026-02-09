import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';

WithdrawalTenureResponseModel withdrawalTenureResponseModelFromJson(
    ApiResponse apiResponse) {
  return WithdrawalTenureResponseModel.decodeResponse(apiResponse);
}

class WithdrawalTenureResponseModel extends CheckAppFormModel {
  late WithdrawalTenureModel withdrawalTenureModel;

  WithdrawalTenureResponseModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
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

  _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
    Map<String, dynamic> jsonMap = json['responseBody'];
    withdrawalTenureModel = WithdrawalTenureModel.fromJson(jsonMap);
  }
}

class WithdrawalTenureModel {
  late List<int> tenureList;
  late int defaultTenure;
  late int recommendedTenure;
  late List<Purpose> purposes;
  late String accountNumber;
  late String bankName;

  WithdrawalTenureModel(
      {required this.tenureList,
      required this.defaultTenure,
      required this.recommendedTenure,
        required this.accountNumber,
        required this.bankName,
      required this.purposes});

  WithdrawalTenureModel.fromJson(Map<String, dynamic> json) {
    tenureList =
        json["tenure_list"] != null ? json['tenure_list'].cast<int>() : [];
    defaultTenure =
        json['default_tenure'] != null ? json['default_tenure'].toInt() : 0;
    recommendedTenure = json['recommended_tenure'] ?? 0;
    if (json['purpose'] != null) {
      purposes = <Purpose>[];
      json['purpose'].forEach((v) {
        purposes.add(Purpose.fromJson(v));
      });
    }
    bankName = json['bankAccount']['bankName'];
    accountNumber = json['bankAccount']['accountNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tenure_list'] = tenureList;
    data['default_tenure'] = defaultTenure;
    data['recommended_tenure'] = recommendedTenure;
    data['reasons'] = purposes.map((v) => v.toJson()).toList();
    return data;
  }
}

class Purpose {
  late int id;
  late String name;

  Purpose({required this.id, required this.name});

  Purpose.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
