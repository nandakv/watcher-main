import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/base_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/home_page_cards_model.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/user_state_model.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import '../../models/home_screen_model.dart';
import '../provider/auth_provider.dart';

class HomePageRepository extends BaseRepository {
  Future<UserStateModel> getUserState(
    Map<String, dynamic> body,
  ) async {
    ApiResponse apiResponse =
        await HttpClient.post(url: "$baseUrl/user/state", body: body);
    return userStateModelFromJson(apiResponse);
  }

  Future<HomePageCardsModel> getHomePageCards() async {
    String phoneNumber = await AppAuthProvider.phoneNumber;
    var versionNumber = await PackageInfo.fromPlatform();
    var fcmToken = await FirebaseMessaging.instance.getToken();

    ApiResponse apiResponse =
        await HttpClient.put(url: "$morpheusBaseUrl/home_page/loans", body: {
      "version_number":
          "${versionNumber.version} + ${versionNumber.buildNumber}",
      "fcm_token": fcmToken,
      "phone_number": phoneNumber,
      // "email": await AppAuthProvider.userEmail,
      "source": await AppAuthProvider.getReferralCode
    });

    return homePageCardsModelFromJson(apiResponse);
  }

  Future<HomeScreenCardModel> fetchV2HomePage(LpcCard lpcCard) async {
    Map<String, dynamic> card = lpcCard.toJson();
    ApiResponse apiResponse = await HttpClient.put(
      url: "$morpheusBaseUrl/home_page/v2/loans",
      body: {
        "card": lpcCard.appFormId.isNotEmpty ? card : null,
      },
    );

    return homePageFromJson(apiResponse, lpcCard);
  }

  Future<CheckAppFormModel> withdrawalInferencePolling() async {
    ApiResponse apiResponse = await HttpClient.post(
      url: "$baseUrl/poll?app_form_id=$appFormId&type=is_withdrawal_allowed",
      body: {},
    );
    return checkAppFormModelFromJson(apiResponse);
  }

  Future<HomeScreenModel> getCardsList() async {
    String? advertisingId = await PrivoPlatform.platformService.fetchAdId();
    String phoneNumber = await AppAuthProvider.phoneNumber;
    var versionNumber = await PackageInfo.fromPlatform();
    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } on Exception catch (e) {
      Get.log("execption while parsing fcm token - $e");
    }
    Map body = {
      "versionNumber":
          "${versionNumber.version} + ${versionNumber.buildNumber}",
      "fcmToken": fcmToken,
      "phoneNumber": phoneNumber,
      // "email": await AppAuthProvider.userEmail,
      "source": await AppAuthProvider.getReferralCode,
      if (advertisingId != null && advertisingId.isNotEmpty)
        "maId": advertisingId,
    };
    ApiResponse apiResponse = await HttpClient.put(
        url: "$magnusBaseUrl/homePage/appFormsByPhone", body: body
        // body: body,
        );
    return HomeScreenModel.decodeResponse(
      apiResponse,
      await AppAuthProvider().deviceDetailsRefreshWindow(),
    );
  }
}
