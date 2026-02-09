import 'package:firebase_core/firebase_core.dart';
import 'package:privo/watcher_secrets.dart';

enum Flavor {
  qa,
  integration,
  uat,
  prod,
  dev,
}

class F {
  static Flavor? appFlavor;

  static EnvironmentModel get envVariables {
    switch (appFlavor) {
      case Flavor.qa:
        return EnvironmentModel(
          amplifyConfig: AmplifyConfig().amplifyConfigQA,
          privoBaseURL: "https://privoapi.qa.creditsaison.xyz",
          aquaManBaseURL: "https://aquaman.qa.creditsaison.xyz",
          karzaEmployeeSearchURL: "https://testapi.karza.in",
          scroogeBaseURL: "https://scrooge.qa.creditsaison.xyz",
          stormBaseURL: "https://storm.qa.creditsaison.xyz",
          appsFlyerCredentials: AppsFlyerCreds().lowEnv,
          karzaKeys: KarzaCreds().lowENV,
          razorPayEMandateKeys: RazorPayCreds().lowENV,
          hypervergeKeys: HyperVergeCreds().lowENV,
          gupShupCredentials: GupShupCreds().lowENV,
          aasdkCreds: IgnosisCreds().lowENV,
          digiLockerCreds: DigioCreds().lowENV,
          firebaseOptionsForIOS: FirebaseIosOption().qa,
          dataDogCreds: DDCreds().lowENV,
          googleLocationApiKey: GoogleLocationKey().lowENV,
          customDomainUrl: "uat.csifin.xyz",
          s3ObjectPrefixUrl:
              "https://s3.us-east-1.amazonaws.com/organizedbucket-int-329861406042-us-east-1/",
          experianTnCUrl:
              "https://customerconsent.int.creditsaison.in/consentTermAndCondition.html",
        );
      case Flavor.dev:
        return EnvironmentModel(
          amplifyConfig: AmplifyConfig().amplifyConfigDev,
          privoBaseURL: "https://privoapi.dev.creditsaison.xyz",
          aquaManBaseURL: "https://aquaman.dev.creditsaison.xyz",
          karzaEmployeeSearchURL: "https://testapi.karza.in",
          scroogeBaseURL: "https://scrooge.dev.creditsaison.xyz",
          stormBaseURL: "https://storm.dev.creditsaison.xyz",
          appsFlyerCredentials: AppsFlyerCreds().lowEnv,
          karzaKeys: KarzaCreds().lowENV,
          razorPayEMandateKeys: RazorPayCreds().lowENV,
          hypervergeKeys: HyperVergeCreds().lowENV,
          gupShupCredentials: GupShupCreds().lowENV,
          aasdkCreds: IgnosisCreds().lowENV,
          customDomainUrl: "uat.csifin.xyz",
          digiLockerCreds: DigioCreds().lowENV,
          firebaseOptionsForIOS: FirebaseIosOption().dev,
          dataDogCreds: DDCreds().lowENV,
          googleLocationApiKey: GoogleLocationKey().lowENV,
          s3ObjectPrefixUrl:
              "https://s3.us-east-1.amazonaws.com/organizedbucket-int-329861406042-us-east-1/",
          experianTnCUrl:
              "https://customerconsent.int.creditsaison.in/consentTermAndCondition.html",
        );

      case Flavor.uat:
        return EnvironmentModel(
          amplifyConfig: AmplifyConfig().amplifyConfigUAT,
          privoBaseURL: "https://privoapi.uat.creditsaison.xyz",
          aquaManBaseURL: "https://aquaman.uat.creditsaison.xyz",
          karzaEmployeeSearchURL: "https://testapi.karza.in",
          scroogeBaseURL: "https://scrooge.uat.creditsaison.xyz",
          stormBaseURL: "https://storm.uat.creditsaison.xyz",
          appsFlyerCredentials: AppsFlyerCreds().lowEnv,
          karzaKeys: KarzaCreds().lowENV,
          razorPayEMandateKeys: RazorPayCreds().lowENV,
          hypervergeKeys: HyperVergeCreds().lowENV,
          gupShupCredentials: GupShupCreds().lowENV,
          aasdkCreds: IgnosisCreds().lowENV,
          customDomainUrl: "uat.csifin.xyz",
          digiLockerCreds: DigioCreds().lowENV,
          firebaseOptionsForIOS: FirebaseIosOption().uat,
          dataDogCreds: DDCreds().lowENV,
          googleLocationApiKey: GoogleLocationKey().lowENV,
          s3ObjectPrefixUrl:
              "https://s3.ap-south-1.amazonaws.com/organizedbucket-uat-841515273180-ap-south-1/",
          experianTnCUrl:
              "https://customerconsent.int.creditsaison.in/consentTermAndCondition.html",
        );
      case Flavor.integration:
        return EnvironmentModel(
          amplifyConfig: AmplifyConfig().amplifyConfigIntegration,
          privoBaseURL: "https://privoapi.int.creditsaison.in",
          aquaManBaseURL: "https://aquaman.int.creditsaison.in",
          karzaEmployeeSearchURL: "https://testapi.karza.in",
          scroogeBaseURL: "https://scrooge.int.creditsaison.in",
          stormBaseURL: "https://storm.int.creditsaison.in",
          appsFlyerCredentials: AppsFlyerCreds().lowEnv,
          karzaKeys: KarzaCreds().lowENV,
          customDomainUrl: "uat.csifin.xyz",
          razorPayEMandateKeys: RazorPayCreds().lowENV,
          hypervergeKeys: HyperVergeCreds().lowENV,
          gupShupCredentials: GupShupCreds().lowENV,
          aasdkCreds: IgnosisCreds().lowENV,
          digiLockerCreds: DigioCreds().lowENV,
          firebaseOptionsForIOS: FirebaseIosOption().integration,
          dataDogCreds: DDCreds().lowENV,
          googleLocationApiKey: GoogleLocationKey().lowENV,
          s3ObjectPrefixUrl:
              "https://s3.us-east-1.amazonaws.com/organizedbucket-int-329861406042-us-east-1/",
          experianTnCUrl:
              "https://customerconsent.int.creditsaison.in/consentTermAndCondition.html",
        );
      case Flavor.prod:
        return EnvironmentModel(
          amplifyConfig: AmplifyConfig().amplifyConfigProd,
          privoBaseURL: "https://privoapi.creditsaison.in",
          aquaManBaseURL: "https://aquaman.creditsaison.in",
          karzaEmployeeSearchURL: "https://api.karza.in",
          scroogeBaseURL: "https://scrooge.creditsaison.in",
          stormBaseURL: "https://storm.creditsaison.in",
          appsFlyerCredentials: AppsFlyerCreds().prod,
          karzaKeys: KarzaCreds().prod,
          razorPayEMandateKeys: RazorPayCreds().prod,
          customDomainUrl: "uat.csifin.xyz",
          hypervergeKeys: HyperVergeCreds().prod,
          gupShupCredentials: GupShupCreds().prod,
          aasdkCreds: IgnosisCreds().prod,
          digiLockerCreds: DigioCreds().prod,
          firebaseOptionsForIOS: FirebaseIosOption().prod,
          dataDogCreds: DDCreds().prod,
          googleLocationApiKey: GoogleLocationKey().prod,
          s3ObjectPrefixUrl:
              "https://s3.ap-south-1.amazonaws.com/organizedbucket-production-595588206139-ap-south-1/",
          experianTnCUrl:
              "https://customerconsent.creditsaison.in/consentTermAndCondition.html",
        );
      default:
        return EnvironmentModel(
          amplifyConfig: AmplifyConfig().amplifyConfigIntegration,
          privoBaseURL: "https://privoapi.int.creditsaison.in",
          aquaManBaseURL: "https://aquaman.int.creditsaison.in",
          karzaEmployeeSearchURL: "https://testapi.karza.in",
          scroogeBaseURL: "https://scrooge.int.creditsaison.in",
          stormBaseURL: "https://storm.int.creditsaison.in",
          appsFlyerCredentials: AppsFlyerCreds().lowEnv,
          karzaKeys: KarzaCreds().lowENV,
          razorPayEMandateKeys: RazorPayCreds().lowENV,
          hypervergeKeys: HyperVergeCreds().lowENV,
          gupShupCredentials: GupShupCreds().lowENV,
          customDomainUrl: "uat.csifin.xyz",
          aasdkCreds: IgnosisCreds().lowENV,
          digiLockerCreds: DigioCreds().lowENV,
          firebaseOptionsForIOS: FirebaseIosOption().integration,
          dataDogCreds: DDCreds().lowENV,
          googleLocationApiKey: GoogleLocationKey().lowENV,
          s3ObjectPrefixUrl:
              "https://s3.us-east-1.amazonaws.com/organizedbucket-int-329861406042-us-east-1/",
          experianTnCUrl:
              "https://customerconsent.int.creditsaison.in/consentTermAndCondition.html",
        );
    }
  }
}

