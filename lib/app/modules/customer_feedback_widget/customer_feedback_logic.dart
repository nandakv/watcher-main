import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/feedback_repository.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/modules/customer_feedback_widget/widgets/feedback_success_widget.dart';

import 'widgets/rejection_feedback_widget.dart';

enum UserFeedBackState { feedBackInit, feedBackFinished }

class CustomerFeedbackLogic extends GetxController {
  UserFeedBackState _userFeedBackState = UserFeedBackState.feedBackInit;

  UserFeedBackState get userFeedBackState => _userFeedBackState;

  set userFeedBackState(UserFeedBackState value) {
    _userFeedBackState = value;
  }

  FeedbackRepository feedbackRepository = FeedbackRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  Function()? successCallback;

  TextEditingController feedBackTextController = TextEditingController();

  bool _isFilled = false;

  bool get isFilled => _isFilled;

  set isFilled(bool value) {
    _isFilled = value;
  }

  feedBackTextFieldOnChanged() {
    isFilled = feedBackTextController.text.isNotEmpty;
    update();
  }

  sendUserFeedBack() async {
    await postUserFeedBack(feedBackTextController.text);
  }

  Future<void> postUserFeedBack(String feedback) async {
    isLoading = true;
    ApiResponse apiResponse =
        await feedbackRepository.postUserRejectionFeedBack(body: {
      "feedback": {"rejectionFeedback": feedback}
    });
    isLoading = false;
    switch (apiResponse.state) {
      case ResponseState.success:
        if (successCallback != null) successCallback!();
        if (feedback.contains("USER closed")) {
          Get.back();
          break;
        }
        userFeedBackState = UserFeedBackState.feedBackFinished;
        update();
        break;
      default:
        Get.back();
    }
  }

  onFeedbackSheetClosed() async {
    await postUserFeedBack("USER closed");
  }

  Future<bool> onWillPop() async {
    userFeedBackState = UserFeedBackState.feedBackInit;
    isFilled = false;
    feedBackTextController.clear();
    return true;
  }
}
