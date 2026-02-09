import 'package:get/get.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';

import '../../../../common_widgets/top_snackbar_widget.dart';
import '../../../../data/provider/auth_provider.dart';
import '../../../../firebase/analytics.dart';
import '../../../../utils/web_engage_constant.dart';

class ExpiryHomePageCardLogic extends GetxController {
  String? _ctaText;

  String? get ctaText => _ctaText;

  late String NOTIFY_ME = "Notify Me";

  set ctaText(String? value) {
    _ctaText = value;
    update();
  }

  final homeScreenLogic = Get.find<HomeScreenLogic>();

  @override
  void onInit() {
    _checkNotifyMeStatus();
    super.onInit();
  }

  _checkNotifyMeStatus() async {
    if (!(await AppAuthProvider.isNotifyMeClicked)) {
      ctaText = NOTIFY_ME;
    }
  }

  onNotifyMe() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.homepageExpiredCardNotifyMe);
    showTopSnackBar("You will receive a notification through email and SMS");
    AppAuthProvider.setNotifyMeClicked();
    ctaText = null;
  }

  void onAfterFirstLayout() {
    homeScreenLogic.toggleHomePageTitle("");
  }
}
