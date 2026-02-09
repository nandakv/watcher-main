import 'dart:convert';

import 'package:get/get.dart';

///Model to process the data for app form request while updating the form


AppFormModel? appFormModelFromJson(String? str) {
  try {
    return AppFormModel.fromJson(json.decode(str!));
  } on Exception catch (e) {
    Get.log(e.toString());
    return null;
  }
}

class AppFormModel {
  AppFormModel({
    required this.id,
    this.partnerLoanId,
    this.restructured,
    this.oldPartnerLoanId,
    this.limitEnhanced,
    this.batchId,
    this.partnerAppId,
    required this.partnerId,
    required this.partnerAppTime,
    required this.partnerDisburseTime,
    required this.partnerSanctionTime,
    required this.source,
    required this.loanType,
    this.creditLine,
    required this.linkedIndividuals,
    this.linkedBusiness,
    this.assetGroup,
    this.dsa,
    required this.loan,
    this.appFormStatus,
    required this.greenChannelFlag,
    this.workflowId,
    this.status,
    this.stage,
    this.creditPolicy,
    this.ckycFlag,
    this.ckycValidationMode,
    this.offerId,
    this.mandate,
    this.invoiceFinancing,
    this.pennyTesting,
    this.kycType,
    this.customerConsents,
    required this.loanProduct,
    this.loanAppDedupe,
    required this.createdAt,
  });
  late final String id;
  late final String? partnerLoanId;
  late final String? restructured;
  late final String? oldPartnerLoanId;
  late final String? limitEnhanced;
  late final String? batchId;
  late final String? partnerAppId;
  late final String partnerId;
  late final String partnerAppTime;
  late final String partnerDisburseTime;
  late final String partnerSanctionTime;
  late final String source;
  late final String loanType;
  late final String? creditLine;
  late final List<LinkedIndividuals> linkedIndividuals;
  late final String? linkedBusiness;
  late final String? assetGroup;
  late final String? dsa;
  late final Loan loan;
  late final String? appFormStatus;
  late final bool greenChannelFlag;
  late final String? workflowId;
  late final String? status;
  late final String? stage;
  late final String? creditPolicy;
  late final String? ckycFlag;
  late final String? ckycValidationMode;
  late final String? offerId;
  late final String? mandate;
  late final String? invoiceFinancing;
  late final String? pennyTesting;
  late final String? kycType;
  late final String? customerConsents;
  late final String loanProduct;
  late final String? loanAppDedupe;
  late final String createdAt;

  AppFormModel.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? "";
    partnerLoanId = null;
    restructured = null;
    oldPartnerLoanId = null;
    limitEnhanced = null;
    batchId = null;
    partnerAppId = null;
    partnerId = json['partnerId'] ?? "";
    partnerAppTime = json['partnerAppTime'] ?? "";
    partnerDisburseTime = json['partnerDisburseTime'] ?? "";
    partnerSanctionTime = json['partnerSanctionTime'] ?? "";
    source = json['source'] ?? "";
    loanType = json['loanType'] ?? "";
    creditLine = null;
    linkedIndividuals = List.from(json['linkedIndividuals'] ?? {} ).map((e)=>LinkedIndividuals.fromJson(e)).toList();
    linkedBusiness = null;
    assetGroup = null;
    dsa = null;
    loan = Loan.fromJson(json['loan'] ?? {});
    appFormStatus = null;
    greenChannelFlag = json['greenChannelFlag']  ?? false;
    workflowId = null;
    status = null;
    stage = null;
    creditPolicy = null;
    ckycFlag = null;
    ckycValidationMode = null;
    offerId = null;
    mandate = null;
    invoiceFinancing = null;
    pennyTesting = null;
    kycType = null;
    customerConsents = null;
    loanProduct = json['loanProduct']  ?? "";
    loanAppDedupe = null;
    createdAt = json['createdAt']  ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['partnerLoanId'] = partnerLoanId;
    _data['restructured'] = restructured;
    _data['oldPartnerLoanId'] = oldPartnerLoanId;
    _data['limitEnhanced'] = limitEnhanced;
    _data['batchId'] = batchId;
    _data['partnerAppId'] = partnerAppId;
    _data['partnerId'] = partnerId;
    _data['partnerAppTime'] = partnerAppTime;
    _data['partnerDisburseTime'] = partnerDisburseTime;
    _data['partnerSanctionTime'] = partnerSanctionTime;
    _data['source'] = source;
    _data['loanType'] = loanType;
    _data['creditLine'] = creditLine;
    _data['linkedIndividuals'] = linkedIndividuals.map((e)=>e.toJson()).toList();
    _data['linkedBusiness'] = linkedBusiness;
    _data['assetGroup'] = assetGroup;
    _data['dsa'] = dsa;
    _data['loan'] = loan.toJson();
    _data['appFormStatus'] = appFormStatus;
    _data['greenChannelFlag'] = greenChannelFlag;
    _data['workflowId'] = workflowId;
    _data['status'] = status;
    _data['stage'] = stage;
    _data['creditPolicy'] = creditPolicy;
    _data['ckycFlag'] = ckycFlag;
    _data['ckycValidationMode'] = ckycValidationMode;
    _data['offerId'] = offerId;
    _data['mandate'] = mandate;
    _data['invoiceFinancing'] = invoiceFinancing;
    _data['pennyTesting'] = pennyTesting;
    _data['kycType'] = kycType;
    _data['customerConsents'] = customerConsents;
    _data['loanProduct'] = loanProduct;
    _data['loanAppDedupe'] = loanAppDedupe;
    _data['createdAt'] = createdAt;
    return _data;
  }
}

