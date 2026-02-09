import 'package:privo/app/models/arguments_model/route_arguments.dart';
import 'package:privo/app/models/home_screen_model.dart';

class FAQHelpSupportArguments extends RouteArguments {
  bool isFromHomePage;
  bool isFromSupportMenu;
  LpcCard lpcCard;

  FAQHelpSupportArguments({
    required this.isFromHomePage,
    required this.isFromSupportMenu,
    required this.lpcCard,
  });
}
