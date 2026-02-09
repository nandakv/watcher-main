import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

PrivoBlogs privoBlogModelFromJson(ApiResponse apiResponse) {
  return PrivoBlogs.decodeResponse(apiResponse);
}

class PrivoBlogs {
  late List<Blog> listOfBlogs;
  late final ApiResponse apiResponse;

  PrivoBlogs.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:

        try {
          List<dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          List<Blog> tmpList = [];
          for (var element in jsonMap) {
            tmpList.add(Blog.fromJson(element));
          }
          listOfBlogs = tmpList;
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("RequestDocSign url model exception ${e.toString()}");
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

class Blog {
  String blogId;
  String blogDate;
  String blogTitle;
  String blogDescription;
  String blogImage;
  bool featured;
  String blogLink;

  Blog({required this.blogDate,
    required this.blogTitle,
    required this.blogDescription,
    required this.blogImage,
    required this.blogLink,
    required this.blogId,
    required this.featured});

  factory Blog.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> _acfElement = json["acf"];
    return Blog(
        blogId: json['id'].toString(),
        blogDate: _acfElement["date"],
        blogTitle: _acfElement["heading"],
        blogDescription: _acfElement['description'],
        featured: _acfElement["featured"] == "No" ? false : true,
        blogImage: _acfElement['thumbnail_image']['sizes']['medium'],
        blogLink: "https://creditsaison.in/blog/" + _acfElement["url_heading"]);
  }
}
