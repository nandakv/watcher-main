import 'dart:convert';

import 'package:get/get.dart';

import '../../res.dart';
import '../api/response_model.dart';

Map<String, String> infoTextTypeIconMapping = {
  "DEFAULT": Res.bulb_icon,
  "Personal Loan": Res.dreamRideIcon,
  "Instant Cash Loan": Res.shoppingIcon,
  "Home Renovation": Res.homePaintIcon,
  "Medical Emergency": Res.medicalIcon,
  "Wedding": Res.ringImg,
  "Education": Res.educationIcon,
  "Travel": Res.travelIcon,
};

InfoTextListModel infoTextModelFromJson(ApiResponse apiResponse) {
  return InfoTextListModel.decodeResponse(apiResponse);
}

class InfoTextListModel {
  List<InfoTextModel> infoTexts = [];
  late final ApiResponse apiResponse;

  InfoTextListModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e, s) {
          Get.log("Info Text Model exception $e $s");
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  String _computeInfoTextIcon(String infoTextType) {
    if (infoTextTypeIconMapping.containsKey(infoTextType)) {
      return infoTextTypeIconMapping[infoTextType]!;
    } else {
      return Res.bulb_icon;
    }
  }

  _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
    Get.log(json.toString());
    json.forEach((key, value) {
      infoTexts.add(
        InfoTextModel(
          infoText: value,
          iconPath: _computeInfoTextIcon(key),
        ),
      );
    });
  }
}

class InfoTextModel {
  final String infoText;
  final String iconPath;

  InfoTextModel({
    required this.iconPath,
    required this.infoText,
  });
}
