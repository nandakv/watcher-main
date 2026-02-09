import 'dart:convert';

import 'package:get/get.dart';

import '../api/response_model.dart';

FAQModel faqModelFromJson(ApiResponse apiResponse) {
  return FAQModel.decodeResponse(apiResponse);
}

class FAQModel {
  late List<FAQCategories> categories = [];
  late ApiResponse apiResponse;

  FAQModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Faq details exception ${e.toString()}");
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
    if (json['categories'] != null) {
      json['categories'].forEach((categoryItem) {
        categories.add(FAQCategories.fromJson(categoryItem));
      });
    }
  }
}

class FAQCategories {
  late String categoryTitle;
  late String categorySubTitle;
  late List<FAQSubCategories> subCategories = [];
  late List<FAQQueries> queries = [];

  FAQCategories.fromJson(Map<String, dynamic> json) {
    categoryTitle = json['queryCategory'];
    categorySubTitle = json['categorySubtitle'];
    if (json['subCategories'] != null) {
      json['subCategories'].forEach((subCategoryItem) {
        subCategories.add(FAQSubCategories.fromJson(subCategoryItem));
      });
    }
    if (json['queries'] != null) {
      json['queries'].forEach((queryItem) {
        queries.add(FAQQueries.fromJson(queryItem));
      });
    }
  }
}

class FAQSubCategories {
  late String subCategoryTitle;
  late String subCategorySubTitle;
  late List<FAQQueries> queries = [];

  FAQSubCategories.fromJson(Map<String, dynamic> json) {
    subCategoryTitle = json['querySubCategory'];
    subCategorySubTitle = json['subCategorySubtitle'];
    if (json['queries'] != null) {
      json['queries'].forEach((queryItem) {
        queries.add(FAQQueries.fromJson(queryItem));
      });
    }
  }
}

class FAQQueries {
  late String question;
  late String answer;

  FAQQueries.fromJson(Map<String, dynamic> json) {
    question = json['question'] ?? "";
    answer = json['answer'] ?? "";
  }
}
