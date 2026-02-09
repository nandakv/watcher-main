import 'package:flutter/widgets.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/document_upload_tile/document_upload_tile.dart';
import 'package:privo/app/modules/document_upload_tile/model/document_upload_tile_details.dart';
import 'package:privo/app/theme/app_colors.dart';

class DocumentSection extends StatelessWidget {
  final List<DocumentUploadTileDetails> documentUploadTileDetailsList;
  final String infoText;
  final bool isEnabled;
  const DocumentSection({
    super.key,
    required this.documentUploadTileDetailsList,
    this.infoText =
        "Upload files PDF, JPEG, PNG formats under 20 MB. Ensure clarity and name files descriptively",
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Documents"),
        const VerticalSpacer(6),
        _documentsInfoText(),
        ...documentUploadTileDetailsList
            .map((documentUploadTileDetails) =>
                _docUploadTile(documentUploadTileDetails))
            .toList(),
        const VerticalSpacer(40),
      ],
    );
  }

  Widget _docUploadTile(DocumentUploadTileDetails documentUploadTileDetails) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: DocumentUploadTile(
        isEnabled: isEnabled,
        documentUploadTileDetails: documentUploadTileDetails,
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: navyBlueColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _documentsInfoText() {
    return Text(
      infoText,
      style: const TextStyle(
        fontSize: 10,
        height: 1.3,
        color: darkBlueColor,
      ),
    );
  }
}
