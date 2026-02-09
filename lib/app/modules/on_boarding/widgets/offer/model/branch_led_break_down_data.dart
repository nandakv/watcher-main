import 'package:privo/app/modules/on_boarding/widgets/offer/model/offer_break_down_data.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_Model.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../../../../../models/pre_approval_offer_model.dart';

class BranchLedBreakDownData extends OfferBreakdownData {
  @override
  List<OfferTableModel> computeOfferTableModel(OfferSection? offerSection) {
    return offerSection != null ? _fetchOfferTableData(offerSection) : [];
  }

  List<OfferTableModel> _fetchOfferTableData(OfferSection offerSection) {
    return [
      OfferTableModel(
        title: "Loan Amount",
        value:
            AppFunctions.getIOFOAmount(double.parse(offerSection.loanAmount)),
      ),
      OfferTableModel(
        title: "Rate Of Interest",
        value: "${offerSection.roi}%",
      ),
      OfferTableModel(title: "Tenure", value: "${offerSection.tenure} months"),
      OfferTableModel(
        title: "Annual Percentage Rate (APR)",
        value: "${offerSection.apr}%",
      ),
      OfferTableModel(
        title: "EMI",
        value: AppFunctions.getIOFOAmount(double.parse(offerSection.emi)),
      ),
      OfferTableModel(
        title: "Broken Period Interest (BPI)",
        value: AppFunctions.getIOFOAmount(double.parse(offerSection.bpiAmount)),
      ),
      OfferTableModel(
        title: "Processing Fee*",
        value: AppFunctions.getIOFOAmount(
            double.parse(offerSection.processingFee)),
      ),
      OfferTableModel(
        title: "Document Charges + GST",
        value: AppFunctions.getIOFOAmount(
            double.parse(offerSection.docHandlingFee)),
      ),
    ];
  }
}
