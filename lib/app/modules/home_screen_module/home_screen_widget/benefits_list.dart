import '../../../../res.dart';
import '../model/benefits_model.dart';

late List<BenefitsModel> benefitsList = [
  BenefitsModel(iconPath: Res.paperless, text: "100% Paperless\nProcess"),
  BenefitsModel(iconPath: Res.instant, text: "Instant\nApproval"),
  BenefitsModel(
      iconPath: Res.interestAmount, text: "Interest Only on Withdrawn Amount"),
  BenefitsModel(iconPath: Res.emi, text: "Flexible EMI\nOptions"),
  BenefitsModel(
      iconPath: Res.fundTransfer,
      text: "Transfer Funds to Your Bank in Minutes"),
];
