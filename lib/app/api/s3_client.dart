import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

class S3Client {
  Future<ApiResponse> uploadFileToS3Bucket(
      {required String filePath,
      required String s3Path,
      Function(int, int)? onUploadProgress}) async {
    try {
      int counter = 0;
      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(filePath),
        path: StoragePath.fromString(s3Path),
        onProgress: (progress) {
          counter++;
          onUploadProgress?.call(
              progress.transferredBytes, progress.totalBytes);
          Get.log(
              'Transferred bytes: ${progress.transferredBytes} with counter $counter');
        },
      ).result;

      Get.log('Uploaded data to location: ${result.uploadedItem.path}');
      return ApiResponse(
        state: ResponseState.success,
        statusCode: 200,
        url: result.uploadedItem.path,
        apiResponse: """
        {"responseBody":{"object_url" : "${result.uploadedItem.path}"}}
        """,
      );
    } on StorageException catch (e) {
      Get.log("Storage Exception - ${e.message}");
      Get.log("Storage Exception - ${e.recoverySuggestion}");
      return ApiResponse(
        state: ResponseState.failure,
        apiResponse: "",
        url: s3Path,
        requestBody: "Direct Upload to s3 bucket with path $s3Path",
        exception: "${e.message}.${e.recoverySuggestion}",
      );
    } on SocketException catch (e) {
      Get.log("SocketException - $e");
      return ApiResponse(
        state: ResponseState.failure,
        apiResponse: "",
        url: s3Path,
        requestBody: "Direct Upload to s3 bucket with path $s3Path",
        exception: "$e",
      );
    } on Exception catch (e) {
      Get.log("Exception - $e");
      return ApiResponse(
        state: ResponseState.failure,
        apiResponse: "",
        url: s3Path,
        requestBody: "Direct Upload to s3 bucket with path $s3Path",
        exception: "$e",
      );
    } catch (e) {
      Get.log("Unkown Exception - $e");
      return ApiResponse(
        state: ResponseState.failure,
        apiResponse: "",
        url: s3Path,
        requestBody: "Direct Upload to s3 bucket with path $s3Path",
        exception: "Unknown error: $e",
      );
    }
  }
}
