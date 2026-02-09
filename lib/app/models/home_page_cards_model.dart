import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';

import '../../flavors.dart';

HomePageCardsModel homePageCardsModelFromJson(ApiResponse apiResponse) {
  return HomePageCardsModel.decodeResponse(apiResponse);
}

class HomePageCardsModel {
  late final String responseCode;
  late final int timestamp;
  late final String appFormId;
  late final ResponseBody responseBody;
  late final ApiResponse apiResponse;

  HomePageCardsModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        // Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
        // _parseJson(jsonMap);
        // this.apiResponse = apiResponse..state = ResponseState.success;
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          _parseJson(jsonMap);
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

  _parseJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    timestamp = json['timestamp'];
    appFormId = json['appFormId'] ?? "";
    responseBody = ResponseBody.fromJson(json['responseBody']);
  }
}

class ResponseBody {
  ResponseBody({
    required this.cards,
    required this.isCreditLineCardsEmpty,
  });

  late final Cards cards;
  late final bool isCreditLineCardsEmpty;

  ResponseBody.fromJson(Map<String, dynamic> json) {
    cards = Cards.fromJson(json['cards']);
    isCreditLineCardsEmpty = cards.creditLine.isEmpty;
    if (json['cards']['loans'] != null && json['cards']['loans'].isNotEmpty) {
      json['cards']['loans']['is_rejected'] = false;
      Loans loan = Loans.fromJson(json['cards']['loans']);
      AppAuthProvider.setCif(loan.cif);
      cards.creditLine.add(loan);
    }
  }
}

class Cards {
  late final List<CreditLine> creditLine;

  Cards.fromJson(Map<String, dynamic> json) {
    creditLine = List.from(json['creditLine'])
        .map((e) => CreditLine.fromJson(e))
        .toList();
  }
}

class CreditLine {
  late final int order;
  late final String type;
  late final bool isUPL;
  late final String state;
  late final String title;
  late final String subtitle;
  late final bool surrogate;
  late final String buttonText;
  late final String infoText;
  late final String rejectionCode;
  late final String rejectionMessage;
  late final String appState;
  late final String rejectionFeedBack;
  late final bool isRejected;

  CreditLine.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    type = json['type'];
    isUPL = json['type'] == 'pldsa';
    state = json['state'] ?? "";
    title = json['title'];
    surrogate = json['is_surrogate'] ?? false;
    subtitle = json['subtitle'];
    appState = json['app_state'] ?? "0";
    buttonText = json['buttonText'] ?? "";
    infoText = json['info'] ?? "";
    rejectionCode = json['rejectionCode'] ?? "";
    rejectionMessage = _checkForRejectionMessageNull(json['rejectionMessage']);
    rejectionFeedBack = _checkForRejectionFeedBack(json);
    isRejected = json['is_rejected'];
  }

  String _checkForRejectionFeedBack(Map json) {
    if (json['feedback'] != null) {
      return json['feedback']['rejectionFeedback'] ?? "";
    } else {
      return '';
    }
  }

  String _checkForRejectionMessageNull(String? rejectionMessage) {
    if (rejectionMessage != null && rejectionMessage.isNotEmpty) {
      return rejectionMessage;
    }
    return "Sorry, we cannot process your loan currently. You do not match our eligibility criteria.";
  }
}

class Loans extends CreditLine {
  late final String cif;

  Loans.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    cif = json['cif'] ?? "";
  }
}
