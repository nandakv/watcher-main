import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///This are the local Storage System

class LocalRepository {
  static FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static Future<String> get(String key) async =>
      await secureStorage.read(key: key) ?? "";

  static Future put(String key, String value) async =>
      await secureStorage.write(key: key, value: value);

  static Future clearStorage() async => await secureStorage.deleteAll();

  static Future clearValue(String key) async =>
      await secureStorage.delete(key: key);
}
