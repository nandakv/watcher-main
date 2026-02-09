import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../firebase/analytics.dart';

class BottomSheetRadioButtonLogic extends GetxController {
  final String RADIO_LIST_WIDGET_ID = 'radio_list_widget_id';

  final otherTextFieldController = TextEditingController();

  bool _showSuccessWidget = false;

  bool get showSuccessWidget => _showSuccessWidget;

  set showSuccessWidget(bool value) {
    _showSuccessWidget = value;
    update([RADIO_LIST_WIDGET_ID]);
  }

  bool _toggleTextFieldVisibility = false;

  bool get isOtherValueSelected => _toggleTextFieldVisibility;

  set isOtherValueSelected(bool value) {
    _toggleTextFieldVisibility = value;
    update([RADIO_LIST_WIDGET_ID]);
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update([RADIO_LIST_WIDGET_ID]);
  }

  String selectedGroupValue = "";

  List<Widget> ctaButtons = [];

  void onAfterLayout(
    String initialValue,
    List<String> radioValues,
    bool enableOtherOption,
    List<Widget> Function(BottomSheetRadioButtonLogic logic)? ctaButtonsBuilder,
  ) {
    if (initialValue.isNotEmpty) {
      selectedGroupValue = initialValue;
    } else {
      selectedGroupValue = radioValues.first;
    }
    if (enableOtherOption && !radioValues.contains("Other")) {
      radioValues.add("Other");
    }

    if (ctaButtonsBuilder != null) {
      ctaButtons = ctaButtonsBuilder(this);
    }

    isLoading = false;
  }

  void onChangeRadioGroup(
      String? value, bool enableCTAs, bool enableOtherTextField) {
    if (value != null &&
        value.toLowerCase() == "other".toLowerCase() &&
        enableOtherTextField) {
      selectedGroupValue = value;
      isOtherValueSelected = true;
    } else if (value != null) {
      isOtherValueSelected = false;

      ///In this case value is null when the same option is selected again
      selectedGroupValue = value;
      update([RADIO_LIST_WIDGET_ID]);
      if (!enableCTAs) {
        Get.back(result: selectedGroupValue);
      }
    } else {
      if (!enableCTAs) {
        Get.back(result: selectedGroupValue);
      }
    }
  }

  onSubmitPressed({Function? onSubmitPressed,bool shouldShowSuccessWidget = true}) async {
    if (isOtherValueSelected) {
      selectedGroupValue = otherTextFieldController.text;
    }
    isLoading = true;
    if (onSubmitPressed != null) await onSubmitPressed(selectedGroupValue);
    isLoading = false;
    if(shouldShowSuccessWidget){
      showSuccessWidget = true;
    }
  }

  onSuccessWidgetCloseClicked() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "Close_Screen",
        attributeName: {"close_add_bank_input_screen": "true"});
    Get.back(
      result: {
        "close_parent": true,
      },
    );
  }
}
