import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_Model.dart';

import '../../../../../models/pre_approval_offer_model.dart';

abstract class OfferBreakdownData {
  List<OfferTableModel> computeOfferTableModel(OfferSection? offerSection);
}
