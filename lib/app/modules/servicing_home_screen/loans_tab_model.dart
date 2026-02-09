import '../../models/loans_model.dart';

enum LoanTabState { loading, empty, success, error }

class LoansTabModel {
  final String title;
  final String cif;
  final String appFormId;
  late bool? offerHistoryAvailable;
  late LoansModel? loansModel;
  late LoanTabState state;

  LoansTabModel({
    required this.title,
    required this.cif,
    required this.appFormId,
    this.offerHistoryAvailable = false,
    this.loansModel,
    required this.state,
  });
}
