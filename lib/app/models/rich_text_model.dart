import 'package:flutter/material.dart';

import '../firebase/analytics.dart';
import '../utils/web_engage_constant.dart';

class RichTextModel {
  late final String text;
  late final String link;
  late final Function? onHyperlinkClicked;
  late final Function? onTap;
  late TextStyle? textStyle;

  RichTextModel({
    required this.text,
    this.link = "",
    this.onTap,
    this.onHyperlinkClicked,
    this.textStyle,
  });

  void _onKnowMoreEventCallback() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.knowMore,
        attributeName: {'insurance_agree_consent_page': true});
  }

  void _onTandCEventCallback() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.tAndcClicked,
        attributeName: {'tnc_insurance': true});
  }

  RichTextModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    link = json['link'] ?? "";
    textStyle = null;
    if (text == "terms and conditions") {
      onHyperlinkClicked = _onTandCEventCallback;
    } else if (text == 'here' && link.isNotEmpty) {
      onHyperlinkClicked = _onKnowMoreEventCallback;
    }
  }
}
