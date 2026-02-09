import '../../../api/http_client.dart';
import '../../../api/response_model.dart';
import '../../../models/check_app_form_model.dart';
import '../base_repository.dart';

enum LocationAvailabilityState {
  fetchedSuccessfully,
  noPermissionOrDisabled,
  technicalIssues
}

class DeviceDetailRepository extends BaseRepository {
  Future<CheckAppFormModel> postDeviceDetails({
    required Map data,
    required bool isIncremental,
  }) async {
    ApiResponse apiResponse = await HttpClient.post(
      url: _computeURL(isIncremental),
      body: data,
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  String _computeURL(bool isIncremental) => isIncremental
      ? "$morpheusBaseUrl/userTracking/userData?type=deviceDetails"
      : "$morpheusBaseUrl/appForm/$appFormId/preProcessor?inputType=customer_device_details";
}
