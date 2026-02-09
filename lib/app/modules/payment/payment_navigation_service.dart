part of '../../routes/app_pages.dart';

class PaymentNavigationService
    implements NavigationService<PaymentViewArgumentModel> {
  @override
  Future<T?>? navigate<T>(
      {required PaymentViewArgumentModel routeArguments}) async {
    return await Get.toNamed(
      Routes._PAYMENT_SCREEN,
      arguments: routeArguments,
    );
  }
}
