// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:privo/app/models/home_screen_card_model.dart';
// import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
// import 'package:privo/app/modules/home_screen_module/widgets/home_page_top_widget.dart';

// import 'home_page_set_up_auto_pay.dart';
// import 'home_screen_timeline_widget.dart';

// class EmandateHomeScreenWidget extends StatelessWidget {
//   EmandateHomeScreenWidget(
//       {Key? key, required this.emandateDetailsHomePageModel})
//       : super(key: key);

//   final EmandateDetailsHomeScreenType emandateDetailsHomePageModel;
//   final logic = Get.find<HomeScreenLogic>();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         HomeScreenTopWidget(
//           infoText: logic.homeScreenModel.info,
//           showHamburger: true,
//           background: logic.homeScreenModel.backGround,
//           scaffoldKey: logic.homePageScaffoldKey,
//           widget: HomePageTopEmandateWidget(
//             emandateDetailsHomePageModel: emandateDetailsHomePageModel,
//           ),
//         ),
//         HomeScreenTimelineWidget(),
//       ],
//     );
//   }
// }
