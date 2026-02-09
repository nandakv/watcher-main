import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/api/s3_client.dart';
import 'package:privo/app/common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import 'package:privo/app/common_widgets/privo_button.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/on_boarding_repository/additional_business_details_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/document_type_list_model.dart';
import 'package:privo/app/models/file_data.dart';
import 'package:privo/app/models/file_tag_model.dart';
import 'package:privo/app/models/final_offer_polling/appform_tag_doc_model.dart';
import 'package:privo/app/modules/additional_business_details/additional_business_details_analytics_mixin.dart';
import 'package:privo/app/modules/document_upload_tile/model/document_upload_tile_details.dart';
import 'package:privo/app/modules/document_upload_tile/widget/file_upload_restriction_bottom_sheer.dart';
import 'package:privo/app/modules/file_viewer_dialog/file_viewer_dialog.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/modules/additional_business_details/widgets/file_progress_bottom_sheet.dart';
import 'package:privo/flavors.dart';

import '../on_boarding/widgets/final_offer_polling/final_offer_polling_analytics.dart';

enum ProgressStatus {
  uploadInProgress,
  tagging,
  uploadFailed,
  deleteInProgress,
  deleteSuccess
}

class DocumentUploadTileLogic extends GetxController
    with
        ApiErrorMixin,
        ErrorLoggerMixin,
        AppAnalyticsMixin,
        AdditionalBusinessDetailsAnalyticsMixin,
        FinalOfferPollingAnalytics {
  late DocumentUploadTileDetails documentUploadTileDetails;

  AdditionalBusinessDetailsRepository additionalBusinessDetailsRepository =
      AdditionalBusinessDetailsRepository();

  final int MAX_FILE_SIZE = 20 * 1024 * 1024; // 20MB

  late final String PROGRESS_STATUS_ID = "progress_status_id";
  late final String DOCUMENT_UPLOAD_BOTTOM_SHEET =
      "document_upload_bottom_sheet";

  static const String OWNERSHIP_PROOF_TAG = "ownership_proof_tag";
  static const String GST_CERTIFICATE_TAG = "gst_certificate_tag";
  static const String UDYAM_TAG = "udyam_tag";
  static const String CORRESPONDENCE_ADDRESS_TAG = "correspondence_address_tag";
  static const String REGISTERED_ADDRESS_TAG = "registered_address_tag";
  static const String OPERATIONAL_ADDRESS_TAG = "operational_address_tag";
  static const String FINAL_OFFER_POLLING_TAG = "final_offer_polling_tag";

  late final List<String> allowedExtensions = ['pdf', 'jpg', 'png', 'jpeg'];

  late final S3Client _s3Client = S3Client();

  double _progress = 0.0;

  double get progress => _progress;

  late FileData selectedFile;
  late int documentTypeId;

  set progress(double value) {
    _progress = value;
    update([PROGRESS_STATUS_ID]);
  }

  ProgressStatus _progressStatus = ProgressStatus.uploadInProgress;

  ProgressStatus get progressStatus => _progressStatus;

  set progressStatus(ProgressStatus value) {
    _progressStatus = value;
    update([PROGRESS_STATUS_ID]);
  }

  void onFileSelected() async {
    if (documentUploadTileDetails.isUntagged) {
      await _getDocumentTypeId();
    } else {
      _uploadDoc();
    }
    update();
  }

  Future<void> _getDocumentTypeId() async {
    int? docTypeId = await showTypeofDocument();
    if (docTypeId != null) {
      documentTypeId = docTypeId;
      _uploadDoc();
    }
  }

  void _uploadDoc() {
    _showProgressBottomSheet();
    uploadFile();
  }

  _showProgressBottomSheet() async {
    await Get.bottomSheet(
      FileProgressBottomSheet(tag: documentUploadTileDetails.tag),
      isDismissible: false,
      enableDrag: false,
    );
    progress = 0;
    progressStatus = ProgressStatus.uploadInProgress;
  }

  init(DocumentUploadTileDetails documentUploadTileDetails) {
    this.documentUploadTileDetails = documentUploadTileDetails;
  }

  uploadFile() async {
    String s3Path = "";
    if (!documentUploadTileDetails.isUntagged) {
      s3Path = "${AppAuthProvider.appFormID}/${selectedFile.name}";
    } else {
      s3Path =
          "${AppAuthProvider.appFormID}/${documentUploadTileDetails.entityId}/${selectedFile.name}";
    }
    ApiResponse apiResponse = await _s3Client.uploadFileToS3Bucket(
      filePath: selectedFile.path,
      s3Path: s3Path,
      onUploadProgress: (int transferred, int total) {
        Get.log("progress ${transferred / total * 100}%");
        progress = transferred / total;
      },
    );

    switch (apiResponse.state) {
      case ResponseState.success:
        progressStatus = ProgressStatus.tagging;
        _tagfile(_computeFileUrl(s3Path));
        _logFileUploadSuccessEvent();
        break;
      default:
        progressStatus = ProgressStatus.uploadFailed;
        logDocUploadUploadFailed(documentUploadTileDetails.title);
        logError(
          url: apiResponse.url,
          exception: apiResponse.exception,
          requestBody: apiResponse.requestBody,
          responseBody: apiResponse.apiResponse,
          statusCode: apiResponse.statusCode.toString(),
        );
    }
  }

  void _logFileUploadSuccessEvent() {
    if (documentUploadTileDetails.isFromFinalOffer) {
      logAdditionalDocumentUploaded();
    } else {
      logDocUploadSuccessful(documentUploadTileDetails.title);
    }
  }

  retryS3Upload() {
    progress = 0.0;
    progressStatus = ProgressStatus.uploadInProgress;
    uploadFile();
  }

  String _computeFileUrl(String filePath) {
    return "${F.envVariables.s3ObjectPrefixUrl}$filePath";
  }

  Future<int?> showTypeofDocument() async {
    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: "Type of Document",
        radioValues: documentUploadTileDetails.docSection.docs
            .map((e) => e.name)
            .toList(),
        ctaButtonsBuilder: (p0) => [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 10),
            child: PrivoButton(
              onPressed: () {
                Get.back(result: p0.selectedGroupValue);
              },
              title: "Continue Upload",
            ),
          )
        ],
        isScrollBarVisible: true,
      ),
      enableDrag: false,
      isDismissible: false,
    );

    if (result != null) {
      Get.log("selected type ${result}");
      return getDocumentTypeId(result);
    }

    return null;
  }

  int getDocumentTypeId(String name) {
    return documentUploadTileDetails.docSection.docs
        .firstWhere((element) => element.name == name)
        .id;
  }

  void _tagfile(String s3Url) async {
    await Future.delayed(const Duration(
        seconds: 2)); // Need to show loading for atleast 2 sec as api is fast
    if (documentUploadTileDetails.isUntagged) {
      await _tagUploadedFile(s3Url);
    } else {
      await _uploadAppFormDocTagFile(s3Url);
    }
    update();
    Get.back(); // TO dismiss the progress bottom sheet
  }

  _uploadAppFormDocTagFile(String s3Url) async {
    AppFormTagDocModel appFormTagDocModel =
        await additionalBusinessDetailsRepository.tagAppFormDoc(
            s3Urls: [s3Url], appFormId: AppAuthProvider.appFormID);

    switch (appFormTagDocModel.apiResponse.state) {
      case ResponseState.success:
        documentUploadTileDetails.docSection.taggedDocs
            .add(appFormTagDocModel.taggedDoc);
        documentUploadTileDetails.onChanged?.call();
        break;
      default:
        handleAPIError(
          appFormTagDocModel.apiResponse,
          screenName: DOCUMENT_UPLOAD_BOTTOM_SHEET,
          retry: () => _tagfile(s3Url),
        );
    }
  }

  _tagUploadedFile(String s3Url) async {
    FileTagModel fileTagModel =
        await additionalBusinessDetailsRepository.tagFile(
            s3Url: s3Url,
            applicantId: documentUploadTileDetails.entityId,
            docTypeId: documentTypeId.toString(),
            sectionId: documentUploadTileDetails.docSection.sectionId);

    switch (fileTagModel.apiResponse.state) {
      case ResponseState.success:
        _onFileTagSuccess(fileTagModel);
        break;
      default:
        _onApiError(fileTagModel, s3Url);
    }
  }

  void _onApiError(FileTagModel fileTagModel, String s3Url) {
    handleAPIError(
      fileTagModel.apiResponse,
      screenName: DOCUMENT_UPLOAD_BOTTOM_SHEET,
      retry: () => _tagfile(s3Url),
    );
  }

  void _onFileTagSuccess(FileTagModel fileTagModel) {
    documentUploadTileDetails.docSection.docs.clear();
    documentUploadTileDetails.docSection.docs.addAll(fileTagModel.docs);
    documentUploadTileDetails.docSection.taggedDocs.add(fileTagModel.taggedDoc);
    documentUploadTileDetails.onChanged?.call();
  }

  void onFileDeleted(TaggedDoc doc) async {
    progressStatus = ProgressStatus.deleteInProgress;
    selectedFile = FileData(name: doc.fileName, path: "");

    _showProgressBottomSheet();
    deleteFile(doc);
  }

  void deleteFile(TaggedDoc doc) async {
    await Future.delayed(const Duration(
        seconds: 1)); // Need to show loading for atleast 1 sec as api is fast

    ApiResponse apiResponse =
        await additionalBusinessDetailsRepository.deleteFile(doc.id);

    switch (apiResponse.state) {
      case ResponseState.success:
        progress = 1;
        progressStatus = ProgressStatus.deleteSuccess;
        await Future.delayed(const Duration(seconds: 1));
        // give delay for 1 second and then dismiss the bottom sheet

        documentUploadTileDetails.docSection.taggedDocs
            .removeWhere((element) => element.id == doc.id);

        if (documentUploadTileDetails.docSection.taggedDocs.isEmpty) {
          await documentUploadTileDetails.onAllFileDeleted();
        }
        Get.back();
        logDocUploadUploadDeleted(documentUploadTileDetails.title);
        documentUploadTileDetails.onChanged?.call();
        update();
        break;
      default:
        Get.back();
        handleAPIError(
          apiResponse,
          screenName: DOCUMENT_UPLOAD_BOTTOM_SHEET,
          retry: () => deleteFile(doc),
        );
    }
  }

  onAddFileTapped() async {
    Get.focusScope?.unfocus();
    try {
      _logTapEvents();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: allowedExtensions,
        type: FileType.custom,
      );
      if (result != null) {
        List<File> files = result.paths
            .where((path) => path != null)
            .toList()
            .map((path) => File(path!))
            .toList();
        String filePath = files.first.path;
        String fileExtension = filePath.split(".").last;
        bool isExtensionValid = allowedExtensions.contains(fileExtension);
        if (!isExtensionValid) {
          _showFileUploadErrorBottomSheet(
              "${fileExtension.toUpperCase()} files are not allowed. You can retry with the allowed extensions: ${allowedExtensions.join(", ")}");
          return;
        }

        int fileSize = (await files.first.length()).toInt();
        if (fileSize > MAX_FILE_SIZE) {
          _showFileUploadErrorBottomSheet(
              "Your file seems to be greater than 20 MB, please select a file that is less than 20 MB in size");
        } else {
          selectedFile = FileData(
            name: filePath.split('/').last,
            path: filePath,
          );
          onFileSelected();
        }
      }
    } catch (e) {
      logError(
        url: "",
        exception: e.toString(),
        requestBody: "Failed when selecting a file ",
        responseBody: "",
        statusCode: "",
      );
    }
  }

  void _logTapEvents() {
    if (documentUploadTileDetails.isFromFinalOffer) {
      logAdditionalDocumentClicked();
    } else {
      logDocUploadClicked(documentUploadTileDetails.title);
    }
  }

  _showFileUploadErrorBottomSheet(String message) {
    Get.bottomSheet(FileUploadRestrictionBottomSheet(
      onRetry: onAddFileTapped,
      message: message,
    ));
  }

  void onEyeTapped(TaggedDoc file) {
    Get.dialog(
      FileViewerDialog(file: file),
    );
  }
}
