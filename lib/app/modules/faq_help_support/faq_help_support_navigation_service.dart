part of '../../routes/app_pages.dart';

class FaqHelpAndSupportNavigationService
    implements NavigationService<FAQHelpSupportArguments> {
  @override
  Future<U?>? navigate<U>(
      {required FAQHelpSupportArguments routeArguments}) async {
    return await Get.toNamed(
      Routes._FAQ_HELP_AND_SUPPORT,
      arguments: routeArguments,
    );
  }
}
