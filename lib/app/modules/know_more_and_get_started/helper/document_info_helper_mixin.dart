import 'package:privo/app/modules/know_more_and_get_started/model/document_info_bottom_sheet_model.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/res.dart';

mixin DocumentInfoHelperMixin {
  final String _computeInfoText =
      LPCService.instance.isLpcCardTopUp ? "Self-attested p" : "P";

  late final DocumentTypeInfoModelWithImage udyamCertificateInfo =
      DocumentTypeInfoModelWithImage(
          title: "Udyam Certificate",
          info:
              "Your Udyam number is a 11 character code at the top of your Udyam certificate as highlighted here",
          imagePath: Res.udyamCertificate);

  late final DocumentTypeInfoModelWithImage gstCertificateInfo =
      DocumentTypeInfoModelWithImage(
          title: "GST Certificate",
          info:
              "Your GSTIN number is a 15-digit code that identifies a GST registered business in India",
          imagePath: Res.gstCertificate);

  late final DocumentTypeInfoModel ownershipProofInfo = DocumentTypeInfoModel(
      title: "Ownership Proof",
      info: "Proof of ownership of the business premises",
      acceptedDocs:
          "Electricity Bill, Water Bill, Sale Deed, or relevant possession document.");

  late final DocumentTypeInfoModel correspondenceProofInfo =
      DocumentTypeInfoModel(
    title: "Correspondence - Address Proof",
    info: "${_computeInfoText}roof of your individual correspondence address",
    acceptedDocs:
        "Utility bill, bank statement, Aadhaar card, or driver's license.",
  );

  DocumentTypeInfoModel get operationalAddressProofInfo =>
      DocumentTypeInfoModel(
        title: "Operational Office - Address Proof",
        info: "${_computeInfoText}roof of where your business operates.",
        acceptedDocs:
            "GST registration / provisional certificate, Registration under Central Excise and Customs, Professional Tax registration certificate, IEC, Shop, Establishment Act registration or any other official address document",
      );

  late final DocumentTypeInfoModel residentialAddressProofInfo =
      DocumentTypeInfoModel(
    title: "Residential Address Proof",
    info: "Proof of your personal address for correspondence",
    acceptedDocs:
        "Driving License, Voter ID/Election Card, Passport, Utility bills, rental agreement or any other correspondence address document.",
  );

  late final DocumentTypeInfoModel registeredOfficeAddressProofInfo =
      DocumentTypeInfoModel(
          title: "Registered Office - Address Proof",
          info: "${_computeInfoText}roof of your business's official address.",
          acceptedDocs:
              "GST registration / provisional certificate, Registration under Central Excise and Customs, Professional Tax registration certificate, IEC, Shop, Establishment Act registration or any other official address document");

  late final List<DocumentInfoModel> documentInfoList = [
    DocumentInfoModel(title: "Business Documents", requiredDocs: [
      "Udyam Certificate",
      "GST Certificate (if required)",
      "Ownership Proof"
    ], documentInfoWithImageList: [
      udyamCertificateInfo,
      gstCertificateInfo,
    ], documentInfoList: [
      ownershipProofInfo,
    ]),
    DocumentInfoModel(
      title: "Address Proof",
      requiredDocs: [
        "Office Registered Address Proof",
        "Corporate Address Proof",
        "Residential Proof"
      ],
      documentInfoWithImageList: [],
      documentInfoList: [
        registeredOfficeAddressProofInfo,
        operationalAddressProofInfo,
        residentialAddressProofInfo,
      ],
    )
  ];
}
