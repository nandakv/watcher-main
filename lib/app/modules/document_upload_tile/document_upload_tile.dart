import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_border_container.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/document_type_list_model.dart';
import 'package:privo/app/modules/document_upload_tile/document_upload_tile_logic.dart';
import 'package:privo/app/modules/document_upload_tile/model/document_upload_tile_details.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class DocumentUploadTile extends StatefulWidget {
  final bool isEnabled;
  final DocumentUploadTileDetails documentUploadTileDetails;

  const DocumentUploadTile({
    Key? key,
    required this.documentUploadTileDetails,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<DocumentUploadTile> createState() => _DocumentUploadTileState();
}

class _DocumentUploadTileState extends State<DocumentUploadTile> {
  late final DocumentUploadTileLogic logic;

  @override
  void initState() {
    super.initState();
    logic = Get.put(
      DocumentUploadTileLogic(),
      tag: widget.documentUploadTileDetails.tag,
      permanent: true,
    );
    logic.init(widget.documentUploadTileDetails);
  }

  @override
  void dispose() {
    Get.delete<DocumentUploadTileLogic>(
        tag: widget.documentUploadTileDetails.tag, force: true);
    super.dispose();
  }

  Widget _noFileSelectedWidget() {
    return InkWell(
      onTap: widget.documentUploadTileDetails.hideAddDeleteIcon?logic.onAddFileTapped:(){},
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: darkBlueColor, width: 1),
          ),
          child: _titleRowWidget(
              showInfoIcon:
                  widget.documentUploadTileDetails.onInfoTapped != null)),
    );
  }

  Widget _titleRowWidget({bool showInfoIcon = true}) {
    return Row(
      children: [
        _titleWidget(),
        const HorizontalSpacer(8),
        if (showInfoIcon) _infoIcon(),
        const Spacer(),
        if (widget.documentUploadTileDetails.hideAddDeleteIcon)
          _addFileWidget()
      ],
    );
  }

  Widget _titleWidget() {
    return Text(
      widget.documentUploadTileDetails.title,
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 12, color: primaryDarkColor),
    );
  }

  Widget _addFileWidget() {
    return InkWell(
      onTap: logic.onAddFileTapped,
      child: SvgPicture.asset(Res.addIcon),
    );
  }

  Widget _infoIcon() {
    return InkWell(
      onTap: widget.documentUploadTileDetails.onInfoTapped,
      child: SvgPicture.asset(Res.infoIconSVG),
    );
  }

  Widget _fileSelectedWidget() {
    return GradientBorderContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: skyBlueColor.withOpacity(0.1),
        child: Column(
          children: [
            _titleRowWidget(showInfoIcon: false),
            const VerticalSpacer(12),
            _selectedFilesWidget(),
          ],
        ),
      ),
    );
  }

  Widget _selectedFilesWidget() {
    if (logic.documentUploadTileDetails.docSection != null) {
      return Column(
        children: logic.documentUploadTileDetails.docSection!.taggedDocs
            .map((e) => _selectedFileTile(e))
            .toList(),
      );
    }
    return SizedBox();
  }

  Widget _selectedFileTile(TaggedDoc file) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 7),
      child: Row(
        children: [
          SvgPicture.asset(Res.checkCircleBlue),
          const HorizontalSpacer(12),
          Expanded(
            child: Text(
              file.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: primaryDarkColor,
              ),
            ),
          ),
          const HorizontalSpacer(15),
          _svgImage(Res.fileEyeIcon, onTap: () => logic.onEyeTapped(file)),
          const HorizontalSpacer(15),
          if (widget.documentUploadTileDetails.hideAddDeleteIcon)
            _svgImage(
              Res.fileDeleteIcon,
            onTap: () => logic.onFileDeleted(file),
          ),
        ],
      ),
    );
  }

  Widget _svgImage(String iconPath, {required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: SvgPicture.asset(iconPath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: GetBuilder<DocumentUploadTileLogic>(
        tag: widget.documentUploadTileDetails.tag,
        builder: (logic) {
          if (logic.documentUploadTileDetails.docSection == null ||
              logic.documentUploadTileDetails.docSection!.taggedDocs.isEmpty) {
            return _noFileSelectedWidget();
          }
          return _fileSelectedWidget();
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant DocumentUploadTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If we receive updated supported docs from parent then re-initialize the logic
    logic.init(widget.documentUploadTileDetails);
  }
}
