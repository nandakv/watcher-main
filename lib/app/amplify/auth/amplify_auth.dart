import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:privo/app/amplify/auth/auth_logger_mixin.dart';
import 'package:privo/app/api/http_client.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/flavors.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import '../../firebase/analytics.dart';
import '../../utils/web_engage_constant.dart';

enum SignInState { success, error, phoneNumberNotValid }

enum VerifyOTPState { success, error, invalidOTP, notAuthorized }

///this class contains all the functions needs for app Auth using AWS Amplify
class AmplifyAuth {
  static const String CAMPAIGN_SOURCE = 'campaign_source';
  static const AuthSignInStep LOGIN_SUCCESS_CODE =
      AuthSignInStep.confirmSignInWithCustomChallenge;

  static const List<String> INVALID_PHONE_NUMBER_ERROR_LIST = [
    "E0001",
    'Invalid phone number'
  ];

  static const List<String> USER_NOT_EXISTS_ERROR_LIST = [
    "E0002",
    'User does not exist'
  ];
  static const List<String> INVALID_OTP_ERROR_LIST = [
    "E0003",
    'Invalid OTP',
  ];

  ///This is the dummy password used in prod too
  ///cognito needs a password to create a account
  ///user will not use this password, it will be the OTP login
  static const String DUMMY_PASSWORD = 'privo@123';

  ///check if the user is already logged in in the device and returns
  ///a boolean value
  static Future<bool> isUserLoggedIn() async {
    try {
      AuthSession authSession = await Amplify.Auth.fetchAuthSession();
      Get.log("isSignedIn - ${authSession.isSignedIn}");

      return authSession.isSignedIn;
    } on AuthException catch (e) {
      Get.log("$e", isError: true);
      // AppAuthProvider.logout();
      Fluttertoast.showToast(msg: "Session Expired!Please login again");
      return false;
    }
  }

  ///get the cognito userid of the logged in users
  static Future<String> get userID async {
    try {
      AuthUser user = await Amplify.Auth.getCurrentUser();
      Get.log("subId - ${user.userId}");
      return user.userId;
    } on SessionExpiredException catch (e) {
      Fluttertoast.showToast(msg: "Session Expired");
      // await AppAuthProvider.logout();
      return "";
    } on AuthNotAuthorizedException catch (e) {
      Get.log("NotAuthorizedException - not authorized");
      return "";
    } on AuthException catch (e) {
      // await AppAuthProvider.logout();
      Get.log("AuthException - ${e.message}");
      return "";
    } catch (e) {
      // await AppAuthProvider.logout();
      Get.log("AuthException - ${e}");
      return "";
    }
  }

  Future<String?> getJWT() async {
    final mixin = AuthLoggerMixin();
    try {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      final result = await cognitoPlugin.fetchAuthSession();
      final rawAccessToken = result.userPoolTokensResult.value.accessToken.raw;
      // Get.log("Id token = $rawIdToken");
      return rawAccessToken;
    } on SessionExpiredException catch (e) {
      mixin.logSessionExpiredEvent(mixin.sessionExpired, e.message);
      Fluttertoast.showToast(msg: "Session Expired");
      // await AppAuthProvider.logout();
      return null;
    } on AuthNotAuthorizedException catch (e) {
      mixin.logSessionExpiredEvent(mixin.authNotAuthorizedException, e.message);
      Get.log("NotAuthorizedException - not authorized");
      Fluttertoast.showToast(msg: "Session Expired");
      // await AppAuthProvider.logout();
      return null;
    } on AuthException catch (e) {
      if (!e.message.contains("network error")) {
        // await AppAuthProvider.logout();
        return null;
      }
      mixin.logSessionExpiredEvent(mixin.authException, e.message);
      Get.log("AuthException - ${e.message}");
      return null;
    } catch (e) {
      mixin.logSessionExpiredEvent(mixin.generalCatchException, e.toString());
      return null;
    }
  }

