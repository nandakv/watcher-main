import 'package:flutter/material.dart';

import '../faq/faq_model.dart';

@optionalTypeArgs
abstract class KnowMoreHelper {
  // Title of the section
  String get knowMoreTitle;

  // Illustration path or asset reference
  String get knowMoreIllustration;

  // Illustration path or asset reference
  String? get knowMoreBackground;

  // Message or description for the section
  String get knowMoreMessage;

  // Body widget for the main content
  Widget get knowMoreBody;

  // Optional FAQ model
  FAQModel? get knowMoreFaqModel;

  // Optional button widget
  Widget get knowMoreButton => const SizedBox();

  // Title for the app bar
  String get knowMoreAppBarTitle;

  // Optional consent widget

  Widget get consentWidget => const SizedBox.shrink();

// Optional "Powered by" widget
  Widget get poweredByWidget => const SizedBox();

  void onKnowMoreBackPressed();

  void onClosePressed();
  
  Widget? get backButton;

  Widget? get closeButton;

}
