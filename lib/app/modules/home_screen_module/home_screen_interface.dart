import 'package:flutter/material.dart';
import 'package:privo/app/models/home_screen_model.dart';

import '../../models/home_screen_card_model.dart';

abstract class HomeScreenInterface {
  toggleLabel(bool isPrimaryCardHasLoan);

  fetchHomePageV2();

  onAccountDeleted(bool value);

  showHomePageAlert(List<Widget> alertWidgets);

  toggleHomePageTitle(String value);

  toggleExploreMore(bool value);

  createLowAndGrowOfferCard(LpcCard lpcCard, EnhancedOffer enhancedOffer);

  Future<void> redirectToCreditReport();

  navigateToFinSights();

  togglePrimaryCard(bool value);
}
