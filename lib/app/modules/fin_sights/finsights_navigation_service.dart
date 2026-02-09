part of '../../routes/app_pages.dart';

class FinSightsNavigationService implements NavigationService {
  @override
  Future<U?>? navigate<U>({required RouteArguments routeArguments}) async {
    return await Get.toNamed(Routes.FIN_SIGHTS, arguments: routeArguments);
  }
}
