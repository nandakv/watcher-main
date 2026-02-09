import 'package:privo/res.dart';

enum RejectionType {
  location(
    title: "Location Unserviceable!",
    message:
        "Unfortunately, you are not eligible at this time as our services are not available in your area. We are working to reach more locations soon",
    image: Res.locationRejectionSVG,
  ),
  kyc(
    title: "KYC Verification Failed",
    message:
        "Unfortunately, you are not eligible at this time as we are unable to verify your KYC details",
    image: Res.kycRejectionSVG,
  ),
  panCard(
    title: "PAN Verification Failed!",
    message:
        "Unfortunately, you are not eligible at this time as we are unable to verify your PAN details",
    image: Res.panRejectionSVG,
  ),
  general(
    title: "We are sorry!",
    message:
        "Unfortunately, you do not meet our eligible criteria at this time. This decision comes from our detailed assessment process",
    image: Res.generalRejectionSVG,
  );

  final String title;
  final String message;
  final String image;

  const RejectionType({
    required this.title,
    required this.message,
    required this.image,
  });
}

class AppFormRejectionModel {
  bool isRejected;
  String errorTitle;
  String errorBody;
  String rejectionCode;
  RejectionType rejectionType;

  AppFormRejectionModel(
      {required this.isRejected,
      required this.rejectionType,
      required this.errorTitle,
      required this.errorBody,
      required this.rejectionCode});
}
