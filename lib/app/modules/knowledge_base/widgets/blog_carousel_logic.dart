import 'package:get/get.dart';

class BlogCarouselLogic extends GetxController {
  int _carouselIndex = 0;

  final String CAROUSEL_INDICATOR_KEY = "CAROUSEL_INDICATOR_KEY";

  int get carouselIndex => _carouselIndex;

  set carouselIndex(int value) {
    _carouselIndex = value;
    update([CAROUSEL_INDICATOR_KEY]);
  }
}
