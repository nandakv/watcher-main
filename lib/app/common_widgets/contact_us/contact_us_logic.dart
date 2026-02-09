import 'package:get/get.dart';
import 'package:privo/app/modules/help_support/widget/contact_us_card.dart';
import 'package:privo/app/modules/on_boarding/analytics/faq_help_and_support_analytics_mixin.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactUsLogic extends GetxController
    with FAQHelpAndSupportAnalyticsMixin {
  onContactUs() async {
    logContactPrivoClicked();
    await Get.bottomSheet(
      ContactUsCard(
        onCallClicked: onContactDetailsClicked,
        onEmailClicked: onEmailClicked,
      ),
    );
    logContactPrivoClosed();
  }

  onContactDetailsClicked() {
    logContactPrivoEmailNumber("number");
    launchUrlString('tel:18001038961', mode: LaunchMode.externalApplication);
  }

  onEmailClicked() {
    logContactPrivoEmailNumber("email");
    launchUrlString("mailto:support@creditsaison-in.com");
  }
}
