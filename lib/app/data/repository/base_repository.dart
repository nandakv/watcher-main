import 'package:privo/app/data/provider/auth_provider.dart';

import '../../../flavors.dart';

class BaseRepository {
  static final String _baseUrl = F.envVariables.privoBaseURL;
  static const String _version = "/api/v1";
  static const String _version2 = "/api/v2";
  static const String _batMan = "/bat";
  static const String _valkyrie = "/val";
  static const String _shield = "/shi";
  static const String _poseidon = "/pos";
  static const String _bifrost = '/bif';
  static const String _aquaMan = '/aqu';
  static const String _drStrange = '/drs';
  static const String _morpheus = '/mrp';
  static const String _groot = '/gro';
  static const String _magnus = '/mgs';
  final String _karzaUrl = "${F.envVariables.karzaEmployeeSearchURL}/v3";
  final String _digioUrl = "${F.envVariables.digiLockerCreds.url}";

  String get baseUrl {
    return _baseUrl + _version;
  }

  String get bifrostBaseUrl {
    return _baseUrl + _bifrost + _version;
  }

  String get valBaseUrl {
    return _baseUrl + _valkyrie + _version;
  }

  static String getBaseUrl() {
    return _baseUrl;
  }

  String get karzaUrl {
    return _karzaUrl;
  }

  String get shieldBaseUrl {
    return _baseUrl + _shield + _version;
  }

  String get batManBaseUrl {
    return _baseUrl + _batMan + _version;
  }

  String get poseidonBaseUrl {
    return _baseUrl + _poseidon + _version;
  }

  String get aquManBaseUrl {
    return _baseUrl + _aquaMan + _version;
  }

  String get aquManV2BaseUrl {
    return _baseUrl + _aquaMan + _version2;
  }

  String get drStrangeBaseUrl {
    return _baseUrl + _drStrange + _version;
  }

  String get morpheusBaseUrl {
    return _baseUrl + _morpheus + _version;
  }

  String get morpheusBaseUrlVersion2 {
    return _baseUrl + _morpheus + _version2;
  }

  String get grootBaseUrl {
    return _baseUrl + _groot + _version;
  }

  String get magnusBaseUrl {
    return _baseUrl + _magnus + _version;
  }

  String get digioURL {
    return _digioUrl;
  }

  String get appFormId => AppAuthProvider.appFormID;

  Future<String> get phoneNumber => AppAuthProvider.phoneNumber;
}
