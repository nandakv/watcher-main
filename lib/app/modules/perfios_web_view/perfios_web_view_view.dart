import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';

import 'perfios_web_view_logic.dart';

class PerfiosWebViewPage extends StatefulWidget {
  PerfiosWebViewPage({Key? key}) : super(key: key);

  @override
  State<PerfiosWebViewPage> createState() => _PerfiosWebViewPageState();
}

class _PerfiosWebViewPageState extends State<PerfiosWebViewPage> {
  final logic = Get.find<PerfiosWebViewLogic>();


  @override
  void initState() {
    List<String> data = Get.arguments;
    logic.payLoad = data[0];
    logic.signature = data[1];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // logic.flutterWebviewPlugin.hide();
        var result = await Get.defaultDialog(
            title: "Are you sure you want to quit?",
            middleText: "",
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back(result: true);
            },
            onCancel: (){});
        if(result != null && result){
          return true;
        } else {
          // logic.flutterWebviewPlugin.show();
          // logic.flutterWebviewPlugin.stopLoading();
          return false;
        }
      },
      child: Container(),
      // child: const SafeArea(
      //   top: true,
      //   child: WebviewScaffold(
      //     scrollBar: false,
      //     withLocalStorage: true,
      //     url: "",
      //   ),
      // ),
    );
  }
}

