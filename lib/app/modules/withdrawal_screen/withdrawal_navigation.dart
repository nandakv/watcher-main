abstract class WithdrawalNavigation {
  navigateToAddressScreen({required Map withdrawalRequestBody});

  navigateToPollingScreen({required bool isFirstWithdrawal});

  toggleWithdrawalLoading({required bool isWithdrawalLoading});

  bool computeIsFirstWithdrawal();

  navigateToSuccessScreen();

  Map withdrawalRequestBody();

  navigateToWithdrawCalculationPage();

}