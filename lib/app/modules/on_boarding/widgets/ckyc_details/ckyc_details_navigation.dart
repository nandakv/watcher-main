import 'package:privo/app/modules/on_boarding/on_boarding_abstract_class.dart';

abstract class OnBoardingCKYCDetailsNavigation extends OnBoardingNavigationBase{

  onSelectCKYC({required String imagePath});

  onSelectAadhaar({required bool fromCKYC});

}