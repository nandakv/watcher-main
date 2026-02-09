 class BankAccount {
  late String bankName;
  late String accountNumber;
  late String ifscCode;
  late String vendor;
  late bool isAccountNumberMasked;

  BankAccount.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'] ?? "";
    vendor = json['vendor'] ?? "";
    isAccountNumberMasked = json['isAccountNumberMasked'] ?? false;
  }
}
