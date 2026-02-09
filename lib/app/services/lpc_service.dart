import 'package:get/get.dart';
import 'package:privo/app/models/home_screen_model.dart';

class LPCService {
  LPCService._();

  static final LPCService _instance = LPCService._();

  static LPCService get instance => _instance;

  List<LpcCard> lpcCards = [];
  List<LpcCard> upgradeCards = [];

  LpcCard? _activeCard;

  LpcCard? get activeCard => _activeCard;

  set activeCard(LpcCard? value) {
    _activeCard = value;
    Get.log("Active card set to ${_activeCard?.customerCif}");
    Get.log("Active card set to ${_activeCard?.appFormId}");
  }

  bool get isLpcCardTopUp =>
      (_activeCard?.lpcCardType ?? LPCCardType.loan) == LPCCardType.topUp;

  bool get isLpcCardLowAndGrow =>
      (_activeCard?.lpcCardType ?? LPCCardType.loan) == LPCCardType.lowngrow;
}
