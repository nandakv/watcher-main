import '../../low_and_grow_navigation_base.dart';
import '../../low_and_grow_user_states.dart';

abstract class LowAndGrowOfferNavigation extends LowAndGrowNavigationBase {
  @override
  navigateUserToState({required LowAndGrowUserStates lowAndGrowStates});
}
