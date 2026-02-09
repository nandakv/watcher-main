import 'package:privo/app/modules/on_boarding/widgets/offer/model/offer_break_down_data.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_Model.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../../../../../models/pre_approval_offer_model.dart';

class TopUpBreakDownData extends OfferBreakdownData {
  @override
  List<OfferTableModel> computeOfferTableModel(OfferSection? offerSection) {
    return offerSection != null ? _fetchTopUpBreakDownData(offerSection) : [];
  }

  List<OfferTableModel> _fetchTopUpBreakDownData(OfferSection offerSection) {
    return [
      OfferTableModel(
        title: "Top-up Amount",
        value: AppFunctions.getIOFOAmount(offerSection.topUpAmount),
      ),
      OfferTableModel(
        title: "Outstanding Balance",
        value:
            "-${AppFunctions.getIOFOAmount(offerSection.outStandingBalance)}",
      ),
      OfferTableModel(
        title: "Broken Period Interest (BPI)",
        value:
            "-${AppFunctions.getIOFOAmount(double.parse(offerSection.bpiAmount))}",
      ),
      OfferTableModel(
        title: "Document charges + GST",
        value:
            "-${AppFunctions.getIOFOAmount(double.parse(offerSection.docHandlingFee))}",
      ),
      OfferTableModel(
        title: "Processing Fee",
        value:
            "-${AppFunctions.getIOFOAmount(double.parse(offerSection.processingFee))}",
      )
    ];
  }
}

class TopUpLoanBreakDownPageData extends OfferBreakdownData {
  @override
  List<OfferTableModel> computeOfferTableModel(OfferSection? offerSection) {
    return offerSection != null
        ? _fetchTopUpBreakDownPageData(offerSection)
        : [];
  }

  List<OfferTableModel> _fetchTopUpBreakDownPageData(
      OfferSection offerSection) {
    return [
      OfferTableModel(
        title: "Top-up Amount",
        value: AppFunctions.getIOFOAmount(offerSection.topUpAmount),
      ),
      OfferTableModel(
        title: "Rate of Interest (ROI)",
        value: "${offerSection.roi}%",
      ),
      OfferTableModel(
        title: "Annual Percentage Rate (APR)",
        value: "${offerSection.apr}%",
      ),
      OfferTableModel(
        title: "Tenure",
        value: "${offerSection.tenure} months",
      ),
      OfferTableModel(
        title: "EMI",
        value: AppFunctions.getIOFOAmount(double.parse(offerSection.emi)),
      )
    ];
  }
}

class TopUpDeductionBreakDownData extends OfferBreakdownData {
  @override
  List<OfferTableModel> computeOfferTableModel(OfferSection? offerSection) {
    return offerSection != null ? _fetchTopUpDeductionsData(offerSection) : [];
  }

  List<OfferTableModel> _fetchTopUpDeductionsData(OfferSection offerSection) {
    return [
      OfferTableModel(
        title: "Outstanding Balance",
        value:
            "-${AppFunctions.getIOFOAmount(offerSection.outStandingBalance)}",
      ),
      OfferTableModel(
        title: "Broken Period Interest (BPI)",
        value:
            "-${AppFunctions.getIOFOAmount(double.parse(offerSection.bpiAmount))}",
      ),
      OfferTableModel(
        title: "Document charges + GST",
        value:
            "-${AppFunctions.getIOFOAmount(double.parse(offerSection.docHandlingFee))}",
      ),
      OfferTableModel(
        title: "Processing Fee",
        value:
            "-${AppFunctions.getIOFOAmount(double.parse(offerSection.processingFee))}",
      )
    ];
  }
}
