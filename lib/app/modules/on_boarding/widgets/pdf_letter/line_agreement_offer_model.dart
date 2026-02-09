class LineAgreementOfferModel {
  OfferSection? offerSection;
  UplOfferSection? uplOfferSection;

  LineAgreementOfferModel.fromJson(Map<String, dynamic> json) {
    String lpc = json['loanProduct'];
    switch (lpc) {
      case "SBL":
      case "UPL":
        uplOfferSection = _computeUplOfferSection(json);
        break;
      case "CLP":
        offerSection = _computeOfferSection(json);
        break;
    }
  }

  UplOfferSection? _computeUplOfferSection(Map<String, dynamic> json) {
    return json['finalOffer']['offerSection'] == null
        ? null
        : UplOfferSection.fromJson(json['finalOffer']['offerSection']);
  }

  OfferSection? _computeOfferSection(Map<String, dynamic> json) {
    return json['finalOffer']['offerSection'] == null
        ? null
        : OfferSection.fromJson(json['finalOffer']['offerSection']);
  }
}

class OfferSection {
  late final num interest;
  late final double limitAmount;
  late final String processingFee;
  late final num maxTenure;
  late final num minTenure;

  OfferSection({
    required this.interest,
    required this.limitAmount,
    required this.processingFee,
    required this.maxTenure,
    required this.minTenure,
  });

  OfferSection.fromJson(Map<String, dynamic> json) {
    interest = num.parse((json['interest']).toString());
    limitAmount = double.parse(json['limitAmount'].toString());
    processingFee = json['processFee'].toString();
    minTenure = json['minTenure'];
    maxTenure = json['maxTenure'];
  }
}

class UplOfferSection {
  late final num roi;
  late final double loanAmount;
  late final String processingFee;
  late final int tenure;

  UplOfferSection.fromJson(Map<String, dynamic> json) {
    roi = num.parse(json['roi']);
    loanAmount = double.parse(json['loanAmount'].toString());
    processingFee = json['processFee'].toString();
    tenure = int.parse(json['tenure'].toString());
  }
}
