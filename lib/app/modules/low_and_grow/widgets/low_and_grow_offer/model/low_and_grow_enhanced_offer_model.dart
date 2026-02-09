///Response model that have CheckAppFormModel as base
///Helps in catching the json parsing errors
///If parsing fails we have the response state

enum UpgradedFeatureType {
  roi,
  tenure,
  limit,
  pf,
  limitAndPf,
  roiAndTenure,
  roiAndLimit,
  limitAndTenure,
  roiAndPf,
  tenureAndPf,
  roiLimitTenure,
  roiLimitPf,
  roiTenurePf,
  limitTenurePf,
  all
}

class LowAndGrowEnhancedOfferModel {
  EnhancedOfferSection? enhancedOfferSection;
  OfferSection? offerSection;
  UpgradedFeatures? upgradedFeatures;

  LowAndGrowEnhancedOfferModel.fromJson(Map<String, dynamic> json) {
    enhancedOfferSection = json['enhancedOffer']['offerSection'] == null
        ? null
        : EnhancedOfferSection.fromJson(json['enhancedOffer']['offerSection']);
    offerSection = json['finalOffer']['offerSection'] == null
        ? null
        : OfferSection.fromJson(json['finalOffer']['offerSection']);
    upgradedFeatures = json['enhancedOffer']['upgradedFeatures'] == null
        ? null
        : UpgradedFeatures.fromJson(json['enhancedOffer']['upgradedFeatures']);
  }
}

class EnhancedOfferSection {
  late final num interest;
  late final double limitAmount;
  late final String processingFee;
  late final int maxTenure;
  late final int minTenure;

  EnhancedOfferSection({
    required this.interest,
    required this.limitAmount,
    required this.processingFee,
    required this.maxTenure,
    required this.minTenure,
  });

  EnhancedOfferSection.fromJson(Map<String, dynamic> json) {
    interest = json['interest'];
    limitAmount = double.parse(json['limitAmount'].toString());

    processingFee = json['processFee'].toString();
    minTenure = int.parse(json['minTenure'].toString());
    maxTenure = int.parse(json['maxTenure'].toString());
  }
}

class OfferSection {
  late final num interest;
  late final double limitAmount;
  late final String processingFee;
  late final double maxTenure;
  late final double minTenure;

  OfferSection({
    required this.interest,
    required this.limitAmount,
    required this.processingFee,
    required this.maxTenure,
    required this.minTenure,
  });

  OfferSection.fromJson(Map<String, dynamic> json) {
    interest = json['interest'];
    limitAmount = double.parse(json['limitAmount'].toString());
    processingFee = json['processFee'].toString();
    minTenure = double.parse(json['minTenure'].toString());
    maxTenure = double.parse(json['maxTenure'].toString());
  }
}

class UpgradedFeatures {
  late final int interest;
  late final int limitAmount;
  late final int tenure;
  late final int processingFee;
  late final UpgradedFeatureType upgradedFeatureType;

  UpgradedFeatures({
    required this.interest,
    required this.limitAmount,
    required this.tenure,
    required this.processingFee,
    required this.upgradedFeatureType,
  });

  UpgradedFeatures.fromJson(Map<String, dynamic> json) {
    interest = double.parse(json['roi'].toString()).toInt();
    limitAmount = double.parse(json['limit'].toString()).toInt();
    tenure = double.parse(json['tenure'].toString()).toInt();
    processingFee = double.parse(json['pf'].toString()).toInt();
    upgradedFeatureType = upgradeFeatureMap[
        "roi:$interest,limit:$limitAmount,tenure:$tenure,pf:$processingFee"]!;
  }

  Map<String, UpgradedFeatureType> get upgradeFeatureMap => {
        "roi:1,limit:0,tenure:0,pf:0": UpgradedFeatureType.roi,
        "roi:0,limit:1,tenure:0,pf:0": UpgradedFeatureType.limit,
        "roi:0,limit:0,tenure:1,pf:0": UpgradedFeatureType.tenure,
        "roi:0,limit:0,tenure:0,pf:1": UpgradedFeatureType.pf,

        "roi:1,limit:1,tenure:1,pf:0": UpgradedFeatureType.roiLimitTenure, //2 feature
        "roi:1,limit:1,tenure:0,pf:1": UpgradedFeatureType.roiLimitPf, //3 feature
        "roi:1,limit:0,tenure:1,pf:1": UpgradedFeatureType.roiTenurePf, //2 feature
        "roi:0,limit:1,tenure:1,pf:1": UpgradedFeatureType.limitTenurePf, //2 feature

        "roi:0,limit:1,tenure:0,pf:1": UpgradedFeatureType.limitAndPf, //2 feature
        "roi:1,limit:0,tenure:1,pf:0": UpgradedFeatureType.roiAndTenure, //2 feature
        "roi:1,limit:1,tenure:0,pf:0": UpgradedFeatureType.roiAndLimit, //2 feature
        "roi:0,limit:1,tenure:1,pf:0": UpgradedFeatureType.limitAndTenure, //2 feature
        "roi:1,limit:0,tenure:0,pf:1": UpgradedFeatureType.roiAndPf,//2 feature
        "roi:0,limit:0,tenure:1,pf:1": UpgradedFeatureType.tenureAndPf, //2 feature
        "roi:1,limit:1,tenure:1,pf:1": UpgradedFeatureType.all //3 feature
      };
}