class EnvironmentModel {
  String amplifyConfig;
  String privoBaseURL;
  String aquaManBaseURL;
  String scroogeBaseURL;
  String karzaEmployeeSearchURL;
  String stormBaseURL;
  KarzaKeys karzaKeys;
  HypervergeKeys hypervergeKeys;
  RazorPayEMandateKeys razorPayEMandateKeys;
  GupShupCredentials gupShupCredentials;
  AASDKCreds aasdkCreds;
  DigioDigiLockerCreds digiLockerCreds;
  FirebaseOptions firebaseOptionsForIOS;
  DataDogCreds dataDogCreds;
  AppsFlyerCredentials appsFlyerCredentials;
  String googleLocationApiKey;
  String s3ObjectPrefixUrl;
  String experianTnCUrl;
  String privacyPolicyUrl;
  String termsAndConditionUrl;
  String customDomainUrl;

  EnvironmentModel({
    required this.amplifyConfig,
    required this.scroogeBaseURL,
    required this.privoBaseURL,
    required this.aquaManBaseURL,
    required this.karzaEmployeeSearchURL,
    required this.stormBaseURL,
    required this.karzaKeys,
    required this.hypervergeKeys,
    required this.razorPayEMandateKeys,
    required this.gupShupCredentials,
    required this.aasdkCreds,
    required this.digiLockerCreds,
    required this.firebaseOptionsForIOS,
    required this.dataDogCreds,
    required this.appsFlyerCredentials,
    required this.googleLocationApiKey,
    required this.s3ObjectPrefixUrl,
    required this.experianTnCUrl,
    required this.customDomainUrl,
    this.privacyPolicyUrl =
        "https://regulatory.creditsaison.in/csi-app-privacy-policy",
    this.termsAndConditionUrl =
        "https://regulatory.creditsaison.in/csi-app-terms-and-conditions",
  });
}