class LinkedIndividuals {
  LinkedIndividuals({
    required this.id,
    required this.applicantType,
    required this.customerId,
    required this.dedupe,
    required this.transitionState,
    required this.regulatoryStatus,
    required this.individual,
    required this.bankAccounts,
    required this.kyc,
    required this.addresses,
    required this.contacts,
    required this.webPresenceList,
    required this.partnerBureau,
    required this.references,
  });
  late final int id;
  late final String applicantType;
  late final String customerId;
  late final String dedupe;
  late final String transitionState;
  late final String regulatoryStatus;
  late final Individual individual;
  late final List<dynamic> bankAccounts;
  late final List<Kyc> kyc;
  late final List<Addresses> addresses;
  late final List<Contacts> contacts;
  late final List<dynamic> webPresenceList;
  late final List<dynamic> partnerBureau;
  late final List<dynamic> references;

  LinkedIndividuals.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? "";
    applicantType = json['applicantType'] ?? "";
    customerId = json['customerId'] ?? "";
    dedupe = json['dedupe'] ?? "";
    transitionState = json['transitionState'] ?? "";
    regulatoryStatus = json['regulatoryStatus'] ?? "";
    individual = Individual.fromJson(json['individual']);
    bankAccounts = List.castFrom<dynamic, dynamic>(json['bankAccounts']) ;
    kyc = List.from(json['kyc']).map((e)=>Kyc.fromJson(e)).toList();
    addresses = List.from(json['addresses']).map((e)=>Addresses.fromJson(e)).toList();
    contacts = List.from(json['contacts']).map((e)=>Contacts.fromJson(e)).toList();
    webPresenceList = List.castFrom<dynamic, dynamic>(json['webPresenceList']);
    partnerBureau = List.castFrom<dynamic, dynamic>(json['partnerBureau']);
    references = List.castFrom<dynamic, dynamic>(json['references']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['applicantType'] = applicantType;
    _data['customerId'] = customerId;
    _data['dedupe'] = dedupe;
    _data['transitionState'] = transitionState;
    _data['regulatoryStatus'] = regulatoryStatus;
    _data['individual'] = individual.toJson();
    _data['bankAccounts'] = bankAccounts;
    _data['kyc'] = kyc.map((e)=>e.toJson()).toList();
    _data['addresses'] = addresses.map((e)=>e.toJson()).toList();
    _data['contacts'] = contacts.map((e)=>e.toJson()).toList();
    _data['webPresenceList'] = webPresenceList;
    _data['partnerBureau'] = partnerBureau;
    _data['references'] = references;
    return _data;
  }
}

