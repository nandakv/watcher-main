import 'package:privo/app/mixin/app_analytics_mixin.dart';

import '../../../data/provider/auth_provider.dart';

class FAQHelpAndSupportAnalyticsMixin {
  final _appAnalytics = AppAnalyticsMixin();

  late String helpSupportClicked = "Help_Support_Clicked";
  late String categoryScreenLoaded = "Category_Screen_Loaded";
  late String categoryScreenClosed = "Category_Screen_Closed";
  late String contactPrivoClicked = "Contact_Privo_Clicked";
  late String contactPrivoEmailNumber = "Contact_Privo_Email_Number";
  late String contactPrivoClosed = "Contact_Privo_Closed";
  late String subCategoryLoaded = "SubCategory_Loaded";
  late String subCategoryClicked = "SubCategory_Clicked";
  late String qaListLoaded = "QA_List_Loaded";
  late String qaListClicked = "QA_List_Clicked";

  logContactPrivoEmailNumber(String type) async {
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: contactPrivoEmailNumber,
        attributeName: {
          type: true,
          "user_number": await AppAuthProvider.phoneNumber
        });
  }

  logHelpSupportClicked(bool isFromSupportMenu) {
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: helpSupportClicked,
        attributeName: {"support_menu": isFromSupportMenu});
  }

  logCategoryScreenLoaded() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: categoryScreenLoaded,
    );
  }

  logSubCategoryScreenLoaded(String categoryName) {
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: subCategoryLoaded,
        attributeName: {
          "category_name": categoryName,
        });
  }

  logSubCategoryClicked(String subCategoryName) {
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: subCategoryClicked,
        attributeName: {
          "sub_category_name": subCategoryName,
        });
  }

  logCategoryScreenClosed() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: categoryScreenClosed,
    );
  }

  logContactPrivoClicked() async {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: contactPrivoClicked,
    );
  }

  logContactPrivoClosed() {
    _appAnalytics.trackWebEngageEventWithAttribute(
      eventName: contactPrivoClosed,
    );
  }

  logQAListLoaded(
      {required String categoryName, required String subCategoryName}) {
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: qaListLoaded,
        attributeName: {
          "category_name": categoryName,
          "sub_category_name": subCategoryName,
        });
  }

  logQAListClicked(int index) {
    _appAnalytics.trackWebEngageEventWithAttribute(
        eventName: qaListClicked,
        attributeName: {
          "n": index + 1,
        });
  }
}
