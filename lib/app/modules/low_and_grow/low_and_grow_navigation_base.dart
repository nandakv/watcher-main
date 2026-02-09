import 'package:privo/app/modules/low_and_grow/low_and_grow_user_states.dart';

abstract class LowAndGrowNavigationBase {
  navigateUserToState({required LowAndGrowUserStates lowAndGrowStates});

  toggleBack({required bool isBackDisabled});
}
