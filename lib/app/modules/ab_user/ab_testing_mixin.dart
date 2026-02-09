import '../../api/response_model.dart';
import 'ab_testing_model.dart';
import 'ab_testing_repository.dart';

mixin AbTestingMixin {
  late String assignedGroup ;
  Future<void> computeAndFetchAbTesting({
    required String expName,
    required void Function(String assignedGroup) onSuccess,
    required void Function(dynamic response) onFailure,
  }) async {
    final ABTestingModel _abTestingModel =
        await AbTestingRepository().abtUtility(expName: expName);

    switch (_abTestingModel.apiResponse.state) {
      case ResponseState.success:
         assignedGroup = _abTestingModel.assignedGroup ?? "";
        onSuccess(assignedGroup);
        break;

      default:
        onFailure(_abTestingModel.apiResponse);
    }
  }
}
