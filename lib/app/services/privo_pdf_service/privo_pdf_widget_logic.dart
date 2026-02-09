import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';

enum PrivoPDFState { loading, success }

class PrivoPDFLogic extends GetxController with ApiErrorMixin {
  PrivoPDFState _privoPDFState = PrivoPDFState.loading;

  PrivoPDFState get privoPDFState => _privoPDFState;

  late String PDF_SCREEN = "pdf_screen";

  set privoPDFState(PrivoPDFState value) {
    _privoPDFState = value;
    update();
  }

  String pdfPath = "";

  void downloadPDF({required String url, required String fileName}) async {
    privoPDFState = PrivoPDFState.loading;
    Get.log("pdf url - $url");
    Get.log("pdf filename - $fileName");
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.pdf');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        try {
          await file.writeAsBytes(response.bodyBytes);
          pdfPath = file.path;
          privoPDFState = PrivoPDFState.success;
        } on Exception catch (e) {
          Get.log('pdf file write exception - $e');
          handleAPIError(
              ApiResponse(
                state: ResponseState.failure,
                apiResponse: response.body,
                url: url,
                statusCode: response.statusCode,
                exception: e.toString(),
              ),
              screenName: PDF_SCREEN,
              retry: () => downloadPDF(url: url, fileName: fileName));
        }
      } else {
        handleAPIError(
            ApiResponse(
              state: ResponseState.failure,
              apiResponse: response.body,
              url: url,
              statusCode: response.statusCode,
            ),
            screenName: PDF_SCREEN,
            retry: () => downloadPDF(url: url, fileName: fileName));
      }
    } on Exception catch (e) {
      Get.log('file execption - $e');
      handleAPIError(
          ApiResponse(
            state: ResponseState.failure,
            apiResponse: "",
            url: url,
            exception: e.toString(),
          ),
          screenName: PDF_SCREEN,
          retry: () => downloadPDF(url: url, fileName: fileName));
    }
  }
}
