class DocumentInfoModel {
  final String title;
  final List<String> requiredDocs;
  final List<DocumentTypeInfoModelWithImage> documentInfoWithImageList;
  final List<DocumentTypeInfoModel> documentInfoList;

  DocumentInfoModel(
      {required this.title,
      required this.requiredDocs,
      required this.documentInfoWithImageList,
      required this.documentInfoList});
}

class DocumentTypeInfoModelWithImage {
  final String title;
  final String info;
  final String imagePath;

  DocumentTypeInfoModelWithImage(
      {required this.title, required this.info, required this.imagePath});
}

class DocumentTypeInfoModel {
  final String title;
  final String acceptedDocs;
  final String info;

  DocumentTypeInfoModel(
      {required this.title, required this.acceptedDocs, required this.info});
}
