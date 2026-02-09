import 'package:privo/app/models/document_type_list_model.dart';

class DocumentUploadTileDetails {
  final String tag;
  final String title;
  final Function()? onInfoTapped;
  final Function()? onChanged;
  final Future Function() onAllFileDeleted;
  DocSection docSection;
  final String entityId;
  final bool isUntagged;
  final bool isFromFinalOffer;
  final bool hideAddDeleteIcon;

  DocumentUploadTileDetails({
    required this.tag,
    required this.title,
    required this.onInfoTapped,
    required this.onChanged,
    required this.onAllFileDeleted,
    required this.docSection,
    this.isUntagged = true,
    this.isFromFinalOffer = false,
    required this.entityId,
    this.hideAddDeleteIcon = false,
  });
}
