import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_waiting/low_and_grow_wait_screen_model.dart';
import '../../api/http_client.dart';

class LowAndGrowRepository extends BaseRepository {
  Future<LowAndGrowWaitScreenModel> onLowAndGrowUpdate() async {
    ApiResponse apiResponse = await HttpClient.post(
        url: "$morpheusBaseUrl/appForm/$appFormId/offerEligibilty");
    return lowAndGrowWaitScreenModelFromJson(apiResponse);
  }
}