class Individual {
  Individual({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.salutation,
    required this.accessLevel,
    required this.education,
    required this.maritalStatus,
    this.gender,
    this.cibil,
    required this.dob,
    required this.fatherName,
    required this.fullName,
    this.caste,
    this.religion,
    required this.nationality,
    required this.birthCountry,
    this.parentCountry,
    this.riskCountry,
    required this.defaultCurrency,
    required this.branch,
    required this.language,
    this.aliasName,
    this.dependents,
    this.staffId,
    required this.employmentType,
    required this.sector,
    this.subSector,
    required this.industry,
    required this.category,
    required this.type,
    this.dsaCode,
    this.dsaDepartment,
    this.applicationNo,
    this.coreBankId,
    required this.customerGroup,
    required this.customerStatus,
    required this.sourcingOfficer,
    this.isStlCustomer,
    this.segment,
    this.subSegment,
    this.target,
    this.motherName,
    this.spouseName,
    this.employer,
    this.partyType,
    this.partyRelation,
    this.relatedToDirector,
    this.shareHolding,
    this.empCategory,
    required this.dobAsDateString,
    required this.dobAsDateObj,
    this.staff,
  });
  late final int id;
  late final String firstName;
  late final String middleName;
  late final String lastName;
  late final String salutation;
  late final String accessLevel;
  late final String education;
  late final String maritalStatus;
  late final String? gender;
  late final String? cibil;
  late final String dob;
  late final String fatherName;
  late final String fullName;
  late final String? caste;
  late final String? religion;
  late final String nationality;
  late final String birthCountry;
  late final String? parentCountry;
  late final String? riskCountry;
  late final String defaultCurrency;
  late final String branch;
  late final String language;
  late final String? aliasName;
  late final String? dependents;
  late final String? staffId;
  late final String employmentType;
  late final String sector;
  late final String? subSector;
  late final String industry;
  late final String category;
  late final String type;
  late final String? dsaCode;
  late final String? dsaDepartment;
  late final String? applicationNo;
  late final String? coreBankId;
  late final int customerGroup;
  late final String customerStatus;
  late final int sourcingOfficer;
  late final String? isStlCustomer;
  late final String? segment;
  late final String? subSegment;
  late final String? target;
  late final String? motherName;
  late final String? spouseName;
  late final String? employer;
  late final String? partyType;
  late final String? partyRelation;
  late final String? relatedToDirector;
  late final String? shareHolding;
  late final String? empCategory;
  late final String dobAsDateString;
  late final int dobAsDateObj;
  late final String? staff;

  Individual.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? "";
    firstName = json['firstName'] ?? "";
    middleName = json['middleName'] ?? "";
    lastName = json['lastName'] ?? "";
    salutation = json['salutation'] ?? "";
    accessLevel = json['accessLevel'] ?? "";
    education = json['education'] ?? "";
    maritalStatus = json['maritalStatus'] ?? "";
    gender = null;
    cibil = null;
    dob = json['dob'] ?? "";
    fatherName = json['fatherName'] ?? "";
    fullName = json['fullName'] ?? "";
    caste = null;
    religion = null;
    nationality = json['nationality'] ?? "";
    birthCountry = json['birthCountry'] ?? "";
    parentCountry = null;
    riskCountry = null;
    defaultCurrency = json['defaultCurrency'] ?? "";
    branch = json['branch'] ?? "";
    language = json['language'] ?? "";
    aliasName = null;
    dependents = null;
    staffId = null;
    employmentType = json['employmentType'] ?? "";
    sector = json['sector'] ?? "";
    subSector = null;
    industry = json['industry'] ?? "";
    category = json['category'] ?? "";
    type = json['type'];
    dsaCode = null;
    dsaDepartment = null;
    applicationNo = null;
    coreBankId = null;
    customerGroup = json['customerGroup'] ?? "";
    customerStatus = json['customerStatus'] ?? "";
    sourcingOfficer = json['sourcingOfficer'] ?? "";
    isStlCustomer = null;
    segment = null;
    subSegment = null;
    target = null;
    motherName = null;
    spouseName = null;
    employer = null;
    partyType = null;
    partyRelation = null;
    relatedToDirector = null;
    shareHolding = null;
    empCategory = null;
    dobAsDateString = json['dobAsDateString'] ?? "";
    dobAsDateObj = json['dobAsDateObj'] ?? "";
    staff = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['firstName'] = firstName;
    _data['middleName'] = middleName;
    _data['lastName'] = lastName;
    _data['salutation'] = salutation;
    _data['accessLevel'] = accessLevel;
    _data['education'] = education;
    _data['maritalStatus'] = maritalStatus;
    _data['gender'] = gender;
    _data['cibil'] = cibil;
    _data['dob'] = dob;
    _data['fatherName'] = fatherName;
    _data['fullName'] = fullName;
    _data['caste'] = caste;
    _data['religion'] = religion;
    _data['nationality'] = nationality;
    _data['birthCountry'] = birthCountry;
    _data['parentCountry'] = parentCountry;
    _data['riskCountry'] = riskCountry;
    _data['defaultCurrency'] = defaultCurrency;
    _data['branch'] = branch;
    _data['language'] = language;
    _data['aliasName'] = aliasName;
    _data['dependents'] = dependents;
    _data['staffId'] = staffId;
    _data['employmentType'] = employmentType;
    _data['sector'] = sector;
    _data['subSector'] = subSector;
    _data['industry'] = industry;
    _data['category'] = category;
    _data['type'] = type;
    _data['dsaCode'] = dsaCode;
    _data['dsaDepartment'] = dsaDepartment;
    _data['applicationNo'] = applicationNo;
    _data['coreBankId'] = coreBankId;
    _data['customerGroup'] = customerGroup;
    _data['customerStatus'] = customerStatus;
    _data['sourcingOfficer'] = sourcingOfficer;
    _data['isStlCustomer'] = isStlCustomer;
    _data['segment'] = segment;
    _data['subSegment'] = subSegment;
    _data['target'] = target;
    _data['motherName'] = motherName;
    _data['spouseName'] = spouseName;
    _data['employer'] = employer;
    _data['partyType'] = partyType;
    _data['partyRelation'] = partyRelation;
    _data['relatedToDirector'] = relatedToDirector;
    _data['shareHolding'] = shareHolding;
    _data['empCategory'] = empCategory;
    _data['dobAsDateString'] = dobAsDateString;
    _data['dobAsDateObj'] = dobAsDateObj;
    _data['staff'] = staff;
    return _data;
  }
}

