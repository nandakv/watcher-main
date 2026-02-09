import 'package:privo/app/modules/on_boarding/widgets/bank_details/bank_details_logic.dart';

class PennyTestingDataTransferModel {
  DateTime? validUpto;
  PennyTestingType pennyTestingType;
  DateTime? currentTime;

  PennyTestingDataTransferModel(
      {this.validUpto,
      this.pennyTestingType = PennyTestingType.forward,
      this.currentTime});
}
