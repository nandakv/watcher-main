import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/home_screen_model.dart';

import '../services/lpc_service.dart';

DocumentTypeListModel documentTypeListModelFromJson(ApiResponse apiResponse,
    {required String entityId}) {
  return DocumentTypeListModel.decodeResponse(apiResponse, entityId);
}

class DocumentTypeListModel {
  late ApiResponse apiResponse;
  late LinkedIndividualModel linkedIndividual;
  late LinkedBusinessModel linkedBusiness;
  DocumentTypeListModel.decodeResponse(
      ApiResponse apiResponse, String entityId) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse, entityId);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _parseJson(ApiResponse apiResponse, String entityId) {
    Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);

    json['linkedIndividual'].forEach((entity) {
      if ((entity['entityId'] as String) == entityId) {
        linkedIndividual = LinkedIndividualModel.fromJson(entity);
      }
    });
    linkedBusiness = LinkedBusinessModel.fromJson(json['linkedBusiness']);
  }
}

class LinkedIndividualModel {
  late final String entityId;
  late final DocSection correspondenceAddress; //Correspondence address

  LinkedIndividualModel.fromJson(Map<String, dynamic> json) {
    bool isTopUp =
        LPCService.instance.activeCard?.lpcCardType == LPCCardType.topUp;
    entityId = json['entityId'];
    late String documentSection;
    late String sectionPropertyName;
    late String otherPropertyName;
    DocSection? _correspondenceAddress;

    late final Map<String, Function(DocSection doc)> docSectionMapping;

    docSectionMapping = {
      "Correspondence address": (doc) => _correspondenceAddress = doc,
    };

    List<TaggedDoc> correspondingAddressDocs = [];



    Set<String> sectionNames={"Correspondence address","Rental Document",  "Driving License","Voter Id","Passport","Utility Bill","Others"};

    json['docsSections'].forEach((docSection) {
      documentSection = docSection['section'] as String;

      switch (isTopUp) {
        case true:
          for (String docSectionName in sectionNames) {
            if (documentSection.contains(docSectionName)) {
              DocSection doc =   DocSection.fromJson(docSection);
              correspondingAddressDocs.addAll(doc.taggedDocs);
              _correspondenceAddress = doc;
              break;
            }
          }
          break;
        case false:
          for (String docSectionName in docSectionMapping.keys) {
            if (documentSection.contains(docSectionName)) {
              _correspondenceAddress = docSectionMapping[docSectionName]!(
                  DocSection.fromJson(docSection));
              break;
            }
          }
          break;
      }
    });
    _correspondenceAddress ??= DocSection.fromJson({});
    _correspondenceAddress!.taggedDocs = correspondingAddressDocs;
    correspondenceAddress = _correspondenceAddress!;
  }
}

class LinkedBusinessModel {
  late final String entityId;
  late final DocSection registeredAddress; // POA
  late final DocSection operationalAddress; // Operational address
  late final DocSection ownershipProof; // POI
  late final DocSection gst; // GST
  late final DocSection udyamCertificate; // Udyam