class Kyc {
  Kyc({
    required this.id,
    required this.kycType,
    required this.kycValue,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    this.issueDate,
    this.issuingAuthority,
    required this.fatherName,
    this.motherName,
    this.spouseName,
    required this.dob,
    this.expiryDate,
    this.referenceNo,
    this.nationality,
    this.gender,
    this.passportType,
    required this.issuedCountry,
  });
  late final int id;
  late final String kycType;
  late final String kycValue;
  late final String firstName;
  late final String middleName;
  late final String lastName;
  late final String? issueDate;
  late final String? issuingAuthority;
  late final String fatherName;
  late final String? motherName;
  late final String? spouseName;
  late final String dob;
  late final String? expiryDate;
  late final String? referenceNo;
  late final String? nationality;
  late final String? gender;
  late final String? passportType;
  late final String issuedCountry;

  Kyc.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? "";
    kycType = json['kycType'] ?? "";
    kycValue = json['kycValue'] ?? "";
    firstName = json['firstName'] ?? "";
    middleName = json['middleName'] ?? "";
    lastName = json['lastName'] ?? "";
    issueDate = null;
    issuingAuthority = null;
    fatherName = json['fatherName'] ?? "";
    motherName = null;
    spouseName = null;
    dob = json['dob'] ?? "";
    expiryDate = null;
    referenceNo = null;
    nationality = null;
    gender = null;
    passportType = null;
    issuedCountry = json['issuedCountry'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['kycType'] = kycType;
    _data['kycValue'] = kycValue;
    _data['firstName'] = firstName;
    _data['middleName'] = middleName;
    _data['lastName'] = lastName;
    _data['issueDate'] = issueDate;
    _data['issuingAuthority'] = issuingAuthority;
    _data['fatherName'] = fatherName;
    _data['motherName'] = motherName;
    _data['spouseName'] = spouseName;
    _data['dob'] = dob;
    _data['expiryDate'] = expiryDate;
    _data['referenceNo'] = referenceNo;
    _data['nationality'] = nationality;
    _data['gender'] = gender;
    _data['passportType'] = passportType;
    _data['issuedCountry'] = issuedCountry;
    return _data;
  }
}

class Addresses {
  Addresses({
    required this.id,
    this.type,
    this.line1,
    this.line2,
    this.city,
    this.state,
    this.country,
    required this.pinCode,
    this.ownership,
    this.priority,
  });
  late final int id;
  late final String? type;
  late final String? line1;
  late final String? line2;
  late final String? city;
  late final String? state;
  late final String? country;
  late final String pinCode;
  late final String? ownership;
  late final String? priority;

