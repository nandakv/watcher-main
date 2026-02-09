import 'package:privo/res.dart';

mixin BankLogoMixin {
  /// Mapped perfiosBankName key from supported bank api since this key value is consistent accross env
  late final Map<String, String> perfiosBankLogoMapping = {
    "HDFC Bank, India": Res.hdfcBankLogo,
    "ICICI Bank, India": Res.iciciBankLogo,
    "State Bank of India, India": Res.sbiBankLogo,
    "Axis Bank, India": Res.axisBankLogo,
    "Kotak Mahindra Bank, India": Res.kotakBankLogo,
    "Bank of Baroda, India": Res.bankOfBarodaLogo,
    "Punjab National Bank, India": Res.punjabNationalBankLogo,
    "Indian Overseas Bank, India": Res.indianOverseasBankLogo,
    "Union Bank of India, India": Res.unionBankLogo,
    "Canara Bank, India": Res.canaraBankLogo,
    "IndusInd Bank, India": Res.indusindBankLogo,
    "Federal Bank, India": Res.federalBankLogo,
    "Yes Bank, India": Res.yesBankLogo,
    "AU Small Finance Bank, India": Res.auSmallFinanceBankLogo,
    "Indian Bank, India": Res.indianBankLogo,
    "IDBI, India": Res.idbiBankLogo,
    "Central Bank of India, India": Res.centralBankOfIndiaLogo,
  };

  late final Map<String, String> experianBankNameMapping = {
    "HDFC Bank Ltd": Res.hdfcBankLogo,
    "ICICI Bank": Res.iciciBankLogo,
    "AU Small Finance Bank": Res.auSmallFinanceBankLogo,
    "Yes Bank": Res.yesBankLogo,
    "Axis Bank": Res.axisBankLogo,
    "Kotak Mahindra Bank Limited": Res.kotakBankLogo,
    "SBI Cards and Payment Services Private Limited": Res.sbiBankLogo,
    "Kisetsu Saison Finance (India) Private Limited": Res.creditSaisonLogo
  };

  String getExperianBankLogo({required String experianBankName}) {
    return experianBankNameMapping[experianBankName] ??
        Res.experianDefaultBankLogo;
  }

  String getBankLogo({required String perfiosBankName}) {
    return perfiosBankLogoMapping[perfiosBankName] ?? Res.genericBankLogo;
  }
}
