import '../../../api/http_client.dart';
import '../../../api/response_model.dart';
import '../../../models/initial_offer_model.dart';
import '../base_repository.dart';

class InitialOfferRepository extends BaseRepository {
  Future<InitialOfferModel> getInitialOfferDetails() async {
    ApiResponse apiResponse = await HttpClient.get(
        url: "$morpheusBaseUrl/business/appForm/$appFormId/initialOffer");
    return initialOfferModelFromJson(apiResponse);
  }
}
