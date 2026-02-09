import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/knowledge_base_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/privo_blogs.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../routes/app_pages.dart';

class KnowledgeBaseLogic extends GetxController with ApiErrorMixin {
  KnowledgeBaseRepository knowledgeBaseRepository = KnowledgeBaseRepository();
  late PrivoBlogs listOfBlogs;

  var arguments = Get.arguments;

  bool backToParent = false;

  GlobalKey<ScaffoldState> homePageScaffoldKey = GlobalKey<ScaffoldState>();

  late String KNOWLEDGE_BASE_SCREEN = "knowledge_base";

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  fetchBlogs() async {
    isLoading = true;
    try {
      listOfBlogs = await knowledgeBaseRepository.getBlogs();
      switch (listOfBlogs.apiResponse.state) {
        case ResponseState.success:
          if (arguments != null && arguments['blog_id'] != null) {
            _showDeepLinkBlog();
          }
          backToParent = arguments != null && arguments['back_to_parent'];
          isLoading = false;
          break;
        default:
          handleAPIError(listOfBlogs.apiResponse,
              screenName: KNOWLEDGE_BASE_SCREEN, retry: fetchBlogs);
          break;
      }
    } catch (e) {
      Get.log('Error in fetchBlogs: $e');
      isLoading = false;
    }
  }

  List<Blog> getFeaturedBlogs() {
    return listOfBlogs.listOfBlogs
        .where((element) => element.featured)
        .toList();
  }

  void openDrawer() {
    if (homePageScaffoldKey.currentState != null) {
      homePageScaffoldKey.currentState!.openDrawer();
    }
  }

  Future<bool> onBackPressed() async {
    if (backToParent) return true;
    Get.offNamed(Routes.HOME_SCREEN, preventDuplicates: true);
    return true;
  }

  String? blogId ;
  @override
  void onInit() {
    super.onInit();
    if (arguments != null && arguments['blog_id'] != null) {
      blogId = arguments['blog_id'] as String?;
    }
    fetchBlogs();
  }

  _showDeepLinkBlog() {
    final List<dynamic> allBlogs = listOfBlogs.listOfBlogs;
    if (blogId == null || allBlogs.isEmpty) {
      Get.log('blog_id is null or empty, or no blogs available.');
      return;
    }

    final selectedBlog =
        allBlogs.firstWhereOrNull((blog) => blog.blogId == blogId);

    if (selectedBlog == null) {
      Get.log(' No blog found with ID: $blogId.');
      return;
    }

    final List<dynamic> recommendedBlogs =
        allBlogs.where((blog) => blog.blogId != blogId).take(2).toList();

    Get.toNamed(
      Routes.BLOG_DETAILS,
      arguments: {
        'blog': selectedBlog,
        'recomendedBlogs': recommendedBlogs,
      },
    );
  }

  void onCardTapped(Blog blog) async {
    if (blogId != null) {
      blogId = null;
    }
    await Get.toNamed(
      Routes.BLOG_DETAILS,
      arguments: {'blog': blog, 'recomendedBlogs': _fetchRecomendedBlogs(blog)},
    );
    fetchBlogs();
  }

  _fetchRecomendedBlogs(Blog blog) {
    List<Blog> recomendedBlogs = listOfBlogs.listOfBlogs;
    recomendedBlogs.remove(blog);
    return recomendedBlogs
        .sublist(0, 2)
        .toList(); //first two blogs are recomended blogs
  }

  onBlogTapped(int index) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.blogClicked);
    onCardTapped(listOfBlogs.listOfBlogs[index]);
  }
}
