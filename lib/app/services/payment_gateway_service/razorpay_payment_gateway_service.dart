import 'package:get/get.dart';
import 'package:privo/app/services/payment_gateway_service/models/payment_gateway_abstract.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../flavors.dart';
import '../../data/provider/auth_provider.dart';

class RazorPayPaymentGateway implements PaymentGateway {
  late Razorpay _razorpay;
  // late Function onSuccesss;

  @override
  void init(Function onSuccess, Function onFailure) {
    _razorpay = Razorpay();
    // onSuccesss=onSuccess;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
  }

  // @override
  // void onSuccess(){
  //   onSuccesss();

  // }

  @override
  void start(String orderId) async {
    var options = {
      'key': F.envVariables.razorPayEMandateKeys.apiKey,
      "order_id": orderId,
      'prefill': {
        'contact': await AppAuthProvider.phoneNumber,
      },
      "method": {
        "netbanking": true,
        "card": true,
        "wallet": false,
        "upi": true
      },
      "timeout": 300,
      "name": "Payment",
      "description": "Re Payment for Credit Saison India",
      "theme": {"color": "#004097"},
    };

    Get.log("razorpay options - $options");

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.log("Error opening sdk ${e.toString()}");
      rethrow;
    }
  }
}
