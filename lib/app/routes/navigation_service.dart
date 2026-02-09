part of './app_pages.dart';

abstract class NavigationService<T extends RouteArguments> {
  Future<U?>? navigate<U>({required T routeArguments});
}
