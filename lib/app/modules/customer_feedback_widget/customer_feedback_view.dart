import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/customer_feedback_widget/widgets/feedback_success_widget.dart';
import 'package:privo/app/modules/customer_feedback_widget/widgets/rejection_feedback_widget.dart';

import 'customer_feedback_logic.dart';

class CustomerFeedbackView extends StatefulWidget {
  final Function() onSuccess;

  const CustomerFeedbackView({Key? key, required this.onSuccess})
      : super(key: key);

  @override
  State<CustomerFeedbackView> createState() => _CustomerFeedbackViewState();
}

class _CustomerFeedbackViewState extends State<CustomerFeedbackView> {
  final CustomerFeedbackLogic customerFeedbackLogic =
      Get.put(CustomerFeedbackLogic());

  @override
  Widget build(BuildContext context) {
    Get.log("is filled ${customerFeedbackLogic.isFilled}");
    return WillPopScope(
      onWillPop: customerFeedbackLogic.onWillPop,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Get.width * 0.07),
                  topRight: Radius.circular(Get.width * 0.07))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: GetBuilder<CustomerFeedbackLogic>(builder: (logic) {
              switch (logic.userFeedBackState) {
                case UserFeedBackState.feedBackInit:
                  return RejectionFeedBackWidget();
                case UserFeedBackState.feedBackFinished:
                  return const FeedBackSuccessWidget();
              }
            }),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    customerFeedbackLogic.successCallback = widget.onSuccess;
    super.initState();
  }
}
