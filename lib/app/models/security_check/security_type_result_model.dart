class SecurityTypeResultModel {
  late final bool isError;
  late final bool isDetected;
  late final Map<String, String> logs;
  late final String errorMessage;

  SecurityTypeResultModel({
    this.isError = false,
    this.isDetected = false,
    this.logs = const <String, String>{},
    this.errorMessage = "",
  });

  SecurityTypeResultModel.fromJson(Map json) {
    String logMsg = json['logMessage'] ?? "";
    isError = json['isError'] ?? false;
    isDetected = json['isDetected'] ?? false;
    logs = stringToMap(logMsg);
    errorMessage = json['errorMessage'] ?? "";
  }

  Map<String, String> stringToMap(String logString) {
    Map<String, String> map = {};
    List<String> logList = logString.split(",");
    for (String log in logList) {
      List<String> logSplit = log.split(":");
      if (logSplit.length == 2) {
        map[logSplit[0]] = logSplit[1];
      }
    }
    map['is_detected'] = isDetected.toString();
    map['is_error'] = isError.toString();
    return map;
  }
}
