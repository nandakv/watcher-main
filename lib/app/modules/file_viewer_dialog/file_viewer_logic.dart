import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/loan_details_repository.dart';
import 'package:privo/app/models/signed_url_model.dart';

enum FileViewerStatus { loading, success }

class FileViewerLogic extends GetxController with ApiErrorMixin {
  String signedUrl = "";

  FileViewerStatus _fileViewerStatus = FileViewerStatus.loading;

  FileViewerStatus get fileViewerStatus => _fileViewerStatus;

  set fileViewerStatus(FileViewerStatus value) {
    _fileViewerStatus = value;
    update();
  }

  late final String DOCUMENT_VIEWER_SCREEN = "document_viewer_screen";

  LoanDetailsRepository loanDetailsRepository = LoanDetailsRepository();

  @override
  void onInit() {
    super.onInit();
    fileViewerStatus = FileViewerStatus.loading;
  }

  Future<void> fetchSignedUrl(String objectUrl) async {
    SignedUrlModel signedUrlModel =
        await loanDetailsRepository.getUrlSigned(objectUrl);
    switch (signedUrlModel.apiResponse.state) {
      case ResponseState.success:
        signedUrl = signedUrlModel.url;
        fileViewerStatus = FileViewerStatus.success;
        break;
      default:
        handleAPIError(
          signedUrlModel.apiResponse,
          screenName: DOCUMENT_VIEWER_SCREEN,
        );
        break;
    }
  }
}
