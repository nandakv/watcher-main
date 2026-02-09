import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/installed_app_model.dart';

import '../../../../../theme/app_colors.dart';
import '../bank_details_logic.dart';

class UpiAppsPopupWidget extends StatelessWidget {
  UpiAppsPopupWidget({Key? key}) : super(key: key);

  final logic = Get.find<BankDetailsLogic>();

  Widget _openWithTextWidget() {
    return const Text(
      "Open with",
      style: TextStyle(
        fontSize: 16,
        color: blue,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _closeButton() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: const Icon(
        Icons.close,
      ),
    );
  }

  Widget upiAppTile(InstalledAppModel upiApp) {
    return InkWell(
      onTap: () {
        Get.back();
        logic.startReversePennyDrop(upiApp);
      },
      child: Column(
        children: [
          Image.memory(
            Uint8List.fromList(upiApp.icon),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              upiApp.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                children: [
                  _openWithTextWidget(),
                  const Spacer(),
                  _closeButton(),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.680,
                crossAxisSpacing: 26.0,
                mainAxisSpacing: 26.0,
              ),
              itemCount: logic.installedUpiApps.length,
              itemBuilder: (context, index) {
                InstalledAppModel upiApp = logic.installedUpiApps[index];
                return upiAppTile(upiApp);
              },
            ),
          ],
        ),
      ),
    );
  }
}
