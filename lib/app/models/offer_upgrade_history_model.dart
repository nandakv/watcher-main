class OfferUpgradeHistoryModel {
  OfferUpgradeHistoryModel({
    required this.pastOffers,
    required this.finalOffer,
    required this.docs,
  });

  late final List<OfferSection> pastOffers;
  late final FinalOffer finalOffer;
  late final Docs docs;

  OfferUpgradeHistoryModel.fromJson(Map<String, dynamic> json) {
    pastOffers = json['pastOffers'] == null
        ? []
        : List.from(json['pastOffers'])
            .map((e) => OfferSection.fromJson(e))
            .toList();
    finalOffer = FinalOffer.fromJson(json['finalOffer']);
    docs = Docs.fromJson(json['docs']);
  }
}

class Docs {
  Docs({
    required this.sanctionLetter,
  });

  late final String sanctionLetter;

  Docs.fromJson(Map<String, dynamic> json) {
    sanctionLetter = json['sanction_letter'] ?? "";
  }
}

class FinalOffer {
  FinalOffer({
    required this.offerSection,
  });

  late final OfferSection offerSection;

  FinalOffer.fromJson(Map<String, dynamic> json) {
    offerSection = OfferSection.fromJson(json['offerSection']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['offerSection'] = offerSection.toJson();
    return _data;
  }
}

class OfferSection {
  OfferSection(
      {required this.income,
      required this.minWithdrwalAmount,
      required this.foir,
      required this.validTill,
      required this.salaryDay,
      required this.AAEligible,
      required this.offerStatus,
      required this.segmentName,
      required this.maxTenure,
      required this.interest,
      required this.limitAmount,
      required this.id,
      required this.minTenure,
      required this.processFee,
      required this.loanAgreement,
      required this.sanctionLetter});

  late final num income;
  late final num minWithdrwalAmount;
  late final num foir;
  late final String validTill;
  late final num salaryDay;
  late final String AAEligible;
  late final String offerStatus;
  late final String segmentName;
  late final num maxTenure;
  late final num interest;
  late final String limitAmount;
  late final String id;
  late final num minTenure;
  late final num processFee;
  late final String loanAgreement;
  late final String sanctionLetter;

  OfferSection.fromJson(Map<String, dynamic> json) {
    income = json['income'];
    minWithdrwalAmount = json['minWithdrwalAmount'];
    foir = json['foir'];
    validTill = json['validTill'];
    salaryDay = json['salaryDay'];
    AAEligible = json['AA_eligible'];
    offerStatus = json['offerStatus'];
    segmentName = json['segmentName'];
    maxTenure = json['maxTenure'];
    interest = json['interest'];
    limitAmount = json['limitAmount'];
    id = json['id'];
    minTenure = json['minTenure'];
    processFee = json['processFee'];
    loanAgreement = json['loan_agreement'] ?? "";
    sanctionLetter = json['sanction_letter'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['income'] = income;
    _data['minWithdrwalAmount'] = minWithdrwalAmount;
    _data['foir'] = foir;
    _data['validTill'] = validTill;
    _data['salaryDay'] = salaryDay;
    _data['AA_eligible'] = AAEligible;
    _data['offerStatus'] = offerStatus;
    _data['segmentName'] = segmentName;
    _data['maxTenure'] = maxTenure;
    _data['interest'] = interest;
    _data['limitAmount'] = limitAmount;
    _data['id'] = id;
    _data['minTenure'] = minTenure;
    _data['processFee'] = processFee;
    _data['loan_agreement'] = loanAgreement;
    _data['sanction_letter'] = sanctionLetter;
    return _data;
  }
}