class AppsFlyerCredentials {
  final String appID;
  final String appsFlyerKey;
  final String templateId;

  AppsFlyerCredentials({
    required this.appID,
    required this.appsFlyerKey,
    required this.templateId,
  });
}

class GupShupCredentials {
  String url;
  String userId;
  String password;

  GupShupCredentials(
      {required this.url, required this.userId, required this.password});
}

class DigioDigiLockerCreds {
  String url;
  String clientSecret;
  String clientID;
  String template;

  DigioDigiLockerCreds({
    required this.url,
    required this.clientSecret,
    required this.clientID,
    required this.template,
  });
}

class DataDogCreds {
  String clientToken;
  String applicationId;
  String env;
  String serviceName;

  DataDogCreds({
    required this.clientToken,
    required this.applicationId,
    required this.env,
    required this.serviceName,
  });
}

class KarzaKeys {
  String url;
  String karzaKey;
  String environment;

  KarzaKeys(
      {required this.url, required this.karzaKey, required this.environment});
}

class HypervergeKeys {
  String appId;
  String appKey;

  HypervergeKeys({required this.appId, required this.appKey});
}

class RazorPayEMandateKeys {
  String apiKey;
  String env;

  RazorPayEMandateKeys({required this.apiKey, required this.env});
}

class AASDKCreds {
  String appIdentifier;
  String clientId;
  String clientSecret;
  String organisationId;
  String iFrameURL;

  AASDKCreds({
    required this.appIdentifier,
    required this.clientId,
    required this.clientSecret,
    required this.organisationId,
    required this.iFrameURL,
  });
}