  LinkedBusinessModel.fromJson(Map<String, dynamic> json) {
    bool isTopUp =
        LPCService.instance.activeCard?.lpcCardType == LPCCardType.topUp;
    entityId = json['entityId'];
    late String documentSection;
    late String sectionPropertyName;

    DocSection? _registeredAddress; // POA
    DocSection? _operationalAddress; // Operational address
    DocSection? _ownershipProof; // POI
    DocSection? _gst; // GST
    DocSection? _udyamCertificate; // Udyam

    late final Map<String, Function(DocSection doc)> docSectionMapping;
    switch (isTopUp) {
      case true:
        docSectionMapping = {
          "POI": (DocSection doc) => _registeredAddress = doc, //POI
          "POA": (DocSection doc) => _operationalAddress = doc, //POA
        };
        break;
      case false:
        docSectionMapping = {
          "POA": (DocSection doc) => _registeredAddress = doc,
          "Operational address": (DocSection doc) => _operationalAddress = doc,
          "POI": (DocSection doc) => _ownershipProof = doc,
          "GST certificate": (DocSection doc) => _gst = doc,
          "Udyam Certificate": (DocSection doc) => _udyamCertificate = doc
        };
        break;
    }

    List<TaggedDoc> operationalAddressDocs = [];
    List<TaggedDoc> registeredAddressDocs = [];

    Map<String, List<TaggedDoc>> sectionMapping = {
      "POA": operationalAddressDocs,
      "Gst Registration Or Provisional Certificate": operationalAddressDocs,
      "GST certificate": operationalAddressDocs,
      "Others": operationalAddressDocs,
      "Registration Under Central Excise And Customs": operationalAddressDocs,
      "Udyam Certificate": operationalAddressDocs,
      "Professional Tax Registration Certificate": operationalAddressDocs,
      "Iec": operationalAddressDocs,
      "Shop And Establishment Act Registration": operationalAddressDocs,
      "Partnershipdeed": operationalAddressDocs,
      "Utility Bills": operationalAddressDocs,
      "Operational address": operationalAddressDocs,
      "POI": registeredAddressDocs
    };

    // itterate over  json['docsSections'] and check for section contains POA and then parse that object
    json['docsSections'].forEach((docSection) {
      documentSection = docSection['section'] as String;

      switch (isTopUp) {
        case true:
          _linkedBusinessTopUpComputation(
              sectionMapping, documentSection, docSectionMapping, docSection);
          break;
        case false:
          _linkedBusinessComputation(
              docSectionMapping, documentSection, docSection);
          break;
      }
    });

    // check if all required sections are not null
    switch (isTopUp) {
      case true:
        registeredAddress = nullCheckAndAssignForTopUp(_registeredAddress, "POI");
        operationalAddress = nullCheckAndAssignForTopUp(_operationalAddress, "POA");
        registeredAddress.taggedDocs = registeredAddressDocs;
        operationalAddress.taggedDocs = operationalAddressDocs;
        break;
      case false:
        registeredAddress =
            nullCheckAndAssign(_registeredAddress, "Registered address");
        operationalAddress =
            nullCheckAndAssign(_operationalAddress, "Operational address");
        ownershipProof = nullCheckAndAssign(_ownershipProof, "Ownership Proof");
        gst = nullCheckAndAssign(_gst, "GST certificate");
        udyamCertificate =
            nullCheckAndAssign(_udyamCertificate, "Udyam Certificate");
        break;
    }
  }

  void _linkedBusinessComputation(Map<String, Function> docSectionMapping,
      String documentSection, docSection) {
    for (String docSectionName in docSectionMapping.keys) {
      if (documentSection.contains(docSectionName)) {
        docSectionMapping[docSectionName]!(DocSection.fromJson(docSection));
        break;
      }
    }
  }

  void _linkedBusinessTopUpComputation(
      Map<String, List<TaggedDoc>> clubSectionMapping,
      String documentSection,
      Map<String, Function> docSectionMapping,
      docSection) {
    for (String docSectionName in clubSectionMapping.keys) {
      if (documentSection.contains(docSectionName)) {
          DocSection section = DocSection.fromJson(docSection);
          clubSectionMapping[docSectionName]!.addAll(section.taggedDocs);
          if (docSectionMapping.containsKey(docSectionName)){
            docSectionMapping[docSectionName]!(section);
          }
          break;
      }
    }
  }

  DocSection nullCheckAndAssign(DocSection? doc, String sectionName) {
    if (doc == null) {
      throw Exception("$sectionName not found in doctor strange");
    }
    return doc;
  }
  DocSection nullCheckAndAssignForTopUp(DocSection? doc, String sectionName) {

    if (doc == null) {
      return DocSection.fromJson({});
    }
    return doc;
  }
}

class DocSection {
  late final String section;
  late final String sectionId;
  late final int? count;
  late List<AllowedDocType> docs;
  late List<TaggedDoc> taggedDocs;

  DocSection.fromJson(Map<String, dynamic> json) {
    section = json['section'] ?? "";
    sectionId = json['sectionId'] ?? "";
    count = json['count'];
    docs = json['sectionProperty'] != null
        ? List<AllowedDocType>.from(json['sectionProperty']['allowedDocTypes']
            .map((x) => AllowedDocType.fromJson(x)))
        : [];

    // if there is any AllowedDocType with text as "Others" then it should be added at the last. Bankend does't have the functionality of ordering
    for (int i = 0; i < docs.length; i++) {
      if (docs[i].name == "Others") {
        docs.add(docs[i]);
        docs.removeAt(i);
        break;
      }
    }

    taggedDocs = json['docs'] != null
        ? List<TaggedDoc>.from(json['docs'].map((x) => TaggedDoc.fromJson(x)))
        : [];
  }
}

class AllowedDocType {
  late final int id;
  late final String name;

  AllowedDocType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class TaggedDoc {
  late final int id;
  late final String url;
  late final String fileName;

  TaggedDoc({required this.url, required this.fileName, required this.id});

  TaggedDoc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['s3Url'];
    fileName = json['filename'];
  }
}
