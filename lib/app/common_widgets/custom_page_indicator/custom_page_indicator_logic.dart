import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomPageIndicatorLogic extends GetxController {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    update();
  }

  void didChangePage(PageController controller) {
    if (!controller.hasClients) return;
    currentIndex = (controller.page ?? 0.0).toInt();
  }
}