  Addresses.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? "";
    type = null;
    line1 = null;
    line2 = null;
    city = null;
    state = null;
    country = null;
    pinCode = json['pinCode'] ?? "";
    ownership = null;
    priority = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['line1'] = line1;
    _data['line2'] = line2;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['pinCode'] = pinCode;
    _data['ownership'] = ownership;
    _data['priority'] = priority;
    return _data;
  }
}

class Contacts {
  Contacts({
    required this.id,
    required this.type,
    required this.value,
    this.notify,
    required this.priority,
    required this.typeCode,
    required this.countryCode,
  });
  late final int id;
  late final String type;
  late final String value;
  late final String? notify;
  late final int priority;
  late final String typeCode;
  late final String countryCode;

  Contacts.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? "";
    type = json['type'] ?? "";
    value = json['value'] ?? "";
    notify = null;
    priority = json['priority'] ?? "";
    typeCode = json['typeCode'] ?? "";
    countryCode = json['countryCode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['value'] = value;
    _data['notify'] = notify;
    _data['priority'] = priority;
    _data['typeCode'] = typeCode;
    _data['countryCode'] = countryCode;
    return _data;
  }
}

class Loan {
  Loan({
    required this.id,
    required this.feeDetails,
    required this.loanProduct,
    this.topUp,
    required this.loanRepayMethod,
    this.loanAssetValue,
    this.loanIntRate,
    this.tenure,
    this.amount,
    this.enduse,
    this.loanStartDate,
    this.merchant,
    this.emiScheduleList,
    this.partnerInterestAmount,
    this.productNameList,
    this.mandateSource,
    required this.partnerScore,
    this.downPayment,
    required this.alwBpiTreatment,
    this.partnerEmiAmount,
    this.processingFee,
    this.repayFrq,
    this.repayPftFrq,
    this.nextRepayDate,
    this.nextRepayPftDate,
    this.partnerBpiAmount,
    required this.disbursement,
    required this.fundingAllocation,
    this.disbursalAmount,
    this.coLenderSMAClassificaiton,
    this.fieldInvestigationDate,
    this.fieldInvestigationStatus,
    this.numberOfCoBorrowers,
    this.partnerUtrNumber,
    this.partnerDisbursementAmount,
    this.overAllLoanAmount,
    this.sanctionDate,
    required this.emiType,
    this.status,
    this.amountAsString,
  });
  late final String id;
  late final List<dynamic> feeDetails;
  late final String loanProduct;
  late final String? topUp;
  late final String loanRepayMethod;
  late final String? loanAssetValue;
  late final String? loanIntRate;
  late final String? tenure;
  late final String? amount;
  late final String? enduse;
  late final String? loanStartDate;
  late final String? merchant;
  late final String? emiScheduleList;
  late final String? partnerInterestAmount;
  late final String? productNameList;
  late final String? mandateSource;
  late final double partnerScore;
  late final String? downPayment;
  late final bool alwBpiTreatment;
  late final String? partnerEmiAmount;
  late final String? processingFee;
  late final String? repayFrq;
  late final String? repayPftFrq;
  late final String? nextRepayDate;
  late final String? nextRepayPftDate;
  late final String? partnerBpiAmount;
  late final Disbursement disbursement;
  late final double fundingAllocation;
  late final String? disbursalAmount;
  late final String? coLenderSMAClassificaiton;
  late final String? fieldInvestigationDate;
  late final String? fieldInvestigationStatus;
  late final String? numberOfCoBorrowers;
  late final String? partnerUtrNumber;
  late final String? partnerDisbursementAmount;
  late final String? overAllLoanAmount;
  late final String? sanctionDate;
  late final String emiType;
  late final String? status;
  late final String? amountAsString;

