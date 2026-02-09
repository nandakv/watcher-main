import 'package:flutter/cupertino.dart';
import 'package:privo/app/models/arguments_model/route_arguments.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/modules/payment/payment_view.dart';

import '../../../models/loan_cancellation_details_model.dart';
import 'loan_breakdown_model.dart';

class PaymentViewArgumentModel extends RouteArguments {
  final String loanId;
  final PaymentType paymentType;
  List<LoanBreakdownRowData> breakdownRowData;
  final String totalAmoutKey;
  final String totalAmountValue;
  final EdgeInsets bottomWidgetPadding;
  final num finalPayableAmount;
  final String appFormID;
  final LoanDetailsModel? loanDetailsModel;
  final LoanCancellationDetailsModel? loanCancellationDetails;

  PaymentViewArgumentModel({
    required this.loanId,
    required this.paymentType,
    required this.breakdownRowData,
    required this.appFormID,
    this.totalAmoutKey = '',
    this.totalAmountValue = '',
    this.loanDetailsModel,
    this.bottomWidgetPadding =
        const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    required this.finalPayableAmount,
    this.loanCancellationDetails,
  });
}
