abstract class PaymentGateway {
  void init(Function onSuccess, Function onFailure);

  // void onSuccess();

  // void onFailure();

  void start(String orderId);
}
