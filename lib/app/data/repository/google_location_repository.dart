import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/flavors.dart';

class GoogleLocationRepository extends BaseRepository {

  String fetchLocationCoOrdinatesUrl = "https://www.googleapis.com/geolocation/v1/geolocate?key=${F.envVariables.googleLocationApiKey}";

  Future<ApiResponse> fetchLocationCoOrdinates({required Map body}) async {
    ApiResponse apiResponse = await HttpClient.post(
      url:
          fetchLocationCoOrdinatesUrl,
      body: body,
    );
    return apiResponse;
  }

  Future<ApiResponse> fetchAddressDetailsFromCoOrdinates(
      {required String latLong}) async {
    ApiResponse apiResponse = await HttpClient.get(
      url:
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLong}&key=${F.envVariables.googleLocationApiKey}",
    );
    return apiResponse;
  }
}
