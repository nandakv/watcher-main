import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/document_type_list_model.dart';
import 'package:privo/app/modules/file_viewer_dialog/file_viewer_logic.dart';
import 'package:privo/app/services/privo_pdf_service/privo_pdf_widget_view.dart';
import 'package:privo/res.dart';

class FileViewerDialog extends StatefulWidget {
  final TaggedDoc file;
  const FileViewerDialog({Key? key, required this.file}) : super(key: key);

  @override
  State<FileViewerDialog> createState() => _FileViewerDialogState();
}

class _FileViewerDialogState extends State<FileViewerDialog>
    with AfterLayoutMixin {
  final logic = Get.put(FileViewerLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          _closeIcon(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _computeBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeIcon() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: SvgPicture.asset(Res.close_mark_svg),
      ),
    );
  }

  Widget _computeBody() {
    return GetBuilder<FileViewerLogic>(
      builder: (logic) {
        switch (logic.fileViewerStatus) {
          case FileViewerStatus.loading:
            return _loadingWidget();
          case FileViewerStatus.success:
            return _computeFileTypeWidget();
          default:
            return Container();
        }
      },
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _computeFileTypeWidget() {
    String ext = widget.file.fileName.split('.').last;
    switch (ext) {
      case 'pdf':
        return _pdfViewer();
      case 'jpg':
      case 'png':
      case 'jpeg':
        return _imageViewer();
      default:
        return Container();
    }
  }

  Widget _imageViewer() {
    return Image.network(
      logic.signedUrl,
      fit: BoxFit.contain,
      loadingBuilder: _loadingWidgetBuilder,
    );
  }

  Widget _loadingWidgetBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    return _loadingWidget();
  }

  Widget _pdfViewer() {
    return PrivoPDFWidget(
      url: logic.signedUrl,
      fileName: widget.file.fileName,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.fetchSignedUrl(widget.file.url);
  }
}
