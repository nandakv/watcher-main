enum ResponseState {
  success,
  badRequestError,
  failure,
  noInternet,
  notAuthorized,
  timedOut,
  jsonParsingError
}

class ApiResponse {
  ResponseState state;
  String apiResponse;
  String? url;
  int? statusCode;
  String? requestBody;
  String? exception;

  ApiResponse({
    required this.state,
    required this.apiResponse,
    this.url,
    this.statusCode,
    this.requestBody,
    this.exception,
  });

  @override
  String toString() {
    return "state - $state,\napiResponse - $apiResponse,\nurl - $url,\nstatusCode - $statusCode,\nrequestBody - $requestBody,\nexception - $exception";
  }
}