  Loan.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? "";
    feeDetails = List.castFrom<dynamic, dynamic>(json['feeDetails'] ?? []);
    loanProduct = json['loanProduct'] ?? "";
    topUp = null;
    loanRepayMethod = json['loanRepayMethod'] ?? "";
    loanAssetValue = null;
    loanIntRate = null;
    tenure = null;
    amount = null;
    enduse = null;
    loanStartDate = null;
    merchant = null;
    emiScheduleList = null;
    partnerInterestAmount = null;
    productNameList = null;
    mandateSource = null;
    partnerScore = json['partnerScore'] ?? 0.0;
    downPayment = null;
    alwBpiTreatment = json['alwBpiTreatment'] ?? false;
    partnerEmiAmount = null;
    processingFee = null;
    repayFrq = null;
    repayPftFrq = null;
    nextRepayDate = null;
    nextRepayPftDate = null;
    partnerBpiAmount = null;
    disbursement = Disbursement.fromJson(json['disbursement'] ?? {}) ;
    fundingAllocation = json['fundingAllocation'] ?? 0.0;
    disbursalAmount = null;
    coLenderSMAClassificaiton = null;
    fieldInvestigationDate = null;
    fieldInvestigationStatus = null;
    numberOfCoBorrowers = null;
    partnerUtrNumber = null;
    partnerDisbursementAmount = null;
    overAllLoanAmount = null;
    sanctionDate = null;
    emiType = json['emiType'] ?? "";
    status = null;
    amountAsString = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['feeDetails'] = feeDetails;
    _data['loanProduct'] = loanProduct;
    _data['topUp'] = topUp;
    _data['loanRepayMethod'] = loanRepayMethod;
    _data['loanAssetValue'] = loanAssetValue;
    _data['loanIntRate'] = loanIntRate;
    _data['tenure'] = tenure;
    _data['amount'] = amount;
    _data['enduse'] = enduse;
    _data['loanStartDate'] = loanStartDate;
    _data['merchant'] = merchant;
    _data['emiScheduleList'] = emiScheduleList;
    _data['partnerInterestAmount'] = partnerInterestAmount;
    _data['productNameList'] = productNameList;
    _data['mandateSource'] = mandateSource;
    _data['partnerScore'] = partnerScore;
    _data['downPayment'] = downPayment;
    _data['alwBpiTreatment'] = alwBpiTreatment;
    _data['partnerEmiAmount'] = partnerEmiAmount;
    _data['processingFee'] = processingFee;
    _data['repayFrq'] = repayFrq;
    _data['repayPftFrq'] = repayPftFrq;
    _data['nextRepayDate'] = nextRepayDate;
    _data['nextRepayPftDate'] = nextRepayPftDate;
    _data['partnerBpiAmount'] = partnerBpiAmount;
    _data['disbursement'] = disbursement.toJson();
    _data['fundingAllocation'] = fundingAllocation;
    _data['disbursalAmount'] = disbursalAmount;
    _data['coLenderSMAClassificaiton'] = coLenderSMAClassificaiton;
    _data['fieldInvestigationDate'] = fieldInvestigationDate;
    _data['fieldInvestigationStatus'] = fieldInvestigationStatus;
    _data['numberOfCoBorrowers'] = numberOfCoBorrowers;
    _data['partnerUtrNumber'] = partnerUtrNumber;
    _data['partnerDisbursementAmount'] = partnerDisbursementAmount;
    _data['overAllLoanAmount'] = overAllLoanAmount;
    _data['sanctionDate'] = sanctionDate;
    _data['emiType'] = emiType;
    _data['status'] = status;
    _data['amountAsString'] = amountAsString;
    return _data;
  }
}

class Disbursement {
  Disbursement({
    required this.id,
    required this.disbParty,
    required this.disbType,
    this.disbDate,
    this.disbAmount,
    required this.partnerBankId,
    this.ifsc,
    this.accountNo,
    this.acHolderName,
    this.accType,
    this.phoneNumber,
  });
  late final String id;
  late final String disbParty;
  late final String disbType;
  late final String? disbDate;
  late final String? disbAmount;
  late final String partnerBankId;
  late final String? ifsc;
  late final String? accountNo;
  late final String? acHolderName;
  late final String? accType;
  late final String? phoneNumber;

  Disbursement.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? "";
    disbParty = json['disbParty'] ?? "";
    disbType = json['disbType'] ?? "";
    disbDate = null;
    disbAmount = null;
    partnerBankId = json['partnerBankId'] ?? "";
    ifsc = null;
    accountNo = null;
    acHolderName = null;
    accType = null;
    phoneNumber = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['disbParty'] = disbParty;
    _data['disbType'] = disbType;
    _data['disbDate'] = disbDate;
    _data['disbAmount'] = disbAmount;
    _data['partnerBankId'] = partnerBankId;
    _data['ifsc'] = ifsc;
    _data['accountNo'] = accountNo;
    _data['acHolderName'] = acHolderName;
    _data['accType'] = accType;
    _data['phoneNumber'] = phoneNumber;
    return _data;
  }
}