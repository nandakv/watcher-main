import 'package:privo/app/services/payment_gateway_service/models/payment_gateway_abstract.dart';
import 'package:privo/app/services/payment_gateway_service/razorpay_payment_gateway_service.dart';

enum PAYMENT_GATEWAY_PROVIDER {
  razorPay,
}

class PaymentGateWayService {
  final PAYMENT_GATEWAY_PROVIDER paymentGatewayProvider;
  late PaymentGateway _paymentGateway;

  PaymentGateWayService({required this.paymentGatewayProvider});

  void init({required Function onSuccess, required Function onFailure}) {
    _paymentGateway = _getPaymentGateway();
    _paymentGateway.init(onSuccess, onFailure);
  }

  void start(String orderId) {
    _paymentGateway.start(orderId);
  }

  PaymentGateway _getPaymentGateway() {
    switch (paymentGatewayProvider) {
      case PAYMENT_GATEWAY_PROVIDER.razorPay:
        return RazorPayPaymentGateway();
      default:
        return RazorPayPaymentGateway();
    }
  }
}
