import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:privo/flavors.dart';

import '../on_boarding/widgets/verify_bank_statement/verify_bank_statement_logic.dart';

class PerfiosWebViewLogic extends GetxController {
  final logic = Get.find<VerifyBankStatementLogic>();

  bool canPop = true;
  String payLoad = "";
  String signature = "";

  // late FlutterWebviewPlugin flutterWebviewPlugin;

  String parseHtmlString() {
    return F.appFlavor == Flavor.prod
        ? """<html>
        <body onload='document.autoform.submit();'>
    <form name='autoform' method='post' action='https://perfios.com/KuberaVault/insights/start'>
    <input type='hidden' name='payload' value='$payLoad'>
    <input type='hidden' name='signature' value='$signature'>
    </form>
    </body>
    </html>
    """
        : """<html>
        <body onload='document.autoform.submit();'>
    <form name='autoform' method='post' action='https://demo.perfios.com/KuberaVault/insights/start'>
    <input type='hidden' name='payload' value='$payLoad'>
    <input type='hidden' name='signature' value='$signature'>
    </form>
    </body>
    </html>
    """;
  }

  setLoadingStateToSuccess() {
    logic.perfiosState = OnBoardingState.success;
    logic.isLoading = false;
    Get.back(result: true);
  }

  @override
  void onReady() {
    // flutterWebviewPlugin = FlutterWebviewPlugin();
    //
    // flutterWebviewPlugin.launch(
    //   Uri.dataFromString(parseHtmlString(), mimeType: 'text/html').toString(),
    //   rect: Rect.fromLTWH(0, Get.mediaQuery.padding.top, Get.width, Get.height),
    // );

    // flutterWebviewPlugin.resize(Rect.fromLTWH(0, Get.mediaQuery.padding.top, Get.width, Get.height));

    // flutterWebviewPlugin.onUrlChanged.listen(
    //   (String url) {
    //     Get.log("Logged " + url);
    //     if (url.startsWith(
    //         'https://www.publicdomainpictures.net/pictures/30000/velka/plain-white-background.jpg')) {
    //       canPop = true;
    //       setLoadingStateToSuccess();
    //     } else if (url.contains(F.appFlavor == Flavor.prod
    //         ? "https://perfios.com/KuberaVault/insights/creditSaison/netbankingFetch/progress"
    //         : "https://demo.perfios.com/KuberaVault/insights/creditSaison/netbankingFetch/progress")) {
    //       Get.log("Making can pop");
    //       canPop = false;
    //     } else {
    //       canPop = true;
    //     }
    //   },
    // );

    Get.log(parseHtmlString());
  }
}
