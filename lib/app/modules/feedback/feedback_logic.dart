import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/feedback_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/modules/feedback/widgets/success_dialog.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

enum FeedbackType { rejected, offerExpiry, creditLineExpiry }

class FeedbackLogic extends GetxController {
  TextEditingController feedBackTextController = TextEditingController();

  var arguments = Get.arguments;

  late FeedbackType feedbackType;

  @override
  void onInit() {
    super.onInit();
    feedbackType = arguments['feedback_type'] ?? FeedbackType.rejected;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isFilled = false;

  bool get isFilled => _isFilled;

  set isFilled(bool value) {
    _isFilled = value;
  }

  feedBackTextFieldOnChanged() {
    isFilled = feedBackTextController.text.isNotEmpty &&
        feedBackTextController.text.length >= 10;
    update();
  }

  String? validateReason(String? value) {
    if (value == null || value.isEmpty || value.length < 10) {
      return "Minimum of 10 characters";
    }
    return null;
  }

  final OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Colors.grey, width: 1),
  );

  onFeedbackSheetClosed() async {
    await postUserFeedBack("USER closed");
  }

  sendUserFeedBack() async {
    await postUserFeedBack(feedBackTextController.text);
  }

  Future<void> postUserFeedBack(String feedback) async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.feedbackClicked,
        attributeName: {"feedback": feedBackTextController.text});

    isLoading = true;
    ApiResponse apiResponse =
        await FeedbackRepository().postUserRejectionFeedBack(
      body: {
        "feedback": {
          _computeFeedbackKey(): feedback,
        }
      },
    );
    isLoading = false;
    switch (apiResponse.state) {
      case ResponseState.success:
        if (feedback.contains("USER closed")) {
          Get.back();
          break;
        }
        await Get.bottomSheet(const SuccessDialog(), isDismissible: false);
        Get.back();
        update();
        break;
      default:
        Get.back();
    }
  }

  String _computeFeedbackKey() {
    switch (feedbackType) {
      case FeedbackType.rejected:
        return "rejectionFeedback";
      case FeedbackType.offerExpiry:
        return "offerExpiryFeedback";
      case FeedbackType.creditLineExpiry:
        return "creditLineExpiryFeedback";
      default:
        return "rejectionFeedback";
    }
  }
}