  Future<SignInState> signIn({required String phoneNumber}) async {
    try {
      SignInResult _result = await Amplify.Auth.signIn(
        username: "+91$phoneNumber",
        options: const SignInOptions(
          pluginOptions: CognitoSignInPluginOptions(
            authFlowType: AuthenticationFlowType.customAuthWithoutSrp,
          ),
        ),
      );

      if (_result.nextStep.signInStep == LOGIN_SUCCESS_CODE) {
        WebEngagePlugin.setUserPhone(phoneNumber);
        return SignInState.success;
      } else {
        Get.log("sign in error triggered");
        return SignInState.error;
      }
    } on UsernameExistsException catch (e) {
      Get.log("sign in UsernameExistsException - $e");
      return await signUp(phoneNumber: phoneNumber);
    } on LambdaException catch (e) {
      Get.log("sign in LambdaException - $e");
      if (e.message ==
          "DefineAuthChallenge failed with error User does not exist.") {
        return await signUp(phoneNumber: phoneNumber);
      } else if (e.underlyingException != null &&
          checkError(e.message, USER_NOT_EXISTS_ERROR_LIST)) {
        return await signUp(phoneNumber: phoneNumber);
      } else {
        return SignInState.error;
      }
    } on AuthException catch (e) {
      Get.log("sign in AuthException - $e");
      return SignInState.error;
    }
  }

  Future<SignInState> signUp({required String phoneNumber}) async {
    Get.log("doing signup - $phoneNumber");
    try {
      Map<CognitoUserAttributeKey, String> userAttributes = {
        const CognitoUserAttributeKey.custom(CAMPAIGN_SOURCE):
            await AppAuthProvider.getReferralCode
      };

      SignUpResult _result = await Amplify.Auth.signUp(
          username: "+91$phoneNumber",
          password: DUMMY_PASSWORD,
          options: SignUpOptions(userAttributes: userAttributes));
      Get.log("signUp result - ${_result.isSignUpComplete}");
      await AppAnalytics.trackWebEngageUser(
          userAttributeName: "SignupDate",
          userAttributeValue: AppAnalytics.dateTimeNow());
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.userSignUp,
          attributeName: {'Phone Number': phoneNumber});
      await AppAuthProvider.setIsUserSignedUp();
      return await signIn(phoneNumber: phoneNumber);
    } on LambdaException catch (e) {
      Get.log("sign up LambdaException - $e");
      Get.log(e.underlyingException.toString());
      if (e.underlyingException != null &&
          checkError(e.message, INVALID_PHONE_NUMBER_ERROR_LIST)) {
        return SignInState.phoneNumberNotValid;
      }
      return SignInState.error;
    } on AuthException catch (e) {
      Get.log("sign up AuthException - $e");
      return SignInState.error;
    }
  }

  bool checkError(String error, List<String> errorMessageList) {
    for (var element in errorMessageList) {
      if (error.contains(element)) {
        return true;
      }
    }
    return false;
  }

  Future<VerifyOTPState> verifyOTP({required String otp}) async {
    try {
      SignInResult _result =
          await Amplify.Auth.confirmSignIn(confirmationValue: otp);

      Get.log(
          "SignInResult - ${_result.isSignedIn}, ${_result.nextStep.signInStep}, ${_result.nextStep.additionalInfo}");

      return _result.isSignedIn
          ? VerifyOTPState.success
          : VerifyOTPState.invalidOTP;
    } on LambdaException catch (e) {
      Get.log("verify otp LambdaException - $e");
      if (e.underlyingException != null &&
          checkError(e.message, INVALID_OTP_ERROR_LIST)) {
        return VerifyOTPState.invalidOTP;
      }
      return VerifyOTPState.error;
    } on AuthNotAuthorizedException catch (e) {
      Get.log("verify otp AuthException - $e");
      return VerifyOTPState.notAuthorized;
    } on AuthException catch (e) {
      Get.log("verify otp AuthException - $e");
      return VerifyOTPState.error;
    }
  }

  static Future signOut() async {
    await Amplify.Auth.signOut();
  }

  static Future<bool> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    Get.log("logout result = ${result.runtimeTypeName}");
    return result is CognitoCompleteSignOut;
  }
}
