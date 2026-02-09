import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/document_upload_tile/document_upload_tile_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class FileProgressBottomSheet extends StatefulWidget {
  final String tag;
  const FileProgressBottomSheet({Key? key, required this.tag})
      : super(key: key);

  @override
  State<FileProgressBottomSheet> createState() =>
      _FileProgressBottomSheetState();
}

class _FileProgressBottomSheetState extends State<FileProgressBottomSheet> {
  late DocumentUploadTileLogic logic;

  @override
  void initState() {
    logic = Get.find<DocumentUploadTileLogic>(tag: widget.tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BottomSheetWidget(
        enableCloseIconButton: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 28),
          child: _uploadStatusWidget(),
        ),
      ),
    );
  }

  _titleWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 17,
        color: darkBlueColor,
      ),
    );
  }

  Widget _docIcon(Color color) {
    return SvgPicture.asset(
      Res.doc,
      height: 20,
      width: 20,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }

  Widget _uploadStatusTile() {
    return GradientBorderContainer(
      color: lightSkyBlueColor,
      borderRadius: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        child: _computeTile(),
      ),
    );
  }

  Widget _computeTile() {
    switch (logic.progressStatus) {
      case ProgressStatus.uploadInProgress:
      case ProgressStatus.tagging:
        return _uploadInProgressRow();
      case ProgressStatus.uploadFailed:
        return _uploadFailedRow();
      case ProgressStatus.deleteInProgress:
        return _uploadInProgressRow(progressColor: Colors.red);
      case ProgressStatus.deleteSuccess:
        return _uploadInProgressRow(
            progressColor: Colors.red, successIcon: Res.checkCircleRed);
    }
  }

  Widget _uploadInProgressRow(
      {Color progressColor = greenColor,
      String successIcon = Res.success_icon}) {
    int percentage = (logic.progress * 100).toInt();
    return Column(
      children: [
        Row(
          children: [
            _docIcon(darkBlueColor),
            const HorizontalSpacer(8),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      logic.selectedFile.name,
                      style: _fileNameTextStyle(darkBlueColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const HorizontalSpacer(6),
                  _uploadPercentageText(percentage),
                ],
              ),
            ),
            const HorizontalSpacer(6),
            if (percentage == 100)
              SvgPicture.asset(successIcon, height: 18, width: 18),
          ],
        ),
        _uploadProgressWidget(progressColor)
      ],
    );
  }

  Widget _uploadFailedRow() {
    return Row(
      children: [
        _docIcon(Colors.red),
        const HorizontalSpacer(8),
        Expanded(
          child: Text(
            logic.selectedFile.name,
            style: _fileNameTextStyle(Colors.red),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const HorizontalSpacer(6),
        _retryIcon()
      ],
    );
  }

  Widget _uploadPercentageText(int percentage) {
    return Text(
      "($percentage%)",
      style: _fileNameTextStyle(darkBlueColor),
    );
  }

  TextStyle _fileNameTextStyle(Color color) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: color,
    );
  }

  Widget _uploadProgressWidget(Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10),
      child: LinearProgressIndicator(
        value: logic.progress,
        backgroundColor: lightGrayColor,
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _retryIcon() {
    return SizedBox(
      height: 34,
      width: 34,
      child: IconButton(
        onPressed: logic.retryS3Upload,
        icon: SvgPicture.asset(Res.retryIcon, height: 16, width: 16),
      ),
    );
  }

  Widget _uploadStatusWidget() {
    return GetBuilder<DocumentUploadTileLogic>(
      tag: widget.tag,
      id: logic.PROGRESS_STATUS_ID,
      builder: (logic) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpacer(8),
            _computeTitleBar(),
            const VerticalSpacer(24),
            _uploadStatusTile(),
          ],
        );
      },
    );
  }

  Widget _computeTitleBar() {
    switch (logic.progressStatus) {
      case ProgressStatus.uploadFailed:
        return _titleWidget("Upload Failed");
      case ProgressStatus.uploadInProgress:
        return _titleWidget("Uploading");
      case ProgressStatus.tagging:
        return _taggingWidget();
      case ProgressStatus.deleteInProgress:
      case ProgressStatus.deleteSuccess:
        return _titleWidget("Deleting");
    }
  }

  Widget _taggingWidget() {
    return Row(
      children: [
        _titleWidget("Processing..."),
        const Spacer(),
        const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ],
    );
  }
}
