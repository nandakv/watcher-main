///For json parsing from backend api's
class BankDetailsBaseModel {
  String? reportId;
  String? accountNumber;
  bool accountNumberMasked;
  String? ifscCode;
  bool ifscCodeMasked;
  String? accountType;
  String bankName;

  BankDetailsBaseModel(
      {required this.accountNumber,
      required this.accountNumberMasked,
      required this.ifscCode,
      required this.ifscCodeMasked,
      required this.accountType,
      required this.bankName,
      this.reportId});

  factory BankDetailsBaseModel.fromJson(Map<String, dynamic> json) {
    var bankDetailsBaseModel = BankDetailsBaseModel(
        reportId: json["report_id"],
        accountNumber: json["account_number"],
        accountNumberMasked: json["account_number_masked"] ?? false,
        ifscCode: json["ifsc_code"],
        ifscCodeMasked: json["ifsc_code_masked"] ?? false,
        accountType: json['account_type'] ?? "Savings",
        bankName: json['bankName'] ?? "");

    _computeBankDetailsMasking(bankDetailsBaseModel);
    _computeIfscDetailsMasking(bankDetailsBaseModel);
    _computeAccountType(bankDetailsBaseModel);

    return bankDetailsBaseModel;
  }

  static void _injectTestDataBankAccount(BankDetailsBaseModel model) {
    // model.accountNumber = null;
    model.accountNumber = "";
    // model.accountNumber = "XXXX78915";
  }

  static void _injectTestDataIfscCode(BankDetailsBaseModel model) {
    // model.ifscCode = null;
    // model.ifscCode = "";
    model.ifscCode = "HDFC0000094";
  }

  static _computeBankDetailsMasking(BankDetailsBaseModel bankDetailsBaseModel) {
    if (bankDetailsBaseModel.accountNumber == null ||
        (bankDetailsBaseModel.accountNumber ?? "").isEmpty ||
        (bankDetailsBaseModel.accountNumber ?? "")
            .toLowerCase()
            .contains("x")) {
      bankDetailsBaseModel.accountNumberMasked = true;
    } else {
      bankDetailsBaseModel.accountNumberMasked = false;
    }
  }

  static _computeIfscDetailsMasking(BankDetailsBaseModel bankDetailsBaseModel) {
    if (bankDetailsBaseModel.ifscCode == null ||
        (bankDetailsBaseModel.ifscCode ?? "").isEmpty ||
        (bankDetailsBaseModel.ifscCode ?? "").toLowerCase().contains("x")) {
      bankDetailsBaseModel.ifscCodeMasked = true;
    } else {
      bankDetailsBaseModel.ifscCodeMasked = false;
    }
  }

  static void _computeAccountType(BankDetailsBaseModel bankDetailsBaseModel) {
    ///todo: compute account type
  }
}

///For passing between the screen and is extension of base model
class BankDetailsModel extends BankDetailsBaseModel {
  BankDetailsModel(
      {
      String? accountNumber,
      String? ifscCode,
        required String bankName,
        String? accountType,
      required bool accountNumberMasked,
      required bool ifscCodeMasked})
      : super(
            accountType: accountType,
            bankName: bankName,
            accountNumber: accountNumber,
            ifscCode: ifscCode,
            accountNumberMasked: accountNumberMasked,
            ifscCodeMasked: ifscCodeMasked,
            reportId: '');

}
