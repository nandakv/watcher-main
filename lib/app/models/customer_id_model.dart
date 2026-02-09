import 'dart:convert';

CustomerIdModel customerIdModelFromJson(String? str) =>
    CustomerIdModel.fromJson(json.decode(str!));

class CustomerIdModel {
  CustomerIdModel({
    required this.customerId,
  });

  late final String customerId;

  CustomerIdModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['customer_id'] = customerId;
    return _data;
  }
}
